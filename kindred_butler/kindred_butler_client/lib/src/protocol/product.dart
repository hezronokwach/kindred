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
    required this.sellingPrice,
    required this.costPrice,
    required this.brand,
    this.sku,
    String? unit,
    int? minStockThreshold,
    this.imageUrl,
    this.category,
    this.supplierId,
    DateTime? createdAt,
  }) : unit = unit ?? 'pair',
       minStockThreshold = minStockThreshold ?? 5,
       createdAt = createdAt ?? DateTime.now();

  factory Product({
    int? id,
    required String name,
    required int stockCount,
    required double sellingPrice,
    required double costPrice,
    required String brand,
    String? sku,
    String? unit,
    int? minStockThreshold,
    String? imageUrl,
    String? category,
    int? supplierId,
    DateTime? createdAt,
  }) = _ProductImpl;

  factory Product.fromJson(Map<String, dynamic> jsonSerialization) {
    return Product(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      stockCount: jsonSerialization['stockCount'] as int,
      sellingPrice: (jsonSerialization['sellingPrice'] as num).toDouble(),
      costPrice: (jsonSerialization['costPrice'] as num).toDouble(),
      brand: jsonSerialization['brand'] as String,
      sku: jsonSerialization['sku'] as String?,
      unit: jsonSerialization['unit'] as String?,
      minStockThreshold: jsonSerialization['minStockThreshold'] as int?,
      imageUrl: jsonSerialization['imageUrl'] as String?,
      category: jsonSerialization['category'] as String?,
      supplierId: jsonSerialization['supplierId'] as int?,
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

  double sellingPrice;

  double costPrice;

  String brand;

  String? sku;

  String unit;

  int minStockThreshold;

  String? imageUrl;

  String? category;

  int? supplierId;

  DateTime createdAt;

  /// Returns a shallow copy of this [Product]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Product copyWith({
    int? id,
    String? name,
    int? stockCount,
    double? sellingPrice,
    double? costPrice,
    String? brand,
    String? sku,
    String? unit,
    int? minStockThreshold,
    String? imageUrl,
    String? category,
    int? supplierId,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Product',
      if (id != null) 'id': id,
      'name': name,
      'stockCount': stockCount,
      'sellingPrice': sellingPrice,
      'costPrice': costPrice,
      'brand': brand,
      if (sku != null) 'sku': sku,
      'unit': unit,
      'minStockThreshold': minStockThreshold,
      if (imageUrl != null) 'imageUrl': imageUrl,
      if (category != null) 'category': category,
      if (supplierId != null) 'supplierId': supplierId,
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
    required double sellingPrice,
    required double costPrice,
    required String brand,
    String? sku,
    String? unit,
    int? minStockThreshold,
    String? imageUrl,
    String? category,
    int? supplierId,
    DateTime? createdAt,
  }) : super._(
         id: id,
         name: name,
         stockCount: stockCount,
         sellingPrice: sellingPrice,
         costPrice: costPrice,
         brand: brand,
         sku: sku,
         unit: unit,
         minStockThreshold: minStockThreshold,
         imageUrl: imageUrl,
         category: category,
         supplierId: supplierId,
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
    double? sellingPrice,
    double? costPrice,
    String? brand,
    Object? sku = _Undefined,
    String? unit,
    int? minStockThreshold,
    Object? imageUrl = _Undefined,
    Object? category = _Undefined,
    Object? supplierId = _Undefined,
    DateTime? createdAt,
  }) {
    return Product(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      stockCount: stockCount ?? this.stockCount,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      costPrice: costPrice ?? this.costPrice,
      brand: brand ?? this.brand,
      sku: sku is String? ? sku : this.sku,
      unit: unit ?? this.unit,
      minStockThreshold: minStockThreshold ?? this.minStockThreshold,
      imageUrl: imageUrl is String? ? imageUrl : this.imageUrl,
      category: category is String? ? category : this.category,
      supplierId: supplierId is int? ? supplierId : this.supplierId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
