import 'package:flutter/material.dart';

final List<Trainer> trainers = [
  Trainer(
    name: "Mrs. Shreya Pandey",
    email: "shreyapandey0610@gmail.com",
    phone: "+91-9876543278",
    availability: {
      'Monday': ['10:00', '14:00', '16:00'],
      'Wednesday': ['11:00', '15:00'],
      'Friday': ['10:00', '13:00', '17:00'],
    },
  ),
  Trainer(
    name: "Mr. Rajiv Mehra",
    email: "rajiv.mehra@gmail.com",
    phone: "+91-9916500701",
    availability: {
      'Tuesday': ['09:00', '11:00'],
      'Thursday': ['10:00', '14:00'],
    },
  ),
  Trainer(
    name: "Ms. Sneha Verma",
    email: "sneha.verma@hotmail.com",
    phone: "+91-9652365415",
    availability: {
      'Monday': ['11:00', '15:00'],
      'Wednesday': ['10:00', '14:00'],
      'Friday': ['13:00', '16:00'],
    },
  ),
];

class Trainer {
  final String name;
  final String email;
  final String phone;
  final Map<String, List<String>> availability;

  Trainer({
    required this.name,
    required this.email,
    required this.phone,
    required this.availability,
  });
}

class ScheduleSessionPage extends StatefulWidget {
  const ScheduleSessionPage({Key? key}) : super(key: key);

  @override
  _ScheduleSessionPageState createState() => _ScheduleSessionPageState();
}

class _ScheduleSessionPageState extends State<ScheduleSessionPage> {
  DateTime? _selectedDate;
  String? _selectedTime;
  Trainer? _selectedTrainer;

  final Color primaryColor = const Color(0xFF6D4C41); // Elegant brown
  final Color backgroundColor = const Color(0xFFF7F6F2); // Soft neutral
  final Color cardColor = Colors.white;
  final double borderRadius = 12.0;

  String _weekdayName(int wd) {
    const names = {
      1: 'Monday',
      2: 'Tuesday',
      3: 'Wednesday',
      4: 'Thursday',
      5: 'Friday',
      6: 'Saturday',
      7: 'Sunday'
    };
    return names[wd] ?? '';
  }

  String _checkAvailability(Trainer trainer, DateTime date, String time) {
    final day = _weekdayName(date.weekday);
    final slots = trainer.availability[day] ?? [];
    return slots.contains(time)
        ? "✅ ${trainer.name} is available at $time on $day."
        : "❌ ${trainer.name} is not available at $time on $day.";
  }

  void _showBookingDialog(BuildContext context) {
    if (_selectedTrainer == null || _selectedDate == null || _selectedTime == null) return;

    final msg = _checkAvailability(_selectedTrainer!, _selectedDate!, _selectedTime!);
    final isAvailable = msg.startsWith("✅");

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Booking Status'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(msg),
            if (isAvailable) const SizedBox(height: 16),
            if (isAvailable)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Trainer Details:", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text("👤 Name: ${_selectedTrainer!.name}"),
                  Text("📧 Email: ${_selectedTrainer!.email}"),
                  Text("📱 Phone: ${_selectedTrainer!.phone}"),
                  const SizedBox(height: 12),
                  Text(
                    "➡️ You can contact the trainer via email or SMS regarding this slot.",
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                ],
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildDropdown<T>({
    required String label,
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: DropdownButton<T>(
            value: value,
            isExpanded: true,
            underline: const SizedBox(),
            items: items,
            onChanged: onChanged,
            hint: const Text("Select"),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Schedule a Session'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            buildDropdown<Trainer>(
              label: 'Select Trainer',
              value: _selectedTrainer,
              items: trainers
                  .map((t) => DropdownMenuItem(value: t, child: Text(t.name)))
                  .toList(),
              onChanged: (t) => setState(() => _selectedTrainer = t),
            ),
            const SizedBox(height: 20),

            Text("Pick a Date", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              icon: const Icon(Icons.calendar_today),
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
              ),
              onPressed: () async {
                final today = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  initialDate: today,
                  firstDate: today,
                  lastDate: today.add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => _selectedDate = picked);
              },
              label: Text(
                _selectedDate == null
                    ? 'Choose Date'
                    : 'Date: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
              ),
            ),
            const SizedBox(height: 20),

            buildDropdown<String>(
              label: "Select Time Slot",
              value: _selectedTime,
              items: ['09:00', '10:00', '11:00', '13:00', '14:00', '15:00', '16:00', '17:00']
                  .map((t) => DropdownMenuItem(value: t, child: Text(t)))
                  .toList(),
              onChanged: (t) => setState(() => _selectedTime = t),
            ),
            const SizedBox(height: 40),

            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                ),
                onPressed: (_selectedDate != null &&
                        _selectedTime != null &&
                        _selectedTrainer != null)
                    ? () => _showBookingDialog(context)
                    : null,
                child: const Text(
                  'Check Availability',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
