import 'package:flutter/material.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import '../utils/app_theme.dart';
import 'status_badge.dart';

class InventoryTable extends StatelessWidget {
  final List<client.Product> products;

  const InventoryTable({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: AppColors.white.withOpacity(0.05),
        dataTableTheme: DataTableThemeData(
          headingTextStyle: AppTypography.caption.copyWith(
            color: AppColors.gray400,
            fontWeight: FontWeight.w800,
          ),
          dataTextStyle: AppTypography.body.copyWith(
            color: AppColors.white,
            fontSize: 14,
          ),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: DataTable(
          columnSpacing: 24,
          horizontalMargin: 20,
          showCheckboxColumn: false,
          columns: const [
            DataColumn(label: Text('PRODUCT')),
            DataColumn(label: Text('STOCK')),
            DataColumn(label: Text('PRICE')),
            DataColumn(label: Text('CATEGORY')),
          ],
          rows: products.asMap().entries.map((entry) {
            final product = entry.value;
            final isEven = entry.key % 2 == 0;
            return DataRow(
              color: MaterialStateProperty.resolveWith<Color?>(
                (states) => isEven ? Colors.transparent : AppColors.white.withOpacity(0.02),
              ),
              cells: [
                DataCell(
                  Text(
                    product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                DataCell(StatusBadge.stock(product.stockCount)),
                DataCell(
                  Text(
                    '\$${product.sellingPrice.toStringAsFixed(2)}',
                    style: AppTypography.data.copyWith(
                      color: AppColors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
                DataCell(
                  Text(
                    product.category?.toUpperCase() ?? 'NONE',
                    style: AppTypography.caption.copyWith(fontSize: 10),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}
