import '../models/morphic_state.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;

abstract class IntentHandler {
  Future<MorphicState> handle({
    required Map<String, dynamic> response,
    required List<client.Product> products,
    required List<client.Expense> expenses,
    required Intent intent,
    required UIMode uiMode,
    required String narrative,
    String? headerText,
    required double confidence,
    required Map<String, dynamic> entities,
  });
}
