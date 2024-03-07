import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class UniversidadesPage extends StatefulWidget {
  @override
  _UniversidadesPageState createState() => _UniversidadesPageState();
}

class Universidad {
  final String nombre;
  final String dominio;
  final String paginaWeb;

  Universidad({
    required this.nombre,
    required this.dominio,
    required this.paginaWeb,
  });

  factory Universidad.fromJson(Map<String, dynamic> json) {
    return Universidad(
      nombre: json['name'] ?? '',
      dominio: json['domains'] != null && json['domains'].isNotEmpty
          ? json['domains'][0]
          : '',
      paginaWeb: json['web_pages'] != null && json['web_pages'].isNotEmpty
          ? json['web_pages'][0]
          : '',
    );
  }
}

class _UniversidadesPageState extends State<UniversidadesPage> {
  TextEditingController _countryController = TextEditingController();
  List<Universidad> _universidades = [];
  bool _isLoading = false;

  Future<void> _fetchUniversidades(String country) async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(
      Uri.parse('http://universities.hipolabs.com/search?country=$country'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      final List<Universidad> universidades = data
          .map((json) => Universidad.fromJson(json))
          .take(15) // Limita la cantidad de universidades a 15
          .toList();

      setState(() {
        _universidades = universidades;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'No se pudo abrir $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Universidades por País'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _countryController,
                decoration: InputDecoration(
                  labelText: 'País (en inglés)',
                  hintText: 'Ingresa el nombre del país',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  _fetchUniversidades(_countryController.text.trim());
                },
                child: Text('Buscar Universidades'),
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: _universidades
                          .map(
                            (universidad) => Card(
                              margin: EdgeInsets.symmetric(vertical: 8),
                              child: ListTile(
                                title: Text(universidad.nombre),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Dominio: ${universidad.dominio}'),
                                    TextButton(
                                      onPressed: () {
                                        _launchURL(universidad.paginaWeb);
                                      },
                                      child: Text(
                                        'Página Web',
                                        style: TextStyle(color: Colors.blue),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}