import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(FitnessTrackerApp());
}

class FitnessTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.latoTextTheme(),
      ),
      home: FitnessTrackerScreen(),
    );
  }
}

class FitnessTrackerScreen extends StatefulWidget {
  @override
  _FitnessTrackerScreenState createState() => _FitnessTrackerScreenState();
}

class _FitnessTrackerScreenState extends State<FitnessTrackerScreen> {
  int steps = 0;
  double caloriesBurned = 0.0;
  int entryCount = 6; // Starting count for the first graph point

  final TextEditingController stepsController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();

  List<FlSpot> workoutProgress = [
    FlSpot(1, 2),
    FlSpot(2, 3),
    FlSpot(3, 5),
    FlSpot(4, 7),
    FlSpot(5, 8),
  ];

  void updateValues() {
    setState(() {
      // Parse the input values
      steps = int.tryParse(stepsController.text) ?? 0;
      caloriesBurned = double.tryParse(caloriesController.text) ?? 0.0;

      // Add a new data point to the graph
      workoutProgress.add(FlSpot(entryCount.toDouble(), steps.toDouble()));
      entryCount++; // Increment for next entry
    });

    // Clear the text fields after submitting
    stepsController.clear();
    caloriesController.clear();
  }

  @override
  void dispose() {
    stepsController.dispose();
    caloriesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Fitness Tracker")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Steps input
            Text("Enter Steps:", style: GoogleFonts.roboto(fontSize: 18)),
            TextField(
              controller: stepsController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "e.g. 5000"),
            ),
            SizedBox(height: 10),

            // Calories input
            Text("Enter Calories Burned:", style: GoogleFonts.roboto(fontSize: 18)),
            TextField(
              controller: caloriesController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: "e.g. 220.5"),
            ),
            SizedBox(height: 10),

            // Update button
            ElevatedButton(
              onPressed: updateValues,
              child: Text("Update"),
            ),
            Divider(height: 30),

            // Display Steps and Calories Burned
            Text("Daily Steps:", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("$steps steps", style: GoogleFonts.lato(fontSize: 20)),
            SizedBox(height: 10),
            Text("Calories Burned:", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
            Text("$caloriesBurned kcal", style: GoogleFonts.lato(fontSize: 20)),
            SizedBox(height: 20),

            // Workout Progress Graph
            Text("Workout Progress:", style: GoogleFonts.roboto(fontSize: 22, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Expanded(
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: workoutProgress,
                      isCurved: true,
                      color: Colors.blue,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(show: false),
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
