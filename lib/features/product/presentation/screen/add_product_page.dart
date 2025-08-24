import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hiracosmetics/core/enums/category.dart';
// import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
// import 'package:uuid/uuid.dart';

// Provider for the selected category
final selectedCategoryProvider = StateProvider<Category?>((ref) => null);

// // Provider for the product list (simplified)
// final productListProvider = StateNotifierProvider<ProductListNotifier, List<Product>>(
//   (ref) => ProductListNotifier(),
// );

// class ProductListNotifier extends StateNotifier<List<Product>> {
//   ProductListNotifier() : super([]);

//   void addProduct(Product product) {
//     state = [...state, product];
//   }
// }

class AddProductPage extends ConsumerStatefulWidget {
  const AddProductPage({super.key});

  @override
  ConsumerState<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends ConsumerState<AddProductPage> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _priceController = TextEditingController();
    _quantityController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _quantityController.dispose();
    super.dispose();
  }

  void _addProduct() {
    final name = _nameController.text.trim();
    final buyPrice = double.tryParse(_priceController.text.trim());
    final quantity = int.tryParse(_quantityController.text.trim());
    final category = ref.read(selectedCategoryProvider);

    if (name.isEmpty || category == null || buyPrice == null || quantity == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    // final product = Product(
    //   id: const Uuid().v4(),
    //   name: name,
    //   price: buyPrice, // default selling price
    //   buyPrice: buyPrice,
    //   quantity: quantity,
    //   soldQuantity: 0,
    //   isSaled: false,
    //   type: category,
    //   createdAt: DateTime.now(),
    //   saledAt: null,
    // );

    ref.read(productNotifierProvider.notifier).addProduct(name, buyPrice, category, quantity);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Product added successfully!')),
    );

    // Clear inputs
    _nameController.clear();
    _priceController.clear();
    _quantityController.clear();
    ref.read(selectedCategoryProvider.notifier).state = null;
  }

  @override
  Widget build(BuildContext context) {
    final selectedCategory = ref.watch(selectedCategoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Add Product')),
      body: Padding(
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
              children: Category.values.map((cat) {
                final isSelected = cat == selectedCategory;
                return ChoiceChip(
                  label: Text(cat.name),
                  selected: isSelected,
                  onSelected: (_) {
                    ref.read(selectedCategoryProvider.notifier).state = cat;
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
                onPressed: _addProduct,
                child: const Text('Add Product'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
