import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
runApp(MyCalendarApp());
}

class MyCalendarApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return MaterialApp(
title: 'Calendário',
debugShowCheckedModeBanner: false,
home: CalendarPage(),
);
}
}

class CalendarPage extends StatelessWidget {
final List<String> weekDays = ['D', 'S', 'T', 'Q', 'Q', 'S', 'S'];
final List<List<String>> calendar = [
[' ', ' ', ' ', '', '1', '2'],
['3', '4', '5', '6', '7', '8', '9'],
['10', '11', '12', '13', '14', '15', '16'],
['17', '18', '19', '20', '21', '22', '23'],
['24', '25', '26', '27', '28', '29', '30'],
['31', '', '', '', '', '', '']
];

Widget buildDayCell(String day, {bool isToday = false}) {
return Container(
alignment: Alignment.center,
margin: EdgeInsets.all(4),
width: 32,
height: 32,
decoration: isToday
? BoxDecoration(
color: Colors.pink,
borderRadius: BorderRadius.circular(8),
)
: null,
child: Text(
day,
style: TextStyle(
color: Colors.white,
fontWeight: FontWeight.bold,
),
),
);
}

Widget buildColoredBar(Color color) {
return Container(
margin: EdgeInsets.only(top: 2),
height: 4,
width: 20,
decoration: BoxDecoration(
color: color,
borderRadius: BorderRadius.circular(2),
),
);
}

@override
Widget build(BuildContext context) {
return Scaffold(
backgroundColor: Colors.black,
body: SafeArea(
child: Column(
children: [
SizedBox(height: 24),
Text(
'February',
style: TextStyle(
color: Colors.pink,
fontSize: 32,
fontWeight: FontWeight.bold,
),
),
SizedBox(height: 16),
Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: weekDays.map((d) {
return Text(
d,
style: TextStyle(color: Colors.white),
);
}).toList(),
),
SizedBox(height: 8),
...calendar.map((week) {
return Row(
mainAxisAlignment: MainAxisAlignment.spaceEvenly,
children: week.map((day) {
bool isToday = day == '3';
return Column(
children: [
buildDayCell(day, isToday: isToday),
if (day != ' ' && day != '')
buildColoredBar(_getBarColor(day)),
],
);
}).toList(),
);
}).toList(),
Spacer(),
Padding(
padding: const EdgeInsets.only(bottom: 16.0),
child: Row(
mainAxisAlignment: MainAxisAlignment.spaceAround,
children: [
IconButton(
icon: Icon(Icons.home, color: Colors.pink),
onPressed: () {
Navigator.pushReplacement(
context,
MaterialPageRoute(builder: (context) => CalendarPage()),
);
},
),
IconButton(
icon: Icon(Icons.water_drop, color: Colors.pink),
onPressed: () {

},
),
IconButton(
icon: Icon(Icons.person, color: Colors.pink),
onPressed: () {

},
),
],
),
),
],
),
),
);
}

Color _getBarColor(String day) {
int num = int.tryParse(day) ?? 0;
if ([12, 19, 26].contains(num)) {
return Colors.pink;
} else if ([11, 13, 20, 22, 27, 29].contains(num)) {
return Color(0xFFB69CF3); 
} else if ([17, 31].contains(num)) {
return Colors.blueAccent;
} else if ([16, 23, 30].contains(num)) {
return Colors.pink.shade300;
}
return Colors.transparent;
}
}