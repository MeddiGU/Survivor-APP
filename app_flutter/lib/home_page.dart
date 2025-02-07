import 'package:app_flutter/pie_chart.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.query_stats_sharp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            SizedBox(width: 8),
            Text(
              'Statistiques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C365D),
              ),
            ),
          ],
        ),
      ),
      body: Center(child: PieChartWidget()),
    );
  }
}
