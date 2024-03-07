import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ClimaPage extends StatefulWidget {
  @override
  _ClimaPageState createState() => _ClimaPageState();
}

class _ClimaPageState extends State<ClimaPage> {
  String? _clima;
  bool _isLoading = false;

  Future<void> _fetchClima() async {
    setState(() {
      _isLoading = true;
    });

    final apiKey = '7f30e99cfacf276056706781bc1637e0'; // Key_Api generada en OpenWeatherMap
    final ciudad = 'Santo Domingo'; // Ciudad para obtener el clima

    final url = 'https://api.openweathermap.org/data/2.5/weather?q=$ciudad&appid=$apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final temp = data['main']['temp'];
        final weatherDescription = data['weather'][0]['description'];

        setState(() {
          _clima = 'Temperatura: $temp°C, $weatherDescription';
        });
      } else {
        setState(() {
          _clima = 'Error al obtener el clima: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _clima = 'Error al obtener el clima: $e';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Clima en República Dominicana'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                _fetchClima();
              },
              child: Text(
                'Obtener Clima',
                style: TextStyle(fontSize: 18),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : Text(
                    _clima ?? '',
                    style: TextStyle(fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
          ],
        ),
      ),
    );
  }
}
