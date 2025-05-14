import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/components/general/bottom_nav_bar.dart';
import 'package:test_project/components/general/no_internet_connection.dart';
import 'package:test_project/components/specific/home_temperature_card.dart';
import 'package:test_project/pages/home/home_cubit.dart';

class HomePage extends StatelessWidget {
  final List<String>? initialProducts;
  const HomePage({super.key, this.initialProducts});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit(initialProducts: initialProducts)..init(),
      child: const HomeView(),
    );
  }
}

class HomeView extends StatefulWidget {
  const HomeView({super.key});
  @override
  HomeViewState createState() => HomeViewState();
}

class HomeViewState extends State<HomeView> {
  final _searchController = TextEditingController();
  final _addProductController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    _addProductController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listenWhen: (prev, curr) => prev.hasConnection && !curr.hasConnection,
      listener: (context, state) {
        showDialog<void>(
          context: context,
          builder: (_) => const NoInternetConnectionDialog(),
        );
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(backgroundColor: Colors.white),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeTemperatureCard(),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search product',
                      prefixIcon: const Icon(
                          Icons.search, color: Colors.lightBlue,),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onChanged: context.read<HomeCubit>().filterItems,
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
                                borderRadius: BorderRadius.circular(20),),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          onSubmitted: (value) {
                            context.read<HomeCubit>().addProduct(value);
                            _addProductController.clear();
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          final val = _addProductController.text;
                          context.read<HomeCubit>().addProduct(val);
                          _addProductController.clear();
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: ListView(
                      children: [
                        ExpansionTile(
                          title: const Text(
                              'List of products in the refrigerator',),
                          children: state.filteredItems.map((item) => ListTile(
                            title: Text(item),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => context
                                  .read<HomeCubit>()
                                  .removeProduct(item),
                            ),
                          ),).toList(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            bottomNavigationBar: const BottomNavBar(currentIndex: 0),
          );
        },
      ),
    );
  }
}
