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

abstract class Expense implements _i1.SerializableModel {
  Expense._({
    this.id,
    required this.category,
    required this.amount,
    this.productName,
    this.description,
    DateTime? date,
  }) : date = date ?? DateTime.now();

  factory Expense({
    int? id,
    required String category,
    required double amount,
    String? productName,
    String? description,
    DateTime? date,
  }) = _ExpenseImpl;

  factory Expense.fromJson(Map<String, dynamic> jsonSerialization) {
    return Expense(
      id: jsonSerialization['id'] as int?,
      category: jsonSerialization['category'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      productName: jsonSerialization['productName'] as String?,
      description: jsonSerialization['description'] as String?,
      date: jsonSerialization['date'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['date']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String category;

  double amount;

  String? productName;

  String? description;

  DateTime date;

  /// Returns a shallow copy of this [Expense]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Expense copyWith({
    int? id,
    String? category,
    double? amount,
    String? productName,
    String? description,
    DateTime? date,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Expense',
      if (id != null) 'id': id,
      'category': category,
      'amount': amount,
      if (productName != null) 'productName': productName,
      if (description != null) 'description': description,
      'date': date.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ExpenseImpl extends Expense {
  _ExpenseImpl({
    int? id,
    required String category,
    required double amount,
    String? productName,
    String? description,
    DateTime? date,
  }) : super._(
         id: id,
         category: category,
         amount: amount,
         productName: productName,
         description: description,
         date: date,
       );

  /// Returns a shallow copy of this [Expense]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Expense copyWith({
    Object? id = _Undefined,
    String? category,
    double? amount,
    Object? productName = _Undefined,
    Object? description = _Undefined,
    DateTime? date,
  }) {
    return Expense(
      id: id is int? ? id : this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      productName: productName is String? ? productName : this.productName,
      description: description is String? ? description : this.description,
      date: date ?? this.date,
    );
  }
}
