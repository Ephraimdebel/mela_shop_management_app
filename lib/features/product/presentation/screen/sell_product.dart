import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hiracosmetics/features/product/data/models/product.dart';
import 'package:hiracosmetics/features/product/presentation/provider/product_provider.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class SellProductDialog extends HookConsumerWidget {
  final Product product;
  const SellProductDialog({super.key, required this.product});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final quantitySold = useTextEditingController();
    final sellingPrice = useTextEditingController();

    String? validateprice(String? value) {
      if (value == null || value.isEmpty) {
        return 'Price is required';
      }
      if (double.tryParse(value) == null) {
        return 'Please enter a valid price';
      }
      if (double.tryParse(sellingPrice.text) != null &&
          double.tryParse(sellingPrice.text)! < product.buyPrice) {
        return 'Selling price cannot be less than buying price';
      }
      return null;
    }

    String? validateQuantity(String? value) {
      if (value == null || value.isEmpty) {
        return 'Quantity is required';
      }
      if (int.tryParse(value) == null) {
        return 'Please enter a valid quantity';
      }
      if (int.tryParse(value)! + product.soldQuantity > product.quantity) {
        return 'Quantity sold cannot be more than available stock';
      }
      // quantity should be positive
      if (int.tryParse(value)! <= 0) {
        return 'Quantity sold must be positive';
      }
      return null;
    }

    void submit() {
      if (formKey.currentState?.validate() ?? false) {
        ref
            .read(productNotifierProvider.notifier)
            .sellProduct(
              productId: product.id,
              quantitySold: int.parse(quantitySold.text),
              sellingPrice: double.parse(sellingPrice.text),
            );

        Navigator.of(context).pop();
      }
    }

    return AlertDialog(
      title: const Text('Sell Product'),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: sellingPrice,
              decoration: const InputDecoration(labelText: 'Selling Price'),
              validator: validateprice,
            ),
            TextFormField(
              controller: quantitySold,
              decoration: const InputDecoration(labelText: 'Quantity Sold'),
              keyboardType: TextInputType.number,
              validator: validateQuantity,
            ),

            const SizedBox(height: 16),
            // DropdownButtonFormField<WorkoutType>(
            //   value: selectedType.value,
            //   onChanged: (value) {
            //     if (value != null) {
            //       selectedType.value = value;
            //     }
            //   },
            //   items: const [
            //     DropdownMenuItem(
            //       value: WorkoutType.upperBody,
            //       child: Text('Upper Body'),
            //     ),
            //     DropdownMenuItem(
            //       value: WorkoutType.lowerBody,
            //       child: Text('Lower Body'),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        TextButton(onPressed: submit, child: const Text('Add')),
      ],
    );
  }
}
