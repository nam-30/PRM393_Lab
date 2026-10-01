import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // Biến quản lý trạng thái
  double _sliderValue = 50;
  bool _isMovieActive = false;
  String? _selectedGenre;
  DateTime? _selectedDate;

  // Hàm hiển thị DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise 2 – Input Controls'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Slider
            const Text(
              'Rating (Slider)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Slider(
              value: _sliderValue,
              min: 0,
              max: 100,
              divisions: 100,
              label: _sliderValue.round().toString(),
              onChanged: (double value) {
                setState(() {
                  _sliderValue = value;
                });
              },
            ),
            Text('Current value: ${_sliderValue.round()}'),
            const SizedBox(height: 24),

            // 2. Switch
            const Text(
              'Active (Switch)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Is movie active?'),
              value: _isMovieActive,
              onChanged: (bool value) {
                setState(() {
                  _isMovieActive = value;
                });
              },
            ),
            const SizedBox(height: 24),

            // 3. RadioListTile Group
            const Text(
              'Genre (RadioListTile)',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Action'),
              value: 'Action',
              groupValue: _selectedGenre,
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            RadioListTile<String>(
              contentPadding: EdgeInsets.zero,
              title: const Text('Comedy'),
              value: 'Comedy',
              groupValue: _selectedGenre,
              onChanged: (String? value) {
                setState(() {
                  _selectedGenre = value;
                });
              },
            ),
            Text('Selected genre: ${_selectedGenre ?? "None"}'),
            const SizedBox(height: 24),

            // 4. DatePicker Button
            Center(
              child: Column(
                children: [
                  OutlinedButton(
                    onPressed: () => _selectDate(context),
                    child: const Text('Open Date Picker'),
                  ),
                  if (_selectedDate != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Selected Date: ${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}