import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_app/screens/type_details.dart';
import 'dart:convert';
/// Widget que muestra una lista de tipos de Pokémon con la capacidad de navegar a la pantalla de detalles del tipo.
class TypeList extends StatefulWidget {
  @override
  _TypeListState createState() => _TypeListState();
}

class _TypeListState extends State<TypeList> {
  late Future<List<String>> _fetchPokemonTypes;

  @override
  void initState() {
    super.initState();
    _fetchPokemonTypes = _fetchTypes();
  }

  Future<List<String>> _fetchTypes() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/type'));
    if (response.statusCode == 200) {
      final types = json.decode(response.body)['results'] as List<dynamic>;
      return types.map<String>((type) => type['name']).toList();
    } else {
      throw Exception('Failed to load Pokémon types');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _fetchPokemonTypes,
      builder: (context, AsyncSnapshot<List<String>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final types = snapshot.data;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Llista de Tipus:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Wrap(
                spacing: 8.0, // Espaiat entre els elements
                runSpacing: 8.0, // Espaiat entre les files
                children: types!.map((typeName) {
                  return ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TypeDetails(typeName: typeName),
                        ),
                      );
                    },
                    child: Text(typeName),
                  );
                }).toList(),
              ),
            ],
          );
        }
      },
    );
  }
}
