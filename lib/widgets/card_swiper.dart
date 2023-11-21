import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
/// Widget que muestra un carrusel de Pokémon.
import 'package:pokemon_app/screens/details_screen.dart';

class CardSwiper extends StatelessWidget {
  final List<dynamic> pokemonList;
 /// Constructor que recibe una lista de Pokémon.
  CardSwiper({required this.pokemonList});

/// Método privado para obtener la imagen de un Pokémon desde la API.
  Future<String> _fetchPokemonImage(String pokemonName) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/${pokemonName.toLowerCase()}'));
    if (response.statusCode == 200) {
      final pokemonDetails = json.decode(response.body);
      return pokemonDetails['sprites']['front_default'] ?? '';
    } else {
      throw Exception('Failed to load Pokémon image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pokemonList.length,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsScreen(
                        pokemon: pokemonList[index],
                      ),
                    ),
                  );
                },
                child: Card(
                  child: FutureBuilder(
                    future: _fetchPokemonImage(pokemonList[index]['name']),
                    builder: (context, AsyncSnapshot<String> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return CircularProgressIndicator();
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        final pokemonImage = snapshot.data;
                        return Image.network(pokemonImage ?? '', height: 250, width: 250);
                      }
                    },
                  ),
                ),
              ),
              Text(pokemonList[index]['name']),
            ],
          );
        },
      ),
    );
  }
}
