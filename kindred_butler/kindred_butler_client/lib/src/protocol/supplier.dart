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

abstract class Supplier implements _i1.SerializableModel {
  Supplier._({
    this.id,
    required this.name,
    this.contactPerson,
    this.email,
    this.phone,
    int? leadTimeDays,
  }) : leadTimeDays = leadTimeDays ?? 3;

  factory Supplier({
    int? id,
    required String name,
    String? contactPerson,
    String? email,
    String? phone,
    int? leadTimeDays,
  }) = _SupplierImpl;

  factory Supplier.fromJson(Map<String, dynamic> jsonSerialization) {
    return Supplier(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      contactPerson: jsonSerialization['contactPerson'] as String?,
      email: jsonSerialization['email'] as String?,
      phone: jsonSerialization['phone'] as String?,
      leadTimeDays: jsonSerialization['leadTimeDays'] as int?,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  String? contactPerson;

  String? email;

  String? phone;

  int leadTimeDays;

  /// Returns a shallow copy of this [Supplier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Supplier copyWith({
    int? id,
    String? name,
    String? contactPerson,
    String? email,
    String? phone,
    int? leadTimeDays,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Supplier',
      if (id != null) 'id': id,
      'name': name,
      if (contactPerson != null) 'contactPerson': contactPerson,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      'leadTimeDays': leadTimeDays,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SupplierImpl extends Supplier {
  _SupplierImpl({
    int? id,
    required String name,
    String? contactPerson,
    String? email,
    String? phone,
    int? leadTimeDays,
  }) : super._(
         id: id,
         name: name,
         contactPerson: contactPerson,
         email: email,
         phone: phone,
         leadTimeDays: leadTimeDays,
       );

  /// Returns a shallow copy of this [Supplier]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Supplier copyWith({
    Object? id = _Undefined,
    String? name,
    Object? contactPerson = _Undefined,
    Object? email = _Undefined,
    Object? phone = _Undefined,
    int? leadTimeDays,
  }) {
    return Supplier(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      contactPerson: contactPerson is String?
          ? contactPerson
          : this.contactPerson,
      email: email is String? ? email : this.email,
      phone: phone is String? ? phone : this.phone,
      leadTimeDays: leadTimeDays ?? this.leadTimeDays,
    );
  }
}
