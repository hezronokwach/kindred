import 'package:flutter/material.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;

class InventoryTable extends StatelessWidget {
  final List<client.Product> products;

  const InventoryTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: const [
            DataColumn(label: Text('Product Name', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Stock', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Price', style: TextStyle(fontWeight: FontWeight.bold))),
            DataColumn(label: Text('Category', style: TextStyle(fontWeight: FontWeight.bold))),
          ],
          rows: products.map((product) {
            return DataRow(
              cells: [
                DataCell(Text(product.name)),
                DataCell(Text('${product.stockCount}')),
                DataCell(Text('\$${product.sellingPrice.toStringAsFixed(2)}')),
                DataCell(Text(product.category ?? 'Unknown')),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
