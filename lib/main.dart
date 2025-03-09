import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const TextCaseConverter(),
    );
  }
}

class TextCaseConverter extends StatefulWidget {
  const TextCaseConverter({super.key});

  @override
  TextCaseConverterState createState() => TextCaseConverterState();
}

class TextCaseConverterState extends State<TextCaseConverter> {
  final TextEditingController _controller = TextEditingController();
  String _convertedText = '';

  void _convertToUppercase() {
    setState(() {
      _convertedText = _controller.text.toUpperCase();
    });
  }

  void _convertToLowercase() {
    setState(() {
      _convertedText = _controller.text.toLowerCase();
    });
  }

  void _convertToTitleCase() {
    setState(() {
      _convertedText = _controller.text
          .split(' ')
          .map((str) => str.isNotEmpty
          ? str[0].toUpperCase() + str.substring(1).toLowerCase()
          : '',)
          .join(' ');
    });
  }

  void _clearInput() {
    setState(() {
      _controller.clear();
      _convertedText = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Text Case Converter',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                labelText: 'Enter text',
                labelStyle: const TextStyle(color: Colors.teal),
                hintText: 'Type your text here',
                hintStyle: const TextStyle(color: Colors.grey),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.tealAccent,
                      width: 2,),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildCustomButton('To Uppercase', _convertToUppercase),
                _buildCustomButton('To Lowercase', _convertToLowercase),
              ],
            ),
            const SizedBox(height: 20),
            _buildCustomButton('To Title Case', _convertToTitleCase),
            const SizedBox(height: 20),
            const Text(
              'Converted Text:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              _convertedText.isEmpty ? 'No text to convert' : _convertedText,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                  color: Colors.teal,),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            _buildCustomButton('Clear', _clearInput),
          ],
        ),
      ),
    );
  }
  // Custom button styling
  Widget _buildCustomButton(String text, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(Colors.teal),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(vertical: 12, horizontal: 24,),),
        shape: WidgetStateProperty.all(RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),),
        elevation: WidgetStateProperty.all(5),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
