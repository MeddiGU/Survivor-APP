import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:app_flutter/events/events_model.dart';
import 'package:app_flutter/events/events_service.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  List<EventDTO> _events = [];
  EventDTO? _selectedEvent;
  bool _isLoading = true;
  MapController _mapController = MapController();
  final EventsService _eventsService = EventsService();

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEvents();
  }

  void _loadEvents() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final events = await _eventsService.fetchEvents();
      setState(() {
        _events = events;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des événements: ${e.toString()}')),
      );
    }
  }

  List<EventDTO> _getEventsForDay(DateTime day) {
    return _events.where((event) => 
      event.date.year == day.year && 
      event.date.month == day.month && 
      event.date.day == day.day
    ).toList();
  }

  void _onEventSelected(EventDTO event) {
    setState(() {
      _selectedEvent = event;
    });
    
    // Centrer la carte sur l'emplacement de l'événement
    _mapController.move(
      LatLng(event.location_x, event.location_y), 
      13.0
    );
  }

  void _addEventDialog(BuildContext context) {
    if (_selectedDay == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez d\'abord sélectionner une date')),
      );
      return;
    }

    final TextEditingController _nameController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un événement'),
        content: TextField(
          controller: _nameController,
          decoration: InputDecoration(labelText: 'Nom de l\'événement'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Annuler'),
          ),
          ElevatedButton(
            onPressed: () {
              // Ici, vous pourriez implémenter l'ajout à l'API
              // Pour l'instant, on ferme simplement le dialogue
              Navigator.pop(context);
            },
            child: Text('Ajouter'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Events Calendar'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadEvents,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      // Partie gauche (calendrier)
                      Expanded(
                        flex: 1,
                        child: Card(
                          margin: EdgeInsets.all(8.0),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                TableCalendar(
                                  firstDay: DateTime.utc(2020, 1, 1),
                                  lastDay: DateTime.utc(2030, 12, 31),
                                  focusedDay: _focusedDay,
                                  calendarFormat: _calendarFormat,
                                  headerStyle: HeaderStyle(
                                    formatButtonVisible: true,
                                    titleCentered: true,
                                  ),
                                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                  eventLoader: (day) => _getEventsForDay(day),
                                  onDaySelected: (selectedDay, focusedDay) {
                                    setState(() {
                                      _selectedDay = selectedDay;
                                      _focusedDay = focusedDay;
                                    });
                                  },
                                  onFormatChanged: (format) {
                                    setState(() {
                                      _calendarFormat = format;
                                    });
                                  },
                                ),
                                SizedBox(height: 8),
                                Expanded(
                                  child: _selectedDay == null
                                      ? Center(child: Text('Sélectionnez une date'))
                                      : _buildEventList(_getEventsForDay(_selectedDay!)),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      
                      // Partie droite (carte)
                      Expanded(
                        flex: 1,
                        child: Card(
                          margin: EdgeInsets.all(8.0),
                          child: _buildMap(),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEventDialog(context),
        child: Icon(Icons.add),
        tooltip: 'Ajouter un événement',
      ),
    );
  }

  Widget _buildEventList(List<EventDTO> events) {
    if (events.isEmpty) {
      return Center(child: Text('Aucun événement pour cette date'));
    }

    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return ListTile(
          title: Text(event.name),
          subtitle: Text(event.location_name),
          trailing: Text('Max: ${event.max_participants}'),
          selected: _selectedEvent?.id == event.id,
          onTap: () => _onEventSelected(event),
        );
      },
    );
  }

  Widget _buildMap() {
    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        center: LatLng(43.597, 1.441), // Centre initial (comme dans votre code React)
        zoom: 13.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          additionalOptions: {
            'attribution': '© OpenStreetMap contributors',
          },
        ),
        MarkerLayer(
          markers: _selectedEvent != null
              ? [
                  Marker(
                    point: LatLng(_selectedEvent!.location_x, _selectedEvent!.location_y),
                    width: 80.0,
                    height: 80.0,
                    builder: (context) => Icon(
                      Icons.location_on,
                      color: Colors.red,
                      size: 40.0,
                    ),
                  ),
                ]
              : [],
        ),
      ],
    );
  }
}