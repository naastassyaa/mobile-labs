import 'package:flutter/material.dart';

class HomeTemperatureCard extends StatefulWidget {
  final double temperature;
  final ValueChanged<double> onTemperatureChanged;

  const HomeTemperatureCard({
    required this.temperature,
    required this.onTemperatureChanged,
    super.key,
  });

  @override
  HomeTemperatureCardState createState() => HomeTemperatureCardState();
}

class HomeTemperatureCardState extends State<HomeTemperatureCard> {
  late double _temperature;

  @override
  void initState() {
    super.initState();
    _temperature = widget.temperature;
  }

  @override
  void didUpdateWidget(covariant HomeTemperatureCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.temperature != oldWidget.temperature) {
      setState(() {
        _temperature = widget.temperature;
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
                widget.onTemperatureChanged(value);
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
    );
  }
}
