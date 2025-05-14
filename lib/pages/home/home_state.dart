part of 'home_cubit.dart';

@immutable
class HomeState {
  final List<String> items;
  final List<String> filteredItems;
  final double temperature;
  final bool hasConnection;

  const HomeState({
    required this.items,
    required this.filteredItems,
    required this.temperature,
    required this.hasConnection,
  });

  HomeState copyWith({
    List<String>? items,
    List<String>? filteredItems,
    double? temperature,
    bool? hasConnection,
  }) {
    return HomeState(
      items: items ?? this.items,
      filteredItems: filteredItems ?? this.filteredItems,
      temperature: temperature ?? this.temperature,
      hasConnection: hasConnection ?? this.hasConnection,
    );
  }
}
