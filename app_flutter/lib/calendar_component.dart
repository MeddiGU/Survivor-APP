import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CompactCalendar extends StatefulWidget {
  final Function(DateTime)? onDaySelected;
  final Map<DateTime, List<String>>? initialEvents;
  final bool allowEventCreation;

  const CompactCalendar({
    Key? key, 
    this.onDaySelected,
    this.initialEvents,
    this.allowEventCreation = false,
  }) : super(key: key);

  @override
  _CompactCalendarState createState() => _CompactCalendarState();
}

class _CompactCalendarState extends State<CompactCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<String>> _events = {};
  final TextEditingController _eventController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    if (widget.initialEvents != null) {
      _events = widget.initialEvents!;
    }
  }

  List<String> _getEventsForDay(DateTime day) {
    // Normaliser la date pour ignorer l'heure
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return _events[normalizedDay] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      elevation: 2.0,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              availableCalendarFormats: const {
                CalendarFormat.month: 'Mois',
                CalendarFormat.week: 'Semaine',
              },
              selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
              eventLoader: _getEventsForDay,
              headerStyle: HeaderStyle(
                formatButtonDecoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
                titleCentered: true,
                formatButtonVisible: true,
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markersMaxCount: 3,
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
                if (widget.onDaySelected != null) {
                  widget.onDaySelected!(selectedDay);
                }
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
            ),
            if (widget.allowEventCreation) ...[
              const SizedBox(height: 8.0),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _eventController,
                      decoration: InputDecoration(
                        labelText: "Nom de l'événement",
                        isDense: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8.0),
                  ElevatedButton(
                    onPressed: () {
                      if (_eventController.text.isNotEmpty && _selectedDay != null) {
                        setState(() {
                          final day = DateTime(_selectedDay!.year, _selectedDay!.month, _selectedDay!.day);
                          if (_events[day] == null) {
                            _events[day] = [];
                          }
                          _events[day]!.add(_eventController.text);
                          _eventController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    child: Text("Ajouter"),
                  ),
                ],
              ),
            ],
            if (_selectedDay != null && _getEventsForDay(_selectedDay!).isNotEmpty) ...[
              const SizedBox(height: 8.0),
              const Divider(),
              const SizedBox(height: 4.0),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Événements du jour",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 4.0),
              Container(
                constraints: BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _getEventsForDay(_selectedDay!).length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      dense: true,
                      title: Text(_getEventsForDay(_selectedDay!)[index]),
                      leading: Icon(Icons.event, size: 20),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _eventController.dispose();
    super.dispose();
  }
}