import 'package:flutter/material.dart';
import 'package:test_project/components/bottom_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final List<String> items = ['Milk', 'Avocado', 'Butter', 'Bread', 'Tomato',];
  List<String> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  double _temperature = 4;

  @override
  void initState() {
    super.initState();
    filteredItems = List.from(items);
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Set Refrigerator Temperature',
                      style:
                      TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Icon(Icons.ac_unit, color: Colors.lightBlue),
                        Text('${_temperature.toStringAsFixed(1)}°C'),
                      ],
                    ),
                    Slider(
                      value: _temperature,
                      min: -5,
                      max: 10,
                      divisions: 30,
                      activeColor: Colors.lightBlue,
                      inactiveColor: Colors.lightBlue.shade100,
                      onChanged: (value) {
                        setState(() {
                          _temperature = value;
                        });
                      },
                    ),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Min: -5°C',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Max: 10°C',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search product',
                prefixIcon: const Icon(Icons.search, color: Colors.lightBlue),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: _filterItems,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: const Text('List of products in the refrigerator'),
                    children: filteredItems
                        .map((item) => ListTile(title: Text(item)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
        bottomNavigationBar: const BottomNavBar(currentIndex: 0,),
    );
  }
}
