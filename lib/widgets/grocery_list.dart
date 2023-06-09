import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/grocery_item_widget.dart';
import 'package:shopping_list/widgets/new_item.dart';

import '../models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  final List<GroceryItem> _groceryItems = [];

  void addItem() async {
    final newItem = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const NewItem(),
      ),
    );
    if (newItem != null) {
      setState(() {
        _groceryItems.add(newItem);
      });
    }
  }

  void _dismissGrocery(GroceryItem grocery) {
    setState(() {
      _groceryItems.remove(grocery);
    });
  }

  @override
  Widget build(context) {
    Widget groceryListContent = Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "You have no items.",
            style: Theme.of(context)
                .textTheme
                .titleLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          Text(
            "Try adding some.",
            style: Theme.of(context)
                .textTheme
                .bodyLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
        ],
      ),
    );

    if (_groceryItems.isNotEmpty) {
      groceryListContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => GroceryItemWidget(
          item: _groceryItems[index],
          onDismissedFunction: _dismissGrocery,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Your Groceries",
        ),
        actions: [
          IconButton(onPressed: addItem, icon: const Icon(Icons.add)),
        ],
      ),
      body: groceryListContent,
    );
  }
}
