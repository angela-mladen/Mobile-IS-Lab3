import 'package:flutter/material.dart';
import '../models/exam.dart';
import 'package:table_calendar/table_calendar.dart';
import '../notification_helper.dart';

class CalendarView extends StatefulWidget {
  final List<Exam> exams;

  const CalendarView({Key? key, required this.exams}) : super(key: key);

  @override
  _CalendarViewState createState() => _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<Exam> _selectedExams = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.now(),
            lastDay: DateTime(DateTime.now().year + 5),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            eventLoader: (day) {
              // Load events for the specified day
              return widget.exams
                  .where((exam) => isSameDay(exam.dateTime, day))
                  .toList();
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedExams = widget.exams
                      .where((exam) => isSameDay(exam.dateTime, selectedDay))
                      .toList();
                  _showExamDetailsDialog(context);
                });
              }
            },
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
        ],
      ),
    );
  }

  void _showExamDetailsDialog(BuildContext context) {
   // final notificationHelper=NotificationHelper();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Exam Details'),
          content: Column(
            children: _selectedExams
                .map((exam) => ListTile(
                      title: Text(exam.course),
                      subtitle: Text(
                          "Time: ${exam.dateTime.hour}:${exam.dateTime.minute}"),
                    ))
                .toList(),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                //_scheduleNotification(notificationHelper);
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

// void _scheduleNotification(NotificationHelper notificationHelper) {
//   for (final exam in _selectedExams) {
//     final scheduledTime = exam.dateTime.subtract(const Duration(minutes: 15));
//     notificationHelper.showNotification(
//       'Upcoming Exam: ${exam.course}',
//       'Scheduled at ${exam.dateTime.hour}:${exam.dateTime.minute}',
//     );
//   }
// }
}