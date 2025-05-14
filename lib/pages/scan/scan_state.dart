part of 'scan_cubit.dart';

@immutable
class ScanFridgeState {
  final List<String> products;

  const ScanFridgeState({this.products = const []});

  ScanFridgeState copyWith({List<String>? products}) {
    return ScanFridgeState(
      products: products ?? this.products,
    );
  }
}
