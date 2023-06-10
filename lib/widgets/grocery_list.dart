import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shopping_list/widgets/grocery_item_widget.dart';
import 'package:shopping_list/widgets/new_item.dart';
import 'package:http/http.dart' as http;
import '../data/categories.dart';
import '../models/grocery_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() {
    return _GroceryListState();
  }
}

class _GroceryListState extends State<GroceryList> {
  List<GroceryItem> _groceryItems = [];
  var isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    final url = Uri.https(
        'flutter-app-ba306-default-rtdb.firebaseio.com', 'shopping-list.json');

    try {
      final response = await http.get(url);
      if (response.statusCode >= 400) {
        setState(() {
          _error = "Failed to fetch data. Please try again later.";
        });
      }

      if (response.body == 'null') {
        setState(() {
          isLoading = false;
        });
        return;
      }
      final Map<String, dynamic> listData = json.decode(response.body);
      final List<GroceryItem> loadedItems = [];
      for (final item in listData.entries) {
        final category = categories.entries
            .firstWhere(
                (element) => element.value.category == item.value["category"])
            .value;
        loadedItems.add(
          GroceryItem(
              id: item.key,
              name: item.value["name"],
              quantity: item.value["quantity"],
              category: category),
        );
      }
      setState(() {
        _groceryItems = loadedItems;
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

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

  void _dismissGrocery(GroceryItem grocery) async {
    final index = _groceryItems.indexOf(grocery);
    setState(() {
      _groceryItems.remove(grocery);
    });
    final url = Uri.https('flutter-app-ba306-default-rtdb.firebaseio.com',
        'shopping-list/${grocery.id}.json');

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      setState(() {
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Deletion failed.")));
        _groceryItems.insert(index, grocery);
      });
    }
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

    if (isLoading) {
      groceryListContent = const Center(child: CircularProgressIndicator());
    }

    if (_groceryItems.isNotEmpty) {
      groceryListContent = ListView.builder(
        itemCount: _groceryItems.length,
        itemBuilder: (ctx, index) => GroceryItemWidget(
          item: _groceryItems[index],
          onDismissedFunction: _dismissGrocery,
        ),
      );
    }

    if (_error != null) {
      groceryListContent = Center(child: Text(_error!));
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
