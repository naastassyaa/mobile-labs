class FridgeData {
  static final FridgeData _instance = FridgeData._internal();
  factory FridgeData() => _instance;
  FridgeData._internal();

  List<String> products = [];
}
