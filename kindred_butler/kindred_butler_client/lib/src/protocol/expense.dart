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
    String? type,
    String? paymentMethod,
    double? taxAmount,
    this.productName,
    this.description,
    DateTime? date,
  }) : type = type ?? 'expense',
       paymentMethod = paymentMethod ?? 'Cash',
       taxAmount = taxAmount ?? 0.0,
       date = date ?? DateTime.now();

  factory Expense({
    int? id,
    required String category,
    required double amount,
    String? type,
    String? paymentMethod,
    double? taxAmount,
    String? productName,
    String? description,
    DateTime? date,
  }) = _ExpenseImpl;

  factory Expense.fromJson(Map<String, dynamic> jsonSerialization) {
    return Expense(
      id: jsonSerialization['id'] as int?,
      category: jsonSerialization['category'] as String,
      amount: (jsonSerialization['amount'] as num).toDouble(),
      type: jsonSerialization['type'] as String?,
      paymentMethod: jsonSerialization['paymentMethod'] as String?,
      taxAmount: (jsonSerialization['taxAmount'] as num?)?.toDouble(),
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

  String type;

  String? paymentMethod;

  double taxAmount;

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
    String? type,
    String? paymentMethod,
    double? taxAmount,
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
      'type': type,
      if (paymentMethod != null) 'paymentMethod': paymentMethod,
      'taxAmount': taxAmount,
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
    String? type,
    String? paymentMethod,
    double? taxAmount,
    String? productName,
    String? description,
    DateTime? date,
  }) : super._(
         id: id,
         category: category,
         amount: amount,
         type: type,
         paymentMethod: paymentMethod,
         taxAmount: taxAmount,
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
    String? type,
    Object? paymentMethod = _Undefined,
    double? taxAmount,
    Object? productName = _Undefined,
    Object? description = _Undefined,
    DateTime? date,
  }) {
    return Expense(
      id: id is int? ? id : this.id,
      category: category ?? this.category,
      amount: amount ?? this.amount,
      type: type ?? this.type,
      paymentMethod: paymentMethod is String?
          ? paymentMethod
          : this.paymentMethod,
      taxAmount: taxAmount ?? this.taxAmount,
      productName: productName is String? ? productName : this.productName,
      description: description is String? ? description : this.description,
      date: date ?? this.date,
    );
  }
}
