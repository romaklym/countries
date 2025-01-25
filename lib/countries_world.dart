// import 'package:countries_world_map/countries_world_map.dart';
// import 'package:countries_world_map/data/maps/world_map.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyHomePage());
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key});

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   // List of visited country codes
//   final List<String> visitedCountries = [
//     'uS', // United States
//     'uA', // Ukraine
//     'gB', // United Kingdom
//     'dE', // Germany
//     'cN',
//   ];

//   // Convert list of countries to SMapWorldColors
//   // Convert list of countries to SMapWorldColors
//   SMapWorldColors _getCountryColors() {
//     // Helper function to determine color for a country
//     Color getColorForCountry(String code) =>
//         visitedCountries.contains(code) ? Colors.green : Colors.grey;

//     // Create the SMapWorldColors with all supported countries
//     return SMapWorldColors(
//       uS: getColorForCountry('uS'),
//       uA: getColorForCountry('uA'),
//       gB: getColorForCountry('gB'),
//       dE: getColorForCountry('dE'),
//       cN: getColorForCountry('cN'),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           appBar: AppBar(
//               title: const Text('Countries World Map',
//                   style: TextStyle(color: Colors.white))),
//           body: SizedBox(
//               height: MediaQuery.of(context).size.height,
//               width: MediaQuery.of(context).size.width,
//               child: SimpleMap(
//                 instructions: SMapWorld.instructions,
//                 defaultColor: Colors.grey,
//                 colors: _getCountryColors().toMap(),
//                 callback: (id, name, tapDetails) {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('You tapped on: $name ($id)'),
//                       duration: const Duration(seconds: 2),
//                     ),
//                   );
//                 },
//               ))),
//     );
//   }
// }
