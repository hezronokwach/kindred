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

abstract class Alert implements _i1.SerializableModel {
  Alert._({
    this.id,
    required this.type,
    required this.threshold,
    required this.comparison,
    this.productFilter,
    required this.isActive,
    this.message,
    required this.createdAt,
  });

  factory Alert({
    int? id,
    required String type,
    required double threshold,
    required String comparison,
    String? productFilter,
    required bool isActive,
    String? message,
    required DateTime createdAt,
  }) = _AlertImpl;

  factory Alert.fromJson(Map<String, dynamic> jsonSerialization) {
    return Alert(
      id: jsonSerialization['id'] as int?,
      type: jsonSerialization['type'] as String,
      threshold: (jsonSerialization['threshold'] as num).toDouble(),
      comparison: jsonSerialization['comparison'] as String,
      productFilter: jsonSerialization['productFilter'] as String?,
      isActive: jsonSerialization['isActive'] as bool,
      message: jsonSerialization['message'] as String?,
      createdAt: _i1.DateTimeJsonExtension.fromJson(
        jsonSerialization['createdAt'],
      ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String type;

  double threshold;

  String comparison;

  String? productFilter;

  bool isActive;

  String? message;

  DateTime createdAt;

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Alert copyWith({
    int? id,
    String? type,
    double? threshold,
    String? comparison,
    String? productFilter,
    bool? isActive,
    String? message,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Alert',
      if (id != null) 'id': id,
      'type': type,
      'threshold': threshold,
      'comparison': comparison,
      if (productFilter != null) 'productFilter': productFilter,
      'isActive': isActive,
      if (message != null) 'message': message,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _AlertImpl extends Alert {
  _AlertImpl({
    int? id,
    required String type,
    required double threshold,
    required String comparison,
    String? productFilter,
    required bool isActive,
    String? message,
    required DateTime createdAt,
  }) : super._(
         id: id,
         type: type,
         threshold: threshold,
         comparison: comparison,
         productFilter: productFilter,
         isActive: isActive,
         message: message,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Alert]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Alert copyWith({
    Object? id = _Undefined,
    String? type,
    double? threshold,
    String? comparison,
    Object? productFilter = _Undefined,
    bool? isActive,
    Object? message = _Undefined,
    DateTime? createdAt,
  }) {
    return Alert(
      id: id is int? ? id : this.id,
      type: type ?? this.type,
      threshold: threshold ?? this.threshold,
      comparison: comparison ?? this.comparison,
      productFilter: productFilter is String?
          ? productFilter
          : this.productFilter,
      isActive: isActive ?? this.isActive,
      message: message is String? ? message : this.message,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
