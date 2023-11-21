import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
/// Widget que muestra detalles de un Pokémon, incluyendo su imagen y descripción Pokedex.
class PokemonDetails extends StatefulWidget {
  final String pokemonName;
/// Constructor que recibe el nombre de un Pokémon.
  PokemonDetails({required this.pokemonName});

  @override
  _PokemonDetailsState createState() => _PokemonDetailsState();
}

class _PokemonDetailsState extends State<PokemonDetails> {
  late Future<Map<String, dynamic>> _pokemonDetails;

  @override
  void initState() {
    super.initState();
    _pokemonDetails = _fetchPokemonDetails();
  }
/// Método privado para obtener detalles de un Pokémon desde la API.
  Future<Map<String, dynamic>> _fetchPokemonDetails() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${widget.pokemonName.toLowerCase()}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }
/// Método privado para obtener detalles de la especie de un Pokémon desde la API.
  Future<Map<String, dynamic>> _fetchPokemonSpecies() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon-species/${widget.pokemonName.toLowerCase()}'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load Pokémon species details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([_pokemonDetails, _fetchPokemonSpecies()]),
      builder: (context, AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final pokemonDetails = snapshot.data![0];
          final speciesDetails = snapshot.data![1];

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.network(pokemonDetails['sprites']['front_default'] ?? ''), // Utilitza la URL de la imatge del Pokémon
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Tipus: ${pokemonDetails['types'].map((type) => type['type']['name']).join(', ')}',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Descripció Pokedex: ${speciesDetails['flavor_text_entries'][0]['flavor_text']}', // Utilitza la descripció real
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
