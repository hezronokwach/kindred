import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/morphic_state.dart' as morphic;
import '../models/business_data.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import '../handlers/intent_handler.dart';
import '../handlers/inventory_handler.dart';
import '../handlers/finance_handler.dart';
import '../handlers/retail_handler.dart';
import '../handlers/default_handler.dart';

class GeminiService {
  final String apiKey;
  final List<Map<String, dynamic>> _conversationHistory = [];
  static const int maxHistoryLength = 10;

  final Map<morphic.Intent, IntentHandler> _handlers = {
    morphic.Intent.inventory: InventoryHandler(),
    morphic.Intent.updateStock: InventoryHandler(),
    morphic.Intent.addProduct: InventoryHandler(),
    morphic.Intent.deleteProduct: InventoryHandler(),
    morphic.Intent.finance: FinanceHandler(),
    morphic.Intent.accountBalance: FinanceHandler(),
    morphic.Intent.retail: RetailHandler(),
  };

  final IntentHandler _defaultHandler = DefaultHandler();

  GeminiService({required this.apiKey});

  List<Map<String, dynamic>> _getTools() {
    return [
      {
        'function_declarations': [
          {
            'name': 'get_products',
            'description': 'Get all products in inventory including stock and price.',
            'parameters': {
              'type': 'object',
              'properties': {},
            }
          },
          {
            'name': 'get_expenses',
            'description': 'Get all business expenses.',
            'parameters': {
              'type': 'object',
              'properties': {},
            }
          },
          {
            'name': 'get_account_balance',
            'description': 'Get the current available funds in the business account.',
            'parameters': {
              'type': 'object',
              'properties': {},
            }
          }
        ]
      }
    ];
  }

  Future<String> _buildSystemPrompt() async {
    return '''Shoe store assistant. You have access to tools to fetch real-time data.
IMPORTANT: Always call tools FIRST to get current data before providing your final JSON response.
Once you have the tool results, use them to fulfill the user's request specifically.

JSON Output Format (Strict JSON ONLY):
{"intent":"inventory|finance|retail|updateStock|deleteProduct|addProduct|accountBalance","ui_mode":"table|chart|image|narrative|action","header_text":"...","narrative":"...","entities":{},"confidence":0-1}

Specific Rules:
- "Can I afford [X] [Product]" -> get_account_balance + get_products. Then return intent "accountBalance" with entities {"product_name":"...", "quantity":X}.
- "Order [X] [Product]" -> get_products. Then return intent "updateStock", ui_mode "action", entities {"product_name":"...", "quantity":X}.
- "Add product [Name]" -> return intent "addProduct", ui_mode "action", entities {"product_name":"...", "price":..., "quantity":...}.
- "Show Nike" -> return intent "retail", ui_mode "image", entities {"product_name":"Nike"}.
- "Show inventory" or "What do we have" -> get_products. Then return intent "inventory", ui_mode "table".
- "Show expenses" or "finance summary" -> get_expenses. Then return intent "finance", ui_mode "chart".

Extremum Queries (Lowest/Highest):
- "Cheapest product" -> get_products. Entities: {"sort_by": "price_asc", "limit": 1}.
- "Most expensive product" -> get_products. Entities: {"sort_by": "price_desc", "limit": 1}.
- "Lowest stock shoe" -> get_products. Entities: {"sort_by": "stock_asc", "limit": 1}.
- "Highest stock shoe" -> get_products. Entities: {"sort_by": "stock_desc", "limit": 1}.
- "Category with highest spending" -> get_expenses. Entities: {"category_extremum": "highest"}.
- Narrative MUST mention the specific product/category name and its value.
- IMPORTANT: Do NOT extract generic words like "product", "item", "shoe", or "expense" into "product_name" or "category_filter". Use these entities ONLY for specific names (e.g., "Nike", "Adidas", "Food").
- For "lowest/highest" queries, use "sort_by" and "limit": 1 as shown above.

Filtering & Sorting Entities:
- Inventory: "stock_filter" ("<10", ">5"), "price_filter" ("<100", ">50"), "product_name" (search), "sort_by" ("stock_asc", "stock_desc", "price_asc", "price_desc").
- Finance: "time_filter" ("today", "last_week", "last_month"), "product_filter" (search), "category_filter" (search), "sort_by" ("amount_asc", "amount_desc", "date_asc", "date_desc").
- Example: "Show low stock products" -> entities {"stock_filter": "<10"}.
- Example: "Sort by price descending" -> entities {"sort_by": "price_desc"}.

- Use tool data. Never say "I will check" in the final JSON narrative; provide the actual answer.''';
  }

  Future<morphic.MorphicState> analyzeQuery(String userInput) async {
    try {
      _conversationHistory.add({
        'role': 'user',
        'parts': [{'text': userInput}]
      });

      if (_conversationHistory.length > maxHistoryLength) {
        _conversationHistory.removeAt(0);
      }

      final systemPrompt = await _buildSystemPrompt();
      
      return await _processWithGemini(systemPrompt, functionCallCount: 0);
    } catch (e) {
      return _errorState('Connection error: $e');
    }
  }

