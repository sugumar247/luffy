import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: SimpleDatePicker(),
  ));
}

class SimpleDatePicker extends StatefulWidget {
  const SimpleDatePicker({super.key});

  @override
  State<SimpleDatePicker> createState() => _SimpleDatePickerState();
}

class _SimpleDatePickerState extends State<SimpleDatePicker> {
  String selectedDate = 'No date selected';

  void _pickDate() async {
    DateTime? date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(), 
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (date != null) {
      setState(() {
        selectedDate = '${date.year}-${date.month}-${date.day}';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Simple Date Picker')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(selectedDate),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _pickDate,
              child: const Text('Pick a Date'),
            ),
          ],
        ),
      ),
    );
  }
}