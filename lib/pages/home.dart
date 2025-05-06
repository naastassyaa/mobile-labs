import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/components/specific/home_temperature_card.dart';
import 'package:test_project/services/fridge_data.dart';
import 'package:test_project/services/mqtt_service.dart';

class HomePage extends StatefulWidget {
  final List<String>? initialProducts;

  const HomePage({super.key, this.initialProducts});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<String> items = [];
  List<String> filteredItems = [];
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _addProductController = TextEditingController();
  double _temperature = 4;
  final MqttService _mqttService = MqttService();

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    super.initState();
    items = widget.initialProducts ?? FridgeData().products;
    filteredItems = List.from(items);
    _mqttService.connect();
    _mqttService.onTemperatureReceived = (temp) {
      setState(() => _temperature = temp);
    };

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((results) {
      final status = results.first;
      if (status == ConnectivityResult.none && mounted) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          showDialog<void>(
            context: context,
            builder: (_) => const NoInternetConnectionDialog(

            ),
          );
        });
      }
    });
  }

  @override
  void dispose() {
    _mqttService.disconnect();
    _connectivitySubscription.cancel();
    _searchController.dispose();
    _addProductController.dispose();
    super.dispose();
  }

  void _filterItems(String query) {
    setState(() {
      filteredItems = items
          .where((item) => item.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _addProduct(String newItem) {
    if (newItem.isEmpty) return;
    setState(() {
      items.add(newItem);
      filteredItems = List.from(items);
      FridgeData().products = items;
      _addProductController.clear();
    });
  }

  void _removeItem(String itemToRemove) {
    setState(() {
      items.remove(itemToRemove);
      filteredItems = List.from(items);
      FridgeData().products = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeTemperatureCard(
              temperature: _temperature,
              onTemperatureChanged: (v) => setState(() => _temperature = v),
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
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _addProductController,
                    decoration: InputDecoration(
                      labelText: 'Add product',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () => _addProduct(_addProductController.text),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ExpansionTile(
                    title: const Text('List of products in the refrigerator'),
                    children: filteredItems
                        .map((item) => ListTile(
                      title: Text(item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () => _removeItem(item),
                      ),
                    ),)
                        .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
    );
  }
}
