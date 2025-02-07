import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'encounters/encounters_service.dart';

class PieChartWidget extends StatefulWidget {
  @override
  _PieChartWidgetState createState() => _PieChartWidgetState();
}

class _PieChartWidgetState extends State<PieChartWidget> {
  final EncountersService _encountersService = EncountersService();
  Map<String, int> sourceDistribution = {};
  bool isLoading = true;
  int? touchedIndex;

  final List<Color> colors = [
    Color(0xFF2196F3), // Bleu vif
    Color(0xFFF44336), // Rouge
    Color(0xFF4CAF50), // Vert
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Violet
    Color(0xFF795548), // Marron
    Color(0xFF009688), // Turquoise
    Color(0xFFE91E63), // Rose
    Color(0xFF673AB7), // Violet foncé
    Color(0xFFFFEB3B), // Jaune
    Color(0xFF607D8B), // Bleu gris
    Color(0xFF3F51B5), // Indigo
    Color(0xFFCDDC39), // Vert lime
    Color(0xFFFF5722), // Orange foncé
    Color(0xFF00BCD4), // Cyan
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final encounters = await _encountersService.getEncounters();
      final Map<String, int> distribution = {};
      
      for (var encounter in encounters) {
        distribution[encounter.source] = (distribution[encounter.source] ?? 0) + 1;
      }
      
      setState(() {
        sourceDistribution = distribution;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error loading encounters: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    if (sourceDistribution.isEmpty) {
      return Center(child: Text("Aucune donnée disponible"));
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Text(
            "Source Meeting by Customers",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 30),
          SizedBox(
            height: 400,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        touchedIndex = -1;
                        return;
                      }
                      touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                sections: List.generate(sourceDistribution.length, (i) {
                  final entry = sourceDistribution.entries.elementAt(i);
                  final bool isTouched = touchedIndex == i;
                  final double fontSize = isTouched ? 20 : 16;
                  final double radius = isTouched ? 130 : 120;

                  return PieChartSectionData(
                    color: colors[i % colors.length],
                    value: entry.value.toDouble(),
                    title: isTouched ? '${entry.key}\n${entry.value}' : '${entry.value}',
                    radius: radius,
                    titleStyle: TextStyle(
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }),
                sectionsSpace: 3,
                centerSpaceRadius: 50,
              ),
            ),
          ),
        ],
      ),
    );
  }
}