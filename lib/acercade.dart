import 'package:flutter/material.dart';

class AcercaDePage extends StatefulWidget {
  @override
  _AcercaDePageState createState() => _AcercaDePageState();
}
class _AcercaDePageState extends State<AcercaDePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Acerca de'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 100,
              backgroundImage: AssetImage('assets/Yo.jpeg'), // Reemplaza 'tu_foto.jpg' con el nombre de tu foto en la carpeta de activos
            ),
            SizedBox(height: 20),
            Text(
              'Janiel Flores Almanzar',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              'Correo electrónico: Janielfloresdo@gmail.com\nTeléfono: 829-785-7896',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}