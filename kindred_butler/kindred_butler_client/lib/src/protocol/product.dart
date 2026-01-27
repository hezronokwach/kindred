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

abstract class Product implements _i1.SerializableModel {
  Product._({
    this.id,
    required this.name,
    required this.stockCount,
    required this.price,
    this.imageUrl,
    this.category,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  factory Product({
    int? id,
    required String name,
    required int stockCount,
    required double price,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      stockCount: jsonSerialization['stockCount'] as int,
      price: (jsonSerialization['price'] as num).toDouble(),
      imageUrl: jsonSerialization['imageUrl'] as String?,
      category: jsonSerialization['category'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _i1.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  int stockCount;

  double price;

  String? imageUrl;

  String? category;

  DateTime createdAt;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    int? id,
    String? name,
    int? stockCount,
    double? price,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'name': name,
      'stockCount': stockCount,
      'price': price,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (category != null) 'category': category,
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProductImpl extends Product {
  _ProductImpl({
    int? id,
    required String name,
    required int stockCount,
    required double price,
    String? imageUrl,
    String? category,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         stockCount: stockCount,
         price: price,
         imageUrl: imageUrl,
         category: category,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Product copyWith({
    Object? id = _Undefined,
    String? name,
    int? stockCount,
    double? price,
    Object? imageUrl = _Undefined,
    Object? category = _Undefined,
    DateTime? createdAt,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      stockCount: stockCount ?? this.stockCount,
      price: price ?? this.price,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      category: category is String? ? category : this.category,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
