import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/core/enums/category.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';

/// Provider for the selected category
final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

class EditProductPage extends ConsumerStatefulWidget {
  const EditProductPage(this.productId, {super.key});
  final String productId;

  @override
  ConsumerState<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends ConsumerState<EditProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  Product? _originalProduct;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
    _loadProduct();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  /// Fetch product and populate form
  Future<void> _loadProduct() async {
    final product = await ref
        .read(productNotifierProvider.notifier)
        .getProductById(widget.productId);

    if (product != null) {
      setState(() {
        _originalProduct = product;
        _nameController.text = product.name;
        _priceController.text = product.buyPrice.toString();
        _quantityController.text = product.quantity.toString();
        ref.read(selectedCategoryProvider.notifier).state = product.type;
        _isLoading = false;
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Product not found')));
      Navigator.of(context).pop();
    }
  }

  /// Update product while keeping original soldQuantity, createdAt, saledAt
  Future<void> _updateProduct() async {
    final name = _nameController.text.trim();
    final buyPrice = double.tryParse(_priceController.text.trim());
    final quantity = int.tryParse(_quantityController.text.trim());
    final category = ref.read(selectedCategoryProvider);

    if (name.isEmpty ||
        category == null ||
        buyPrice == null ||
        quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    if (_originalProduct == null) return;

    final updatedProduct = _originalProduct!.copyWith(
      name: name,
      buyPrice: buyPrice,
      price: buyPrice, // adjust if selling price differs
      quantity: quantity,
      type: category,
      // ✅ keep these unchanged
      soldQuantity: _originalProduct!.soldQuantity,
      createdAt: _originalProduct!.createdAt,
      saledAt: _originalProduct!.saledAt,
    );

     ref
        .read(productNotifierProvider.notifier)
        .updateProduct(updatedProduct);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product updated successfully!')),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Product Name *',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Cost Price *',
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text('Category *'),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      children:
                          Category.values.map((cat) {
                            final isSelected = cat == selectedCategory;
                            return ChoiceChip(
                              label: Text(cat.name),
                              selected: isSelected,
                              onSelected: (_) {
                                ref
                                    .read(selectedCategoryProvider.notifier)
                                    .state = cat;
                              },
                            );
                          }).toList(),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _quantityController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Initial Quantity *',
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _updateProduct,
                        child: const Text('Update Product'),
                      ),
                    ),
                  ],
                ),
              ),
    );
  }
}