  Future<morphic.MorphicState> _processWithGemini(
    String systemPrompt, {
    int retryCount = 0,
    int functionCallCount = 0,
  }) async {
    if (functionCallCount > 5) {
      return _errorState('AI loop detected. Please try a different query.');
    }

    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'system_instruction': {
          'parts': [{'text': systemPrompt}]
        },
        'contents': _conversationHistory,
        'tools': _getTools(),
        'generationConfig': {
          'temperature': 0.7,
          'responseMimeType': 'application/json',
        }
      }),
    ).timeout(const Duration(seconds: 15));

    if (response.statusCode == 429) {
      if (retryCount < 2) {
        // Rate limit hit, wait and retry
        await Future.delayed(Duration(seconds: 3 * (retryCount + 1)));
        return await _processWithGemini(systemPrompt, retryCount: retryCount + 1, functionCallCount: functionCallCount);
      } else {
        return _errorState('API quota exhausted. Please wait a minute before trying again.');
      }
    }

    if (response.statusCode != 200) {
      return _errorState('API error: ${response.statusCode}. ${response.body}');
    }

    final data = jsonDecode(response.body);
    final candidate = data['candidates'][0];
    final parts = candidate['content']['parts'] as List;

    // Check for function calls
    for (var part in parts) {
      if (part.containsKey('functionCall')) {
        final functionCall = part['functionCall'];
        final functionName = functionCall['name'];
        final args = functionCall['args'] ?? {};

        final toolResult = await _executeTool(functionName, args);
        
        // Add function call and result to history
        _conversationHistory.add(candidate['content']);
        _conversationHistory.add({
          'role': 'user', // REST API expects 'user' for functionResponse
          'parts': [
            {
              'functionResponse': {
                'name': functionName,
                'response': {'content': toolResult}
              }
            }
          ]
        });

        // Recurse with tool results
        return await _processWithGemini(systemPrompt, retryCount: retryCount, functionCallCount: functionCallCount + 1);
      }
    }

    // No more function calls, save the final response to history
    _conversationHistory.add(candidate['content']);

    // Parse the JSON response
    final content = parts[0]['text'];
    final decoded = jsonDecode(content);
    
    Map<String, dynamic> aiResponse;
    if (decoded is Map<String, dynamic>) {
      aiResponse = decoded;
    } else if (decoded is List && decoded.isNotEmpty && decoded[0] is Map<String, dynamic>) {
      aiResponse = decoded[0] as Map<String, dynamic>;
    } else {
      return _errorState('AI returned invalid format. Please try again.');
    }
    
    // Fetch products and expenses for the handlers (from DB)
    final products = await BusinessData.getProducts();
    final expenses = await BusinessData.getExpenses();
    
    return await _parseResponse(aiResponse, products, expenses);
  }

  Future<dynamic> _executeTool(String name, Map<String, dynamic> args) async {
    switch (name) {
      case 'get_products':
        final products = await BusinessData.getProducts();
        return products.map((p) => {
          'name': p.name,
          'price': p.price,
          'stock': p.stockCount,
          'category': p.category,
        }).toList();
      case 'get_expenses':
        final expenses = await BusinessData.getExpenses();
        return expenses.map((e) => {
          'category': e.category,
          'amount': e.amount,
          'date': e.date.toIso8601String(),
          'productName': e.productName,
        }).toList();
      case 'get_account_balance':
        return await AccountHelper.getAvailableFunds();
      default:
        return 'Unknown tool';
    }
  }

  Future<morphic.MorphicState> _parseResponse(Map<String, dynamic> response, List<client.Product> products, List<client.Expense> expenses) async {
    final intentStr = response['intent'] ?? 'unknown';
    final uiModeStr = response['ui_mode'] ?? 'narrative';
    final narrative = response['narrative'] ?? 'I\'m not sure how to help with that.';
    final headerText = response['header_text'];
    final confidence = (response['confidence'] ?? 1.0).toDouble();
    final entitiesRaw = response['entities'];
    final Map<String, dynamic> entities = entitiesRaw is Map<String, dynamic> ? entitiesRaw : {};

    final intent = morphic.Intent.values.firstWhere(
      (e) => e.name == intentStr,
      orElse: () => morphic.Intent.unknown,
    );

    final uiMode = morphic.UIMode.values.firstWhere(
      (e) => e.name == uiModeStr,
      orElse: () => morphic.UIMode.narrative,
    );

    final handler = _handlers[intent] ?? _defaultHandler;

    return await handler.handle(
      response: response,
      products: products,
      expenses: expenses,
      intent: intent,
      uiMode: uiMode,
      narrative: narrative,
      headerText: headerText,
      confidence: confidence,
      entities: entities,
    );
  }

  morphic.MorphicState _errorState(String message) {
    return morphic.MorphicState(
      intent: morphic.Intent.unknown,
      uiMode: morphic.UIMode.narrative,
      narrative: message,
      confidence: 0.0,
    );
  }
}
