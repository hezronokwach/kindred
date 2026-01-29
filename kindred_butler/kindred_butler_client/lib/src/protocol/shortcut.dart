/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:kindred_butler_client/src/protocol/protocol.dart' as _i2;

abstract class Shortcut implements _i1.SerializableModel {
  Shortcut._({
    this.id,
    required this.triggerPhrase,
    required this.actions,
    this.description,
    required this.createdAt,
  });

  factory Shortcut({
    int? id,
    required String triggerPhrase,
    required List<String> actions,
    String? description,
    required DateTime createdAt,
  }) = _ShortcutImpl;

  factory Shortcut.fromJson(Map<String, dynamic> jsonSerialization) {
    return Shortcut(
      id: jsonSerialization['id'] as int?,
      triggerPhrase: jsonSerialization['triggerPhrase'] as String,
      actions: _i2.Protocol().deserialize<List<String>>(
        jsonSerialization['actions'],
      ),
      description: jsonSerialization['description'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String triggerPhrase;

  List<String> actions;

  String? description;

  DateTime createdAt;

  /// Returns a shallow copy of this [Shortcut]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Shortcut copyWith({
    int? id,
    String? triggerPhrase,
    List<String>? actions,
    String? description,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Shortcut',
      if (id != null) 'id': id,
      'triggerPhrase': triggerPhrase,
      'actions': actions.toJson(),
      if (description != null) 'description': description,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ShortcutImpl extends Shortcut {
  _ShortcutImpl({
    int? id,
    required String triggerPhrase,
    required List<String> actions,
    String? description,
    required DateTime createdAt,
  }) : super._(
         id: id,
         triggerPhrase: triggerPhrase,
         actions: actions,
         description: description,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Shortcut]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Shortcut copyWith({
    Object? id = _Undefined,
    String? triggerPhrase,
    List<String>? actions,
    Object? description = _Undefined,
    DateTime? createdAt,
  }) {
    return Shortcut(
      id: id is int? ? id : this.id,
      triggerPhrase: triggerPhrase ?? this.triggerPhrase,
      actions: actions ?? this.actions.map((e0) => e0).toList(),
      description: description is String? ? description : this.description,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
