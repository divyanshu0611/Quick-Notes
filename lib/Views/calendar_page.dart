import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quick_notes/App_Routes/app_routes.dart';
import 'package:quick_notes/widgets/Calendar/calendar_task_list.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import 'package:quick_notes/Controller/CRUD_Controller/crude_controller.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  Map<DateTime, List<dynamic>> _events = {};
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
  _taskSubscription;

  @override
  void initState() {
    super.initState();
    _listenToTaskChanges();
  }

  void _listenToTaskChanges() {
    _taskSubscription = DataBaseMethods().getUserTasksStream().listen(
      (snapshot) {
        final Map<DateTime, List<dynamic>> events = {};
        for (var doc in snapshot.docs) {
          final dateStr = doc['Date'] as String?;
          if (dateStr != null) {
            try {
              final dt = DateTime.parse(dateStr); // 'yyyy-MM-dd'
              final key = DateTime(dt.year, dt.month, dt.day);
              events.putIfAbsent(key, () => []).add(doc);
            } catch (e) {
              debugPrint("Error parsing date: $e");
            }
          }
        }
        if (!mapEquals(_events, events)) {
          setState(() => _events = events);
        }
        // setState(() => _events = events); // 🔁 rebuilds the calendar markers
      },
      onError: (error) {
        debugPrint("Firestorestream error: $error");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error loading tasks: $error")),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    _taskSubscription.cancel(); // ✅ Prevent memory leak
    super.dispose();
  }

  DateTime? safeParseDate(String? dateStr) {
    try {
      if (dateStr == null) return null;
      final dt = DateTime.parse(dateStr);
      return DateTime(dt.year, dt.month, dt.day);
    } catch (e) {
      debugPrint("Error parsing date: $e");
      return null;
    }
  }

  // Helper to filter tasks by date
  Stream<QuerySnapshot<Map<String, dynamic>>> _taskStreamFor(DateTime date) {
    final formatted = DateFormat('yyyy-MM-dd').format(date);
    return DataBaseMethods().getTasksByDate(formatted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Schedule",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 24),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed:
              () => Get.offAllNamed(
                AppRoutes.customBottomNavBar,
                arguments: {'tabIndex': 0},
              ),
          icon: const Icon(Icons.arrow_back, size: 28, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        child: Column(
          children: [
            /// 📅 Calendar
            TableCalendar(
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        events.length > 3 ? 3 : events.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 1.5),
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    );
                  }
                  return null;
                },
              ),

              calendarFormat: _calendarFormat,
              focusedDay: _focusedDay,
              firstDay: DateTime.utc(2025, 1, 1),
              lastDay: DateTime.utc(2030, 1, 1),
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) => isSameDay(_selectedDate, day),

              // 2) Provide events for markers
              eventLoader:
                  (day) =>
                      _events[DateTime(day.year, day.month, day.day)] ?? [],

              onDaySelected: (selectedDay, focusedDay) {
                if (!isSameDay(_selectedDate, selectedDay)) {
                  setState(() {
                    _selectedDate = selectedDay;
                    _focusedDay = focusedDay;
                  });
                }
              },
              onFormatChanged: (format) {
                setState(() => _calendarFormat = format);
              },
              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: const Color(0xff0093E9),
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                todayDecoration: BoxDecoration(color: const Color(0xff80D0C7)),
                todayTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                defaultTextStyle: const TextStyle(color: Colors.black),
                weekendTextStyle: const TextStyle(color: Colors.red),
              ),
              headerStyle: HeaderStyle(
                titleTextStyle: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                formatButtonTextStyle: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                ),
                leftChevronIcon: const Icon(
                  Icons.chevron_left,
                  color: Colors.black,
                ),
                rightChevronIcon: const Icon(
                  Icons.chevron_right,
                  color: Colors.black,
                ),
                formatButtonDecoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  // borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Divider(thickness: 1.2),

            /// 📋 Tasks for selected date
            Expanded(
              child: CalendarTaskList(
                taskStream: _taskStreamFor(_selectedDate),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
