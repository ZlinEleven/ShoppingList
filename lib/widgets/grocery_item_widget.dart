import 'package:flutter/material.dart';
import '../models/grocery_item.dart';

class GroceryItemWidget extends StatelessWidget {
  const GroceryItemWidget(
      {super.key, required this.item, required this.onDismissedFunction});

  final GroceryItem item;
  final void Function(GroceryItem) onDismissedFunction;

  @override
  Widget build(context) {
    return Dismissible(
      key: ValueKey(item.id),
      onDismissed: (direction) => onDismissedFunction(item),
      child: ListTile(
        title: Text(item.name),
        leading: Container(
          height: 24,
          width: 24,
          color: item.category.color,
        ),
        trailing: Text(item.quantity.toString()),
      ),
    );
  }
}
