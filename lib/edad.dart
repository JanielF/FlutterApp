import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EdadPage extends StatefulWidget {
  @override
  _EdadPageState createState() => _EdadPageState();
}

class _EdadPageState extends State<EdadPage> {
  TextEditingController _nameController = TextEditingController();
  int _age = -1; // Inicializamos _age con un valor predeterminado
  String _message = ''; // Inicializamos _message con un valor predeterminado
  bool _isLoading = false;

  Future<void> _predictAge() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.agify.io/?name=${_nameController.text}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _age = data['age'];
        _message = _getMessageFromAge(_age); // Obtener el mensaje basado en la edad
      });
    } else {
      // Manejo de error si la solicitud falla
      setState(() {
        _age = -1; // Establecemos _age como -1 en caso de error
        _message = ''; // Establecemos _message como vacío en caso de error
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  String _getMessageFromAge(int age) {
    if (age < 18) {
      return 'Joven';
    } else if (age >= 18 && age < 60) {
      return 'Adulto';
    } else {
      return 'Anciano';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Determinar Edad'),
      ),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ingrese su nombre:'),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Nombre',
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      _predictAge();
                    },
                    child: Text('Predecir Edad'),
                  ),
                  SizedBox(height: 20),
                  _age != -1
                      ? Column(
                          children: [
                            Text('Edad: $_age años'),
                            SizedBox(height: 10),
                            Text('Estado: $_message'),
                            SizedBox(height: 20),
                            _buildImageForAge(_age), // Mostrar imagen según la edad
                          ],
                        )
                      : SizedBox(),
                ],
              ),
      ),
    );
  }

  Widget _buildImageForAge(int age) {
    String imagePath;
    if (age < 18) {
      imagePath = 'assets/Joven.webp';
    } else if (age >= 18 && age < 60) {
      imagePath = 'assets/adulto.webp';
    } else {
      imagePath = 'assets/Viejo.webp';
    }

    return Image.asset(
      imagePath,
      width: 200,
      height: 200,
      fit: BoxFit.cover,
    );
  }
}