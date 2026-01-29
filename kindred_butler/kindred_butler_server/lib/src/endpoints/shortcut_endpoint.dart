import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ShortcutEndpoint extends Endpoint {
  Future<Shortcut> addShortcut(Session session, Shortcut shortcut) async {
    return await Shortcut.db.insertRow(session, shortcut);
  }

  Future<List<Shortcut>> getShortcuts(Session session) async {
    return await Shortcut.db.find(session);
  }
}
