/// Pantalla principal que muestra un carrusel de Pokémon y una lista de tipos.
import 'package:flutter/material.dart';
import 'package:pokemon_app/widgets/card_swiper.dart';
import 'package:pokemon_app/widgets/types_list.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> pokemonList = [
    {'name': 'Staraptor'},
    {'name': 'Infernape'},
    {'name': 'Decidueye'},
    {'name': 'Zangoose'},
    {'name': 'Pidgeot'},
    {'name': 'Charizard'},
    {'name': 'Pidgey'}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokémon App'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Slider de Pokémon
            CardSwiper(pokemonList: pokemonList),

            // Llista de Tipos
            TypeList(),
          ],
        ),
      ),
    );
  }
}
