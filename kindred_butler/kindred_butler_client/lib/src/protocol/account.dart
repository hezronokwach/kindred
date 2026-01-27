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

abstract class Account implements _i1.SerializableModel {
  Account._({
    this.id,
    double? balance,
    DateTime? updatedAt,
  }) : balance = balance ?? 10000.0,
       updatedAt = updatedAt ?? DateTime.now();

  factory Account({
    int? id,
    double? balance,
    DateTime? updatedAt,
  }) = _AccountImpl;

  factory Account.fromJson(Map<String, dynamic> jsonSerialization) {
    return Account(
      id: jsonSerialization['id'] as int?,
      balance: (jsonSerialization['balance'] as num?)?.toDouble(),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  double balance;

  DateTime updatedAt;

  /// Returns a shallow copy of this [Account]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Account copyWith({
    int? id,
    double? balance,
    DateTime? updatedAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Account',
      if (id != null) 'id': id,
      'balance': balance,
      'updatedAt': updatedAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AccountImpl extends Account {
  _AccountImpl({
    int? id,
    double? balance,
    DateTime? updatedAt,
  }) : super._(
         id: id,
         balance: balance,
         updatedAt: updatedAt,
       );

  /// Returns a shallow copy of this [Account]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Account copyWith({
    Object? id = _Undefined,
    double? balance,
    DateTime? updatedAt,
  }) {
    return Account(
      id: id is int? ? id : this.id,
      balance: balance ?? this.balance,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
