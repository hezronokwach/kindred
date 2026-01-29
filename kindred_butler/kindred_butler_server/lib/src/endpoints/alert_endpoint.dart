import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class AlertEndpoint extends Endpoint {
  Future<Alert> addAlert(Session session, Alert alert) async {
    return await Alert.db.insertRow(session, alert);
  }

  Future<List<Alert>> getAlerts(Session session) async {
    return await Alert.db.find(session, where: (t) => t.isActive.equals(true));
  }
  
  Future<void> deleteAlert(Session session, int id) async {
    final alert = await Alert.db.findById(session, id);
    if (alert != null) {
      await Alert.db.deleteRow(session, alert);
    }
  }
}
