import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'models/morphic_state.dart' as morphic;
import 'models/business_data.dart';
import 'services/gemini_service.dart';
import 'services/speech_service.dart';
import 'services/elevenlabs_service.dart';
import 'services/serverpod_service.dart';
import 'services/action_service.dart';
import 'screens/home_screen.dart';
import 'utils/app_theme.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  
  // Initialize Serverpod
  final serverUrl = dotenv.env['SERVERPOD_URL'] ?? 'http://localhost:8080';
  await ServerpodService.initialize(serverUrl);
  
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const MyApp(),
    ),
  );
}

class AppState extends ChangeNotifier {
  morphic.MorphicState _currentState = morphic.MorphicState.initial();
  final List<String> _conversationHistory = [];
  bool _isProcessing = false;
  String _lastTranscription = '';
  
  // Voice settings
  bool _isVoiceEnabled = true;
  double _voiceSpeed = 1.0;

  late GeminiService _geminiService;
  late SpeechService _speechService;
  late ElevenLabsService _elevenLabsService;
  late ActionService _actionService;

  morphic.MorphicState get currentState => _currentState;
  bool get isProcessing => _isProcessing;
  String get lastTranscription => _lastTranscription;
  bool get isVoiceEnabled => _isVoiceEnabled;
  double get voiceSpeed => _voiceSpeed;

  set isVoiceEnabled(bool value) {
    _isVoiceEnabled = value;
    notifyListeners();
  }

  set voiceSpeed(double value) {
    _voiceSpeed = value;
    notifyListeners();
  }

  void initialize() {
    final geminiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
    final elevenLabsKey = dotenv.env['ELEVENLABS_API_KEY'] ?? '';
    
    _geminiService = GeminiService(apiKey: geminiKey);
    _speechService = SpeechService();
    _elevenLabsService = ElevenLabsService(apiKey: elevenLabsKey);
    _actionService = ActionService();
  }

  Future<void> preloadImages(BuildContext context) async {
    final products = await BusinessData.getProducts();
    if (!context.mounted) return;
    
    for (var product in products) {
      try {
        await precacheImage(NetworkImage(product.imageUrl ?? 'https://images.unsplash.com/photo-1542291026-7eec264c27ff'), context);
      } catch (e) {
        // Silently handle image preload failures
      }
    }
  }

  Future<void> processVoiceInput(String transcription) async {
    _lastTranscription = '';
    _isProcessing = true;
    notifyListeners();

    try {
      _conversationHistory.add(transcription);
      _currentState = await _geminiService.analyzeQuery(transcription);
      notifyListeners();
      
      if (_isVoiceEnabled) {
        _elevenLabsService.speak(_currentState.narrative);
      }
    } catch (e) {
      _currentState = morphic.MorphicState(
        intent: morphic.Intent.unknown,
        uiMode: morphic.UIMode.narrative,
        narrative: 'Sorry, something went wrong. Please try again.',
        confidence: 0.0,
      );
      notifyListeners();
    } finally {
      _isProcessing = false;
      notifyListeners();
    }
  }

  Future<void> initializeSpeech() async {
    await _speechService.initialize();
  }

  void handleActionConfirm(String actionType, Map<String, dynamic> actionData) async {
    _isProcessing = true;
    notifyListeners();
    
    try {
      _currentState = await _actionService.handleActionConfirm(actionType, actionData);
    } catch (e) {
      _currentState = morphic.MorphicState(
        intent: morphic.Intent.unknown,
        uiMode: morphic.UIMode.narrative,
        narrative: 'Error executing action: $e',
        headerText: 'Error',
        confidence: 0.0,
      );
    } finally {
      _isProcessing = false;
      notifyListeners();
      if (_isVoiceEnabled) {
        _elevenLabsService.speak(_currentState.narrative);
      }
    }
  }

  void handleActionCancel() {
    _currentState = morphic.MorphicState(
      intent: morphic.Intent.unknown,
      uiMode: morphic.UIMode.narrative,
      narrative: 'Action cancelled.',
      headerText: 'Cancelled',
      confidence: 1.0,
    );
    notifyListeners();
  }

  void updateTranscription(String transcription) {
    _lastTranscription = transcription;
    notifyListeners();
  }

  SpeechService get speechService => _speechService;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kindred Voice Agent',
      theme: AppTheme.theme,
      home: const MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
