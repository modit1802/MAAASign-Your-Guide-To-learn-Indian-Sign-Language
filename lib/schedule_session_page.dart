import 'package:flutter/material.dart';

/// Trainer model
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

/// Hard‑coded trainers
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

/// Colors & styling constants
const Color backgroundColor = Color.fromARGB(255, 250, 233, 215);
const Color primaryColor    = Color.fromARGB(255, 165, 74, 17);
const double borderRadius   = 12.0;

class ScheduleSessionPage extends StatefulWidget {
  const ScheduleSessionPage({Key? key}) : super(key: key);

  @override
  _ScheduleSessionPageState createState() => _ScheduleSessionPageState();
}

class _ScheduleSessionPageState extends State<ScheduleSessionPage> {
  Trainer? _selectedTrainer;
  DateTime? _selectedDate;
  String? _selectedTime;

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

  String _checkAvailability() {
    final day = _weekdayName(_selectedDate!.weekday);
    final slots = _selectedTrainer!.availability[day] ?? [];
    return slots.contains(_selectedTime)
        ? "✅ ${_selectedTrainer!.name} is available at $_selectedTime on $day."
        : "❌ ${_selectedTrainer!.name} is not available at $_selectedTime on $day.";
  }

  void _showBookingDialog() {
    final msg = _checkAvailability();
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
            if (isAvailable) ...[
              const Text('Trainer Details:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Text('👤 Name: ${_selectedTrainer!.name}'),
              Text('📧 Email: ${_selectedTrainer!.email}'),
              Text('📱 Phone: ${_selectedTrainer!.phone}'),
              const SizedBox(height: 12),
              Text(
                '➡️ Contact the trainer to confirm your session.',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine available time slots for the selected trainer & date
    List<String> availableTimes = [];
    if (_selectedTrainer != null && _selectedDate != null) {
      final day = _weekdayName(_selectedDate!.weekday);
      availableTimes = _selectedTrainer!.availability[day] ?? [];
    }

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: primaryColor),
        title: const Text(
          'Schedule a Session',
          style: TextStyle(
            color: primaryColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Trainer selector
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Trainer',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<Trainer>(
                      hint: const Text('Choose a trainer'),
                      value: _selectedTrainer,
                      isExpanded: true,
                      items: trainers
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t.name),
                              ))
                          .toList(),
                      onChanged: (t) => setState(() {
                        _selectedTrainer = t;
                        _selectedDate = null;
                        _selectedTime = null;
                      }),
                      underline: const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Date picker
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: ListTile(
                leading: const Icon(Icons.calendar_today, color: primaryColor),
                title: const Text(
                  'Select Date',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  _selectedDate == null
                      ? 'Tap to choose'
                      : _selectedDate!.toLocal().toString().split(' ')[0],
                ),
                trailing: const Icon(Icons.keyboard_arrow_down),
                onTap: _selectedTrainer == null
                    ? null
                    : () async {
                        final today = DateTime.now();
                        final picked = await showDatePicker(
                          context: context,
                          initialDate: today,
                          firstDate: today,
                          lastDate: today.add(const Duration(days: 30)),
                        );
                        if (picked != null) {
                          setState(() {
                            _selectedDate = picked;
                            _selectedTime = null;
                          });
                        }
                      },
              ),
            ),

            const SizedBox(height: 16),

            // Time picker
            Card(
              color: Colors.white,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Select Time Slot',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: primaryColor,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButton<String>(
                      hint: const Text('Choose a time'),
                      value: _selectedTime,
                      isExpanded: true,
                      items: availableTimes
                          .map((t) => DropdownMenuItem(
                                value: t,
                                child: Text(t),
                              ))
                          .toList(),
                      onChanged: (t) => setState(() => _selectedTime = t),
                      underline: const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Check Availability button
            Center(
              child: ElevatedButton(
                onPressed: (_selectedTrainer != null &&
                        _selectedDate != null &&
                        _selectedTime != null)
                    ? _showBookingDialog
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius),
                  ),
                  elevation: 4,
                ),
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
