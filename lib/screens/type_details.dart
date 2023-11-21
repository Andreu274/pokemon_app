import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
/// Pantalla que muestra detalles sobre un tipo de Pokémon específico.
class TypeDetails extends StatefulWidget {
  final String typeName;

/// Constructor que recibe el nombre del tipo de Pokémon.
  TypeDetails({required this.typeName});

  @override
  _TypeDetailsState createState() => _TypeDetailsState();
}

class _TypeDetailsState extends State<TypeDetails> {
  late Future<Map<String, dynamic>> _fetchTypeDetails;

  @override
  void initState() {
    super.initState();
    _fetchTypeDetails = _fetchDetails();
  }
/// Método privado para obtener los detalles del tipo de Pokémon desde la API.
  Future<Map<String, dynamic>> _fetchDetails() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/type/${widget.typeName}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load type details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.typeName),
      ),
      body: FutureBuilder(
        future: _fetchTypeDetails,
        builder: (context, AsyncSnapshot<Map<String, dynamic>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            final typeDetails = snapshot.data;
            final int damageMultiplier = typeDetails!['damage_relations']['double_damage_to'].length;

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Informació detallada del tipus ${widget.typeName}:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Double damage to: ${typeDetails['damage_relations']['double_damage_to'].map((type) => type['name']).join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Half damage to: ${typeDetails['damage_relations']['half_damage_to'].map((type) => type['name']).join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No damage to: ${typeDetails['damage_relations']['no_damage_to'].map((type) => type['name']).join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Double damage from: ${typeDetails['damage_relations']['double_damage_from'].map((type) => type['name']).join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Half damage from: ${typeDetails['damage_relations']['half_damage_from'].map((type) => type['name']).join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'No damage from: ${typeDetails['damage_relations']['no_damage_from'].map((type) => type['name']).join(', ')}',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Strong against: $damageMultiplier types',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
