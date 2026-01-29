import 'dart:ui' as ui;
import 'package:flutter/material.dart'; // Added for Material widgets like StatefulWidget, State, etc.
import 'package:flutter/services.dart'; // Added for HapticFeedback
import 'package:provider/provider.dart'; // Added for Consumer and context.read
import 'dart:math' as math; // Added for math.sin

import '../main.dart';
import '../widgets/morphic_container.dart';
import '../widgets/glassmorphic_card.dart';
import '../models/morphic_state.dart' as morphic; // Added as per instruction
import '../utils/app_colors.dart'; // Added as it was missing from the original list but used
import '../utils/app_typography.dart'; // Added as it was missing from the original list but used
import '../utils/app_animations.dart';
import 'test_screen.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  bool _isListening = false;
  late AnimationController _pulseController;
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
    
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appState = context.read<AppState>();
      appState.initialize();
      appState.initializeSpeech();
      appState.preloadImages(context);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    super.dispose();
  }

  Future<void> _handleMicPress() async {
    HapticFeedback.mediumImpact();
    final appState = context.read<AppState>();
    setState(() => _isListening = true);
    
    try {
      final transcription = await appState.speechService.listen(
        onResult: (partialResult) {
          appState.updateTranscription(partialResult);
        },
      );
      if (transcription.isNotEmpty) {
        await appState.processVoiceInput(transcription);
      }
    } catch (e) {
      HapticFeedback.heavyImpact();
    } finally {
      if (mounted) setState(() => _isListening = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.slateDark,
      body: Stack(
        children: [
          _buildAnimatedBackground(),
          Consumer<AppState>(
            builder: (context, appState, child) {
              return SafeArea(
                child: Column(
                  children: [
                    _buildHeader(appState),
                    if (appState.lastTranscription.isNotEmpty)
                      _buildTranscriptionBadge(appState.lastTranscription),
                    Expanded(
                      child: appState.isProcessing
                          ? _buildProcessingState()
                          : AnimatedSwitcher(
                              duration: AppAnimations.medium,
                              switchInCurve: AppAnimations.standardCurve,
                              child: MorphicContainer(
                                key: ValueKey('${appState.currentState.intent}_${appState.currentState.uiMode}'),
                                state: appState.currentState,
                                onActionConfirm: appState.handleActionConfirm,
                                onActionCancel: appState.handleActionCancel,
                              ),
                            ),
                    ),
                    _buildFooter(appState),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return Positioned.fill(
      child: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(0.7, -0.6),
            radius: 1.2,
            colors: [
              Color(0xFF1E3A32), // Deep Emerald
              AppColors.slateDark,
            ],
          ),
        ),
        child: Opacity(
          opacity: 0.1,
          child: CustomPaint(
            painter: GridPainter(),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(AppState appState) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 12, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'KINDRED',
                style: AppTypography.headline.copyWith(
                  fontSize: 16,
                  letterSpacing: 4,
                  color: AppColors.emeraldPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'VOICE ASSISTANT',
                style: AppTypography.caption.copyWith(
                  fontSize: 8,
                  letterSpacing: 2,
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              _buildHeaderIcon(
                icon: Icons.science_outlined,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const TestScreen()),
                ),
                color: AppColors.emeraldPrimary,
              ),
              _buildHeaderIcon(
                icon: Icons.tune_rounded,
                onPressed: () => _showSettings(context, appState),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderIcon({required IconData icon, required VoidCallback onPressed, Color? color}) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(icon, color: color ?? AppColors.white.withOpacity(0.5), size: 20),
      visualDensity: VisualDensity.compact,
    );
  }

  void _showSettings(BuildContext context, AppState appState) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => BackdropFilter(
        filter: ui.ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: AppColors.slateMedium.withOpacity(0.9),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            border: Border.all(color: AppColors.white.withOpacity(0.1)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Voice Interface', style: AppTypography.title),
              const SizedBox(height: 24),
              _buildSettingItem(
                title: 'Narration',
                subtitle: 'Audible AI responses',
                trailing: Switch(
                  value: appState.isVoiceEnabled,
                  onChanged: (v) => setState(() => appState.isVoiceEnabled = v),
                  activeColor: AppColors.emeraldPrimary,
                ),
              ),
              const SizedBox(height: 16),
              _buildSettingItem(
                title: 'Playback Speed',
                subtitle: 'Current: ${appState.voiceSpeed}x',
                trailing: SizedBox(
                  width: 150,
                  child: Slider(
                    value: appState.voiceSpeed,
                    // Removed 'isCurved: true,' as it's not a valid Slider property
                    min: 0.5,
                    max: 2.0,
                    divisions: 6,
                    onChanged: (v) => setState(() => appState.voiceSpeed = v),
                    activeColor: AppColors.emeraldPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem({required String title, required String subtitle, required Widget trailing}) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTypography.body.copyWith(fontWeight: FontWeight.w600)),
              Text(subtitle, style: AppTypography.caption),
            ],
          ),
        ),
        trailing,
      ],
    );
  }

  Widget _buildTranscriptionBadge(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: GlassmorphicCard(
        borderRadius: 16,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            const Icon(Icons.blur_on, color: AppColors.emeraldPrimary, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: AppTypography.body.copyWith(
                  fontStyle: FontStyle.italic,
                  color: AppColors.white.withOpacity(0.9),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProcessingState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return AnimatedBuilder(
                  animation: _waveController,
                  builder: (context, child) {
                    final delay = index * 0.2;
                    final value = math.sin((_waveController.value * 2 * math.pi) - (delay * 2 * math.pi));
                    return Container(
                      width: 8,
                      height: 8 + (value * 12).abs(),
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        color: AppColors.emeraldPrimary.withOpacity(0.3 + (value.abs() * 0.7)),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    );
                  },
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing Business Intelligence...',
            style: AppTypography.caption.copyWith(letterSpacing: 1),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter(AppState appState) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32, top: 16),
      child: Center(
        child: _buildMicButton(),
      ),
    );
  }

  Widget _buildMicButton() {
    return GestureDetector(
      onTap: _handleMicPress,
      child: SizedBox(
        width: 80,
        height: 80,
        child: Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            if (_isListening)
              ...List.generate(2, (index) {
                return AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final progress = (_pulseController.value + index * 0.5) % 1.0;
                    return Container(
                      width: 80 + (progress * 80),
                      height: 80 + (progress * 80),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.emeraldPrimary.withOpacity((1 - progress) * 0.5),
                          width: 2,
                        ),
                      ),
                    );
                  },
                );
              }),
            AnimatedContainer(
              duration: AppAnimations.fast,
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                gradient: _isListening ? AppColors.primaryGradient : null,
                color: _isListening ? null : AppColors.slateMedium,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: (_isListening ? AppColors.emeraldPrimary : Colors.black).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(
                  color: AppColors.white.withOpacity(0.1),
                  width: 1,
                ),
              ),
              child: Icon(
                _isListening ? Icons.mic_rounded : Icons.mic_none_rounded,
                size: 36,
                color: _isListening ? AppColors.white : AppColors.emeraldPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.white.withOpacity(0.1)
      ..strokeWidth = 0.5;

    const spacing = 40.0;
    for (double i = 0; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += spacing) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
