import 'package:flutter/material.dart';

class MenteeDataCollection extends StatefulWidget {
  const MenteeDataCollection({super.key});

  @override
  State<MenteeDataCollection> createState() => _MenteeDataCollectionState();
}

class _MenteeDataCollectionState extends State<MenteeDataCollection> {
  String? _selectedArea;
  final List<String> _selectedChips = [];

  void _onChipSelected(String chipName) {
    setState(() {
      if (_selectedChips.contains(chipName)) {
        _selectedChips.remove(chipName);
      } else {
        _selectedChips.add(chipName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8ECAE6),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(16.0),
          color: const Color(0xFF8ECAE6), // Background color
          width: double.infinity, // Extend to full width
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/Logo1.png'),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Choose the area of Interest',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  ChoiceChip(
                    label: const Text('Optionsbfhsaj'),
                    selected: _selectedArea == 'Optionsbfhsaj',
                    onSelected: (selected) {
                      setState(() {
                        _selectedArea = selected ? 'Optionsbfhsaj' : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Option'),
                    selected: _selectedArea == 'Option',
                    onSelected: (selected) {
                      setState(() {
                        _selectedArea = selected ? 'Option' : null;
                      });
                    },
                  ),
                  ChoiceChip(
                    label: const Text('Optionsbfhsajmk'),
                    selected: _selectedArea == 'Optionsbfhsajmk',
                    onSelected: (selected) {
                      setState(() {
                        _selectedArea = selected ? 'Optionsbfhsajmk' : null;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Choose the area of Interest',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: const Text('Optiongvbhnjn'),
                    selected: _selectedChips.contains('Optiongvbhnjn'),
                    onSelected: (_) => _onChipSelected('Optiongvbhnjn'),
                  ),
                  FilterChip(
                    label: const Text('Optionkooko2'),
                    selected: _selectedChips.contains('Optionkooko2'),
                    onSelected: (_) => _onChipSelected('Optionkooko2'),
                  ),
                  FilterChip(
                    label: const Text('Option 3'),
                    selected: _selectedChips.contains('Option 3'),
                    onSelected: (_) => _onChipSelected('Option 3'),
                  ),
                  FilterChip(
                    label: const Text('Option 4'),
                    selected: _selectedChips.contains('Option 4'),
                    onSelected: (_) => _onChipSelected('Option 4'),
                  ),
                  FilterChip(
                    label: const Text('Option 5'),
                    selected: _selectedChips.contains('Option 5'),
                    onSelected: (_) => _onChipSelected('Option 5'),
                  ),
                  FilterChip(
                    label: const Text('Option 6'),
                    selected: _selectedChips.contains('Option 6'),
                    onSelected: (_) => _onChipSelected('Option 6'),
                  ),
                  FilterChip(
                    label: const Text('Option 7'),
                    selected: _selectedChips.contains('Option 7'),
                    onSelected: (_) => _onChipSelected('Option 7'),
                  ),
                  // Add more FilterChip widgets here
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                'Choose your dream companies',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              Wrap(
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: const Text('Optiongvbhnj'),
                    selected: _selectedChips.contains('Optiongvbhnj'),
                    onSelected: (_) => _onChipSelected('Optiongvbhnj'),
                  ),
                  FilterChip(
                    label: const Text('Optiongvbhnjk'),
                    selected: _selectedChips.contains('Optiongvbhnjk'),
                    onSelected: (_) => _onChipSelected('Optiongvbhnjk'),
                  ),
                  FilterChip(
                    label: const Text('Option'),
                    selected: _selectedChips.contains('Option'),
                    onSelected: (_) => _onChipSelected('Option'),
                  ),
                  FilterChip(
                    label: const Text('OOptionqwerty'),
                    selected: _selectedChips.contains('OOptionqwerty'),
                    onSelected: (_) => _onChipSelected('OOptionqwerty'),
                  ),
                  FilterChip(
                    label: const Text('Optionqwer'),
                    selected: _selectedChips.contains('Optionqwer'),
                    onSelected: (_) => _onChipSelected('Optionqwer'),
                  ),
                  FilterChip(
                    label: const Text('Optionqwerb'),
                    selected: _selectedChips.contains('Optionqwerb'),
                    onSelected: (_) => _onChipSelected('Optionqwerb'),
                  ),
                  FilterChip(
                    label: const Text('Optionqweasdf'),
                    selected: _selectedChips.contains('Optionqweasdf'),
                    onSelected: (_) => _onChipSelected('Optionqweasdf'),
                  ),
                  // Add more FilterChip widgets here
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              const Text(
                textAlign: TextAlign.center,
                'Give a bio so that mentors can understand you well.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.black,
                ),
              ),
              TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Type here...',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  // Add your button onPressed logic here
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor:
                      const Color.fromARGB(255, 2, 48, 71), // Text color
                ),
                child: const Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
