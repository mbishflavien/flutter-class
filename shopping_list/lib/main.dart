import 'package:flutter/material.dart';

// Step 8: the model: a name and a bought status
class Item {
  Item(this.name);

  final String name;
  bool bought = false;
}

void main() {
  runApp(const ShoppingApp());
}

class ShoppingApp extends StatelessWidget {
  const ShoppingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.green),
      home: const HomeScreen(title: 'Shopping List'),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = [Item('Milk'), Item('Bread'), Item('Rice')];
  final controller = TextEditingController();

  // Shows a short message at the bottom of the screen
  void showMessage(String message) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(SnackBar(content: Text(message)));
  }

  // Step 6: the rules for adding
  void addItem() {
    final text = controller.text.trim();
    if (text.isEmpty) {
      showMessage('Type an item first');
      return;
    }
    // Step 6, Your turn 2: refuse duplicates
    final alreadyThere =
        items.any((item) => item.name.toLowerCase() == text.toLowerCase());
    if (alreadyThere) {
      showMessage('$text is already on the list');
      return;
    }
    setState(() {
      items.add(Item(text));
    });
    controller.clear();
  }

  // Step 7: delete one row, then say what was removed
  void deleteItem(int index) {
    final name = items[index].name;
    setState(() {
      items.removeAt(index);
    });
    showMessage('$name removed');
  }

  // Step 8: tap to mark or un-mark as bought
  void toggleBought(int index) {
    setState(() {
      items[index].bought = !items[index].bought;
    });
  }

  // Step 8: remove every bought item at once
  void clearBought() {
    setState(() {
      items.removeWhere((item) => item.bought);
    });
  }

  int itemsLeft() {
    return items.where((item) => !item.bought).length;
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.title} (${itemsLeft()} left)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            tooltip: 'Remove bought items',
            onPressed: clearBought,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: 'Add an item',
                      border: OutlineInputBorder(),
                    ),
                    // Step 6, Your turn 1: Enter adds the item too
                    onSubmitted: (_) => addItem(),
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton(
                  onPressed: addItem,
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          Expanded(
            // Push further: a message instead of a blank screen
            child: items.isEmpty
                ? const Center(child: Text('Your list is empty'))
                : ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ListTile(
                        leading: Icon(
                          item.bought
                              ? Icons.check_circle
                              : Icons.shopping_basket,
                        ),
                        title: Text(
                          item.name,
                          style: TextStyle(
                            decoration: item.bought
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                        ),
                        // Step 4, Your turn: the row's position
                        subtitle: Text('Item ${index + 1}'),
                        onTap: () => toggleBought(index),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => deleteItem(index),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}