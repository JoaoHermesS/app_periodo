import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'symptom_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('pt_BR', null);
  runApp(AppCalendario());
}

class AppCalendario extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendário Menstrual',
      debugShowCheckedModeBanner: false,
      home: TelaCalendario(),
      theme: ThemeData.dark(),
    );
  }
}

class TelaCalendario extends StatefulWidget {
  @override
  _TelaCalendarioState createState() => _TelaCalendarioState();
}

class _TelaCalendarioState extends State<TelaCalendario> {
  DateTime _diaEmFoco = DateTime.now();
  final Set<DateTime> _diasMenstruada = {};
  final Map<DateTime, Map<String, dynamic>> _sintomasPorDia = {};

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  DateTime _normalizarData(DateTime dia) =>
      DateTime(dia.year, dia.month, dia.day);

  String _nomeDoMes(int mes) {
    const meses = [
      'Janeiro',
      'Fevereiro',
      'Março',
      'Abril',
      'Maio',
      'Junho',
      'Julho',
      'Agosto',
      'Setembro',
      'Outubro',
      'Novembro',
      'Dezembro',
    ];
    return meses[mes - 1];
  }

  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final diasStr = _diasMenstruada.map((d) => d.toIso8601String()).toList();
    final sintomasStr = _sintomasPorDia.map(
      (key, value) => MapEntry(key.toIso8601String(), jsonEncode(value)),
    );

    await prefs.setStringList('diasMenstruada', diasStr);
    await prefs.setString('sintomasPorDia', jsonEncode(sintomasStr));
  }

  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    final diasSalvos = prefs.getStringList('diasMenstruada');
    final sintomasStr = prefs.getString('sintomasPorDia');

    if (diasSalvos != null) {
      setState(() {
        _diasMenstruada.clear();
        _diasMenstruada.addAll(diasSalvos.map((s) => DateTime.parse(s)));
      });
    }

    if (sintomasStr != null) {
      final Map<String, dynamic> mapa =
          jsonDecode(sintomasStr) as Map<String, dynamic>;

      setState(() {
        _sintomasPorDia.clear();
        mapa.forEach((k, v) {
          _sintomasPorDia[DateTime.parse(k)] = jsonDecode(v);
        });
      });
    }
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
              _nomeDoMes(_diaEmFoco.month),
              style: TextStyle(
                color: Colors.pink,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            TableCalendar(
              locale: 'pt_BR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _diaEmFoco,
              calendarFormat: CalendarFormat.month,
              headerVisible: false,
              daysOfWeekStyle: DaysOfWeekStyle(
                weekendStyle: TextStyle(color: Colors.white),
                weekdayStyle: TextStyle(color: Colors.white),
              ),
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                defaultTextStyle: TextStyle(color: Colors.white),
                weekendTextStyle: TextStyle(color: Colors.white),
              ),
              onDaySelected: (diaSelecionado, diaFocado) async {
                setState(() => _diaEmFoco = diaFocado);

                final dataNormalizada = _normalizarData(diaSelecionado);
                final sintomasSalvos = _sintomasPorDia[dataNormalizada];

                final resultado = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => TelaSintomas(
                          diaSelecionado: diaSelecionado,
                          dadosIniciais: sintomasSalvos,
                        ),
                  ),
                );

                if (resultado != null) {
                  if (resultado == 'remover') {
                    setState(() {
                      _diasMenstruada.remove(dataNormalizada);
                      _sintomasPorDia.remove(dataNormalizada);
                    });
                  } else {
                    setState(() {
                      _diasMenstruada.add(dataNormalizada);
                      _sintomasPorDia[dataNormalizada] = resultado;
                    });
                  }
                  _salvarDados();
                }
              },
              calendarBuilders: CalendarBuilders(
                defaultBuilder: (context, dia, _) {
                  final data = _normalizarData(dia);
                  final menstruada = _diasMenstruada.contains(data);

                  return Container(
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: menstruada ? Colors.pink : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${dia.day}',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
                todayBuilder: (context, dia, _) {
                  final data = _normalizarData(dia);
                  final menstruada = _diasMenstruada.contains(data);

                  return Container(
                    margin: EdgeInsets.all(4),
                    alignment: Alignment.center,
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: menstruada ? Colors.pink.shade700 : Colors.pink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${dia.day}',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Icon(Icons.home, color: Colors.pink),
                  Icon(Icons.water_drop, color: Colors.pink),
                  Icon(Icons.person, color: Colors.pink),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
