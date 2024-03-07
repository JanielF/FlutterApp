import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class WordPressPage extends StatefulWidget {
  @override
  _WordPressPageState createState() => _WordPressPageState();
}

class _WordPressPageState extends State<WordPressPage> {
  late List<dynamic> _newsList = [];
  final wordpressLogoUrl = 'assets/logo.webp'; // Ruta local de la imagen del logo de WordPress
  double _logoWidth = 550; // Ancho inicial de la imagen del logo
  double _logoHeight = 200; // Alto inicial de la imagen del logo

  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  Future<void> _fetchNews() async {
    final apiKey = '07ad18cdaa394bf086144c3843cea332'; // Reemplazar con tu propia API key de NewsAPI
    final url = 'https://newsapi.org/v2/top-headlines?sources=techcrunch&apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          _newsList = data['articles'].take(3).toList();
        });
      } else {
        print('Error al obtener las noticias: ${response.statusCode}');
      }
    } catch (e) {
      print('Error al obtener las noticias: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Noticias de WordPress'),
      ),
      body: _newsList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: _newsList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.symmetric(vertical: 20),
                    child: Image.asset(
                      wordpressLogoUrl, // Utiliza la ruta local de la imagen del logo de WordPress
                      width: _logoWidth, // Usa la variable _logoWidth como ancho
                      height: _logoHeight, // Usa la variable _logoHeight como alto
                      fit: BoxFit.cover,
                    ),
                  );
                }

                final newsItem = _newsList[index - 1];
                return ListTile(
                  title: Text(
                    newsItem['title'],
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    newsItem['description'] ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    launch(newsItem['url']);
                  },
                );
              },
            ),
    );
  }
}
