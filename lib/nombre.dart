import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class NuevaPagina extends StatefulWidget {
  @override
  _NuevaPaginaState createState() => _NuevaPaginaState();
}

class _NuevaPaginaState extends State<NuevaPagina> {
  TextEditingController _nameController = TextEditingController();
  String _gender = ''; // Inicializamos _gender con un valor predeterminado
  bool _isLoading = false;

  Future<void> _predictGender() async {
    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse('https://api.genderize.io/?name=${_nameController.text}'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _gender = data['gender'];
      });
    } else {
      // Manejo de error si la solicitud falla
      setState(() {
        _gender = ''; // Establecemos _gender como vacío en caso de error
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
        title: Text('Predector de genero'),
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
                      _predictGender();
                    },
                    child: Text('Predecir Género'),
                  ),
                  SizedBox(height: 20),
                  _gender.isNotEmpty // Verificamos si _gender no está vacío
                      ? _gender.toLowerCase() == 'male'
                          ? Container(
                              width: 200,
                              height: 200,
                              color: Colors.blue,
                              child: Center(
                                child: Text(
                                  'Género: Masculino',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                          : Container(
                              width: 200,
                              height: 200,
                              color: Colors.pink,
                              child: Center(
                                child: Text(
                                  'Género: Femenino',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            )
                      : SizedBox(),
                ],
              ),
      ),
    );
  }
}