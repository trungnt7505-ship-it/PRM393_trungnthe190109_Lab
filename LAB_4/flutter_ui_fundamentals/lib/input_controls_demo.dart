import 'package:flutter/material.dart';

class InputControlsDemo extends StatefulWidget {
  const InputControlsDemo({super.key});

  @override
  State<InputControlsDemo> createState() => _InputControlsDemoState();
}

class _InputControlsDemoState extends State<InputControlsDemo> {
  // Trạng thái cho các input widgets
  double _currentSliderValue = 50;
  bool _isMovieActive = false;
  String? _selectedGenre;
  DateTime? _selectedDate;

  // Hàm hiển thị DatePicker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
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
        title: const Text('Exercise 2 – Input Controls Demo'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Slider Section
          const Text(
            'Rating (Slider)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _currentSliderValue,
            min: 0,
            max: 100,
            divisions: 100,
            label: _currentSliderValue.round().toString(),
            onChanged: (double value) {
              setState(() {
                _currentSliderValue = value;
              });
            },
          ),
          Text('Current value: ${_currentSliderValue.round()}'),
          const SizedBox(height: 20),

          // Switch Section
          const Text(
            'Active (Switch)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SwitchListTile(
            title: const Text('Is movie active?'),
            value: _isMovieActive,
            onChanged: (bool value) {
              setState(() {
                _isMovieActive = value;
              });
            },
          ),
          const SizedBox(height: 20),

          // RadioListTile Group Section
          const Text(
            'Genre (RadioListTile)',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          RadioListTile<String>(
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
            title: const Text('Comedy'),
            value: 'Comedy',
            groupValue: _selectedGenre,
            onChanged: (String? value) {
              setState(() {
                _selectedGenre = value;
              });
            },
          ),
          Text('Selected genre: ${_selectedGenre ?? 'None'}'),
          const SizedBox(height: 20),

          // DatePicker Button Section
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Open Date Picker'),
          ),
          const SizedBox(height: 10),
          Text(
            _selectedDate == null
                ? 'Selected Date: None'
                : 'Selected Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }
}