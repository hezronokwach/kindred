import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class ProductEndpoint extends Endpoint {
  Future<List<Product>> getAllProducts(Session session) async {
    return await Product.db.find(
      session,
      orderBy: (t) => t.name,
    );
  }

  Future<Product?> getProductById(Session session, int id) async {
    return await Product.db.findById(session, id);
  }

  Future<List<Product>> getProductsByName(Session session, String name) async {
    return await Product.db.find(
      session,
      where: (t) => t.name.like('%$name%'),
      orderBy: (t) => t.name,
    );
  }

  Future<Product> createProduct(Session session, Product product) async {
    return await Product.db.insertRow(session, product);
  }

  Future<Product> updateProduct(Session session, Product product) async {
    return await Product.db.updateRow(session, product);
  }

  Future<void> deleteProduct(Session session, int id) async {
    await Product.db.deleteWhere(
      session,
      where: (t) => t.id.equals(id),
    );
  }

  Future<Product?> updateStock(
    Session session,
    int productId,
    int newStockCount,
  ) async {
    return await Product.db.updateById(
      session,
      productId,
      columnValues: (t) => [
        t.stockCount(newStockCount),
      ],
    );
  }
}