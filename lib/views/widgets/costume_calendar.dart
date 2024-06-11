import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:provider/provider.dart';
import 'package:petpulse/provider/health_provider.dart';

class CustomTableCalendar extends StatelessWidget {
  final Function(DateTime, DateTime) onDaySelected;

  const CustomTableCalendar({
    super.key,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<HealthScreenProvider>(context);
    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: provider.focusedDate,
      selectedDayPredicate: (day) => isSameDay(day, provider.selectedDate),
      onDaySelected: (selectedDay, focusedDay) {
        provider.setSelectedDate(selectedDay);
      },
      calendarFormat: CalendarFormat.week,
      calendarStyle: const CalendarStyle(
        defaultTextStyle: TextStyle(color: Colors.white),
        weekendTextStyle: TextStyle(color: Colors.white),
        todayTextStyle: TextStyle(color: Colors.white),
        todayDecoration: BoxDecoration(
          color: Colors.lightGreen,
          shape: BoxShape.circle,
        ),
      ),
      daysOfWeekStyle: const DaysOfWeekStyle(
        weekdayStyle: TextStyle(color: Colors.white),
        weekendStyle: TextStyle(color: Colors.white),
      ),
      headerStyle: const HeaderStyle(
        formatButtonVisible: false,
        leftChevronVisible: false,
        rightChevronVisible: false,
        headerPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 18),
      ),
      calendarBuilders: CalendarBuilders(
        selectedBuilder: (context, date, events) => Container(
          margin: const EdgeInsets.all(4),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Colors.greenAccent,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            date.day.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
