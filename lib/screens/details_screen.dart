/// Pantalla de detalles para mostrar la información de un Pokémon específico.
import 'package:flutter/material.dart';
import 'package:pokemon_app/widgets/pokemon_details.dart';

class DetailsScreen extends StatelessWidget {
  final dynamic pokemon;

  /// Constructor que recibe un Pokémon específico.
  DetailsScreen({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(pokemon['name']),
      ),
      body: PokemonDetails(pokemonName: pokemon['name']),
    );
  }
}

