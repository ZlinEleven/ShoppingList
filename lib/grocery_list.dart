import 'package:flutter/material.dart';
import 'package:shopping_list/data/dummy_items.dart';
import 'package:shopping_list/widget/grocery_item_widget.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  @override
  Widget build(context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...groceryItems
              .map(
                (item) => GroceryItemWidget(item: item),
              )
              .toList(),
        ],
      ),
    );
  }
}
