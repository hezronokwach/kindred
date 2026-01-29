import 'package:flutter/material.dart';
import 'package:kindred_butler_client/kindred_butler_client.dart' as client;
import '../utils/app_colors.dart';
import '../utils/app_typography.dart';
import 'glassmorphic_card.dart';
import 'loading_skeleton.dart';
import 'status_badge.dart';

class ProductImageCard extends StatelessWidget {
  final client.Product product;
  final VoidCallback? onConfirm;

  const ProductImageCard({
    super.key,
    required this.product,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassmorphicCard(
        margin: const EdgeInsets.all(24),
        padding: EdgeInsets.zero,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'product_${product.id}',
                  child: ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                    child: Image.network(
                      product.imageUrl ?? 'https://images.unsplash.com/photo-1542291026-7eec264c27ff',
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const LoadingSkeleton(height: 250, borderRadius: 0);
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 250,
                          color: AppColors.slateLight.withOpacity(0.1),
                          child: const Icon(Icons.broken_image_outlined, size: 64, color: AppColors.gray600),
                        );
                      },
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  right: 16,
                  child: StatusBadge.stock(product.stockCount),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            product.name,
                            style: AppTypography.title.copyWith(fontSize: 22),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          '\$${product.sellingPrice.toStringAsFixed(2)}',
                          style: AppTypography.data.copyWith(
                            fontSize: 20, 
                            color: AppColors.emeraldLight,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    children: [
                      const Icon(Icons.category_outlined, size: 16, color: AppColors.gray600),
                      const SizedBox(width: 8),
                      Text(
                        product.category?.toUpperCase() ?? 'NONE',
                        style: AppTypography.caption,
                      ),
                      const Spacer(),
                      Text(
                        'ID: #${product.id ?? '---'}',
                        style: AppTypography.caption.copyWith(fontFamily: 'JetBrains Mono'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Inventory overview for this item based on recent business analytical data.',
                    style: AppTypography.body.copyWith(fontSize: 14),
                  ),
                  if (onConfirm != null) ...[
                    const SizedBox(height: 32),
                    GestureDetector(
                      onTap: onConfirm,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        decoration: BoxDecoration(
                          gradient: AppColors.primaryGradient,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'CONFIRM SELECTION',
                          style: AppTypography.button,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
