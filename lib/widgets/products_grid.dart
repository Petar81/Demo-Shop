import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/product_item.dart';
import '../models/providers/products.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        childAspectRatio: 2 / 2,
        mainAxisSpacing: 30,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider(
        create: (ctx) => products[i],
        child: const ProductItem(
            // products[i].id,
            // products[i].imageURL,
            // products[i].title,
            ),
      ),
      itemCount: products.length,
    );
  }
}
