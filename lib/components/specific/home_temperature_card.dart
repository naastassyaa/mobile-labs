import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_project/pages/home/home_cubit.dart';

class HomeTemperatureCard extends StatelessWidget {
  const HomeTemperatureCard({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      buildWhen: (prev, curr) => prev.temperature != curr.temperature,
      builder: (context, state) {
        final temp = state.temperature;
        return Card(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Set Refrigerator Temperature',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,),),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(Icons.ac_unit, color: Colors.lightBlue),
                    Text('${temp.toStringAsFixed(1)}°C',
                        style: const TextStyle(fontSize: 16),),
                  ],
                ),
                Slider(
                  value: temp,
                  min: -5,
                  max: 10,
                  divisions: ((10 - (-5)) ~/ 0.5),
                  label: '${temp.toStringAsFixed(1)}°C',
                  onChanged: (value) => context
                      .read<HomeCubit>()
                      .changeTemperature(value),
                ),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Min: -5°C',
                        style: TextStyle(fontSize: 14, color: Colors.grey),),
                    Text('Max: 10°C',
                        style: TextStyle(fontSize: 14, color: Colors.grey),),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
