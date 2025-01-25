import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  late List<Model> data;
  late MapShapeSource dataSource;

  // List of all countries
  final List<String> allCountries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'American Samoa',
    'Andorra',
    'Angola',
    'Anguilla',
    'Antarctica',
    'Antigua and Barb.',
    'Argentina',
    'Armenia',
    'Aruba',
    'Ashmore and Cartier Is.',
    'Australia',
    'Austria',
    'Azerbaijan',
    'Bahamas',
    'Bahrain',
    'Bangladesh',
    'Barbados',
    'Belarus',
    'Belgium',
    'Belize',
    'Benin',
    'Bermuda',
    'Bhutan',
    'Bolivia',
    'Bosnia and Herz.',
    'Botswana',
    'Br. Indian Ocean Ter.',
    'Brazil',
    'British Virgin Is.',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    'Cabo Verde',
    'Cambodia',
    'Cameroon',
    'Canada',
    'Cayman Is.',
    'Central African Rep.',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo',
    'Cook Is.',
    'Costa Rica',
    'Croatia',
    'Cuba',
    'Curaçao',
    'Cyprus',
    'Czechia',
    'Côte d\'Ivoire',
    'Dem. Rep. Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Rep.',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Eq. Guinea',
    'Eritrea',
    'Estonia',
    'Ethiopia',
    'Faeroe Is.',
    'Falkland Is.',
    'Fiji',
    'Finland',
    'Fr. Polynesia',
    'Fr. S. Antarctic Lands',
    'France',
    'Gabon',
    'Gambia',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Greenland',
    'Grenada',
    'Guam',
    'Guatemala',
    'Guernsey',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Heard I. and McDonald Is.',
    'Honduras',
    'Hong Kong',
    'Hungary',
    'Iceland',
    'India',
    'Indian Ocean Ter.',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Isle of Man',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jersey',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kosovo',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Macao',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Is.',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Montserrat',
    'Morocco',
    'Mozambique',
    'Myanmar',
    'N. Cyprus',
    'N. Mariana Is.',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Caledonia',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'Niue',
    'Norfolk Island',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Pitcairn Is.',
    'Poland',
    'Portugal',
    'Puerto Rico',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'S. Geo. and the Is.',
    'S. Sudan',
    'Saint Helena',
    'Saint Lucia',
    'Samoa',
    'San Marino',
    'Saudi Arabia',
    'Senegal',
    'Serbia',
    'Seychelles',
    'Siachen Glacier',
    'Sierra Leone',
    'Singapore',
    'Sint Maarten',
    'Slovakia',
    'Slovenia',
    'Solomon Is.',
    'Somalia',
    'Somaliland',
    'South Africa',
    'South Korea',
    'Spain',
    'Sri Lanka',
    'St-Barthélemy',
    'St-Martin',
    'St. Kitts and Nevis',
    'St. Pierre and Miquelon',
    'St. Vin. and Gren.',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'São Tomé and Principe',
    'Taiwan',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Turks and Caicos Is.',
    'Tuvalu',
    'U.S. Virgin Is.',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States of America',
    'Uruguay',
    'Uzbekistan',
    'Vanuatu',
    'Vatican',
    'Venezuela',
    'Vietnam',
    'W. Sahara',
    'Wallis and Futuna Is.',
    'Yemen',
    'Zambia',
    'Zimbabwe',
    'eSwatini',
    'Åland'
  ];

  // Set of visited countries
  final Set<String> visitedCountries = {
    'India',
    'United States of America',
    'Pakistan',
    'Germany',
    'China',
    'France',
    'Ukraine',
    'Tuvalu',
    'Saudi Arabia',
    'Fiji',
    'Turks and Caicos Is.',
    'Heard I. and McDonald Is.',
    'Taiwan',
    'eSwatini',
    'Åland'
  };

  @override
  void initState() {
    super.initState();
    _initializeMapData();
  }

  void _initializeMapData() {
    // Populate the `data` list
    data = allCountries
        .map((country) => Model(
              country,
              visitedCountries.contains(country) ? 'High' : 'Not Visited',
            ))
        .toList();

    // Initialize `MapShapeSource`
    dataSource = MapShapeSource.asset(
      "assets/world_map.json",
      shapeDataField: "name", // Match with the GeoJSON file
      dataCount: data.length,
      primaryValueMapper: (int index) {
        return data[index].country;
      },
      shapeColorValueMapper: (int index) {
        return data[index].storage;
      },
      shapeColorMappers: [
        MapColorMapper(value: "High", color: Colors.green.shade800),
        MapColorMapper(value: "Not Visited", color: Colors.grey.shade300),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          InteractiveViewer(
            boundaryMargin: const EdgeInsets.all(8.0),
            minScale: 0.3,
            maxScale: 5.0,
            child: SfMaps(
              layers: <MapShapeLayer>[
                MapShapeLayer(
                  source: dataSource,
                  legend: const MapLegend(MapElement.shape),
                  strokeWidth: 0.1, // Adjust the border width here
                  strokeColor: Colors.black38,
                  onSelectionChanged: (int index) {
                    final String countryName = data[index].country;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('You clicked on: $countryName'),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Model {
  const Model(this.country, this.storage);

  final String country;
  final String storage;
}
