import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(CalorieBurnCalculatorApp());
}

class CalorieBurnCalculatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: CalorieBurnCalculatorScreen(),
    );
  }
}

class CalorieBurnCalculatorScreen extends StatefulWidget {
  @override
  _CalorieBurnCalculatorScreenState createState() =>
      _CalorieBurnCalculatorScreenState();
}

class _CalorieBurnCalculatorScreenState
    extends State<CalorieBurnCalculatorScreen> {
  final weightController = TextEditingController(text: "60");
  final durationController = TextEditingController(text: "30");

  String selectedActivity = 'Running';
  double caloriesBurned = 0.0;

  final Map<String, double> activityMETs = {
    'Running': 8.0,
    'Walking': 3.5,
    'Cycling': 6.0,
    'Swimming': 7.0,
  };

  void calculateCalories() {
    final double? weight = double.tryParse(weightController.text);
    final double? duration = double.tryParse(durationController.text);

    if (weight == null || duration == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid numbers.')),
      );
      return;
    }

    double metValue = activityMETs[selectedActivity] ?? 3.5;

    setState(() {
      caloriesBurned = (metValue * 3.5 * weight / 200) * duration;
    });
  }

  @override
  void dispose() {
    weightController.dispose();
    durationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calorie Burn Calculator")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Text("Enter your weight (kg):",
                style: GoogleFonts.poppins(fontSize: 18)),
            TextFormField(
              controller: weightController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "e.g. 60",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            Text("Select Activity Type:",
                style: GoogleFonts.poppins(fontSize: 18)),
            DropdownButton<String>(
              value: selectedActivity,
              isExpanded: true,
              items: activityMETs.keys.map((activity) {
                return DropdownMenuItem(
                    value: activity, child: Text(activity));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value!;
                });
              },
            ),
            SizedBox(height: 16),
            Text("Enter duration (minutes):",
                style: GoogleFonts.poppins(fontSize: 18)),
            TextFormField(
              controller: durationController,
              keyboardType: TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                hintText: "e.g. 30",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: calculateCalories,
              child: Text("Calculate"),
            ),
            SizedBox(height: 20),
            Text(
              "Calories Burned: ${caloriesBurned.toStringAsFixed(2)} kcal",
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
