import 'package:flutter/material.dart';

void main() {
  runApp(const UrbanHarvestApp());
}

class UrbanHarvestApp extends StatelessWidget {
  const UrbanHarvestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Urban Harvest',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  
  // Pagination Data (Requirement #6)
  final List<String> _items = List.generate(10, (i) => "Post Item ${i + 1}");
  bool _isLoading = false;

  // Simulate API Call for Pagination (Requirement #6)
  void _loadMore() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1)); // Fake network delay
    setState(() {
      _items.addAll(List.generate(10, (i) => "Post Item ${_items.length + i + 1}"));
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Urban Harvest'), backgroundColor: Colors.green),
      body: _currentIndex == 0
          ? _buildHomeFeed()
          : const Center(child: Text("Other Page")),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create Post'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Requirement #5: Open the form with textboxes and dropdowns
          _showCreatePostForm(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildHomeFeed() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(_items[index]),
                  subtitle: const Text("This is a post from the community."),
                ),
              );
            },
          ),
        ),
        if (_isLoading)
          const Padding(padding: EdgeInsets.all(16), child: CircularProgressIndicator()),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: _isLoading ? null : _loadMore,
            child: Text(_isLoading ? "Loading..." : "Load More (Pagination)"),
          ),
        ),
      ],
    );
  }

  // Requirement #5: Multiple Text boxes and Dropdown lists
  void _showCreatePostForm(BuildContext context) {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController contentController = TextEditingController();
    String? selectedCategory;
    String? selectedPlantType;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text("Create New Post", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: "Post Title", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: contentController,
                  maxLines: 3,
                  decoration: const InputDecoration(labelText: "What's growing?", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Category", border: OutlineInputBorder()),
                  items: ['General', 'Pest Control', 'Seed Swap', 'Question']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => selectedCategory = val,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(labelText: "Plant Type", border: OutlineInputBorder()),
                  items: ['Tomato', 'Basil', 'Rose', 'Money Plant']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (val) => selectedPlantType = val,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the form
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Post Created Successfully!")),
                    );
                  },
                  child: const Text("Submit Post"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}