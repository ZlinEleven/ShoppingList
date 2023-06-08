import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget({super.key, required this.item});

  final GroceryItem item;

  @override
  Widget build(context) {
    return SizedBox(
      height: 60,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Row(
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: DecoratedBox(
                decoration: BoxDecoration(color: item.category.color),
              ),
            ),
            const SizedBox(width: 25),
            Text(item.name),
            const Spacer(),
            Text(item.quantity.toString()),
          ],
        ),
      ),
    );
  }
}
