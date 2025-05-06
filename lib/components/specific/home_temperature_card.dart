import 'package:flutter/material.dart';

class HomeTemperatureCard extends StatefulWidget {
  final double temperature;
  final ValueChanged<double> onTemperatureChanged;

  const HomeTemperatureCard({
    required this.temperature, required this.onTemperatureChanged, super.key,
  });

  @override
  HomeTemperatureCardState createState() => HomeTemperatureCardState();
}

class HomeTemperatureCardState extends State<HomeTemperatureCard> {
  static const double _minTemp = -5;
  static const double _maxTemp = 10;

  late double _temperature;

  @override
  void initState() {
    super.initState();
    _temperature = widget.temperature.clamp(_minTemp, _maxTemp);
  }

  @override
  void didUpdateWidget(covariant HomeTemperatureCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.temperature != oldWidget.temperature) {
      setState(() {
        _temperature = widget.temperature.clamp(_minTemp, _maxTemp);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
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
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.ac_unit, color: Colors.lightBlue),
                Text(
                  '${_temperature.toStringAsFixed(1)}°C',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            Slider(
              value: _temperature,
              min: _minTemp,
              max: _maxTemp,
              divisions: ((_maxTemp - _minTemp) ~/ 0.5),
              label: '${_temperature.toStringAsFixed(1)}°C',
              onChanged: (value) {
                setState(() => _temperature = value);
                widget.onTemperatureChanged(value);
              },
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Min: -5°C', style: TextStyle(fontSize: 14,
                    color: Colors.grey,),),
                Text('Max: 10°C', style: TextStyle(fontSize: 14,
                    color: Colors.grey,),),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
