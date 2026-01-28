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
Always fetch data before answering questions about inventory, finance, or balance.

JSON Output Format:
{"intent":"inventory|finance|retail|updateStock|deleteProduct|addProduct|accountBalance","ui_mode":"table|chart|image|narrative|action","header_text":"...","narrative":"...","entities":{},"confidence":0-1}

Rules:
- Affordability → fetch balance AND product price, then compare.
- Order/Buy → updateStock+action.
- "show Nike Air Max" → retail+image+{"product_name":"Nike Air Max"}.
- Use tools to get current data. Do not hallucinate numbers.''';
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
      
      return await _processWithGemini(systemPrompt);
    } catch (e) {
      return _errorState('Connection error: $e');
    }
  }

  Future<morphic.MorphicState> _processWithGemini(String systemPrompt) async {
    final response = await http.post(
      Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contents': [
          {'role': 'user', 'parts': [{'text': systemPrompt}]},
          ..._conversationHistory
        ],
        'tools': _getTools(),
        'generationConfig': {
          'temperature': 0.7,
          'responseMimeType': 'application/json',
        }
      }),
    ).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      return _errorState('API error: ${response.statusCode}');
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
          'role': 'function',
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
        return await _processWithGemini(systemPrompt);
      }
    }

    // No more function calls, parse the JSON response
    final content = parts[0]['text'];
    final aiResponse = jsonDecode(content);
    
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
    final entities = response['entities'] ?? {};

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
