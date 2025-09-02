import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flag/flag.dart';

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
  late MapZoomPanBehavior _zoomPanBehavior;
  Position? _currentPosition;
  bool _isLoadingLocation = true;

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
  Set<String> visitedCountries = {
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
    'Åland',
    'Canada'
  };

  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      enablePinching: true,
      maxZoomLevel: 15,
      minZoomLevel: 2,
      // Set initial location to Cupertino, CA
      focalLatLng: const MapLatLng(37.3230, -122.0322),
      zoomLevel: 8,
    );
    _initializeMapData();
    _getCurrentLocation();
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
        MapColorMapper(value: "High", color: Colors.green.shade400),
        MapColorMapper(value: "Not Visited", color: Colors.grey.shade400),
      ],
    );
  }

  void _checkInToCountry(String countryName) {
    setState(() {
      visitedCountries.add(countryName);
      // Update the data model
      final index = data.indexWhere((model) => model.country == countryName);
      if (index != -1) {
        data[index] = Model(countryName, 'High');
      }
      // Reinitialize the data source to reflect changes
      _initializeMapData();
    });
  }

  String _getCountryCode(String countryName) {
    // Map country names to ISO 3166-1 alpha-2 codes for flag display
    final Map<String, String> countryCodeMap = {
      'Afghanistan': 'AF',
      'Albania': 'AL',
      'Algeria': 'DZ',
      'American Samoa': 'AS',
      'Andorra': 'AD',
      'Angola': 'AO',
      'Anguilla': 'AI',
      'Antarctica': 'AQ',
      'Antigua and Barb.': 'AG',
      'Argentina': 'AR',
      'Armenia': 'AM',
      'Aruba': 'AW',
      'Australia': 'AU',
      'Austria': 'AT',
      'Azerbaijan': 'AZ',
      'Bahamas': 'BS',
      'Bahrain': 'BH',
      'Bangladesh': 'BD',
      'Barbados': 'BB',
      'Belarus': 'BY',
      'Belgium': 'BE',
      'Belize': 'BZ',
      'Benin': 'BJ',
      'Bermuda': 'BM',
      'Bhutan': 'BT',
      'Bolivia': 'BO',
      'Bosnia and Herz.': 'BA',
      'Botswana': 'BW',
      'Brazil': 'BR',
      'British Virgin Is.': 'VG',
      'Brunei': 'BN',
      'Bulgaria': 'BG',
      'Burkina Faso': 'BF',
      'Burundi': 'BI',
      'Cabo Verde': 'CV',
      'Cambodia': 'KH',
      'Cameroon': 'CM',
      'Canada': 'CA',
      'Cayman Is.': 'KY',
      'Central African Rep.': 'CF',
      'Chad': 'TD',
      'Chile': 'CL',
      'China': 'CN',
      'Colombia': 'CO',
      'Comoros': 'KM',
      'Congo': 'CG',
      'Cook Is.': 'CK',
      'Costa Rica': 'CR',
      'Croatia': 'HR',
      'Cuba': 'CU',
      'Curaçao': 'CW',
      'Cyprus': 'CY',
      'Czechia': 'CZ',
      'Côte d\'Ivoire': 'CI',
      'Dem. Rep. Congo': 'CD',
      'Denmark': 'DK',
      'Djibouti': 'DJ',
      'Dominica': 'DM',
      'Dominican Rep.': 'DO',
      'Ecuador': 'EC',
      'Egypt': 'EG',
      'El Salvador': 'SV',
      'Eq. Guinea': 'GQ',
      'Eritrea': 'ER',
      'Estonia': 'EE',
      'Ethiopia': 'ET',
      'Faeroe Is.': 'FO',
      'Falkland Is.': 'FK',
      'Fiji': 'FJ',
      'Finland': 'FI',
      'Fr. Polynesia': 'PF',
      'France': 'FR',
      'Gabon': 'GA',
      'Gambia': 'GM',
      'Georgia': 'GE',
      'Germany': 'DE',
      'Ghana': 'GH',
      'Greece': 'GR',
      'Greenland': 'GL',
      'Grenada': 'GD',
      'Guam': 'GU',
      'Guatemala': 'GT',
      'Guernsey': 'GG',
      'Guinea': 'GN',
      'Guinea-Bissau': 'GW',
      'Guyana': 'GY',
      'Haiti': 'HT',
      'Honduras': 'HN',
      'Hong Kong': 'HK',
      'Hungary': 'HU',
      'Iceland': 'IS',
      'India': 'IN',
      'Indonesia': 'ID',
      'Iran': 'IR',
      'Iraq': 'IQ',
      'Ireland': 'IE',
      'Isle of Man': 'IM',
      'Israel': 'IL',
      'Italy': 'IT',
      'Jamaica': 'JM',
      'Japan': 'JP',
      'Jersey': 'JE',
      'Jordan': 'JO',
      'Kazakhstan': 'KZ',
      'Kenya': 'KE',
      'Kiribati': 'KI',
      'Kosovo': 'XK',
      'Kuwait': 'KW',
      'Kyrgyzstan': 'KG',
      'Laos': 'LA',
      'Latvia': 'LV',
      'Lebanon': 'LB',
      'Lesotho': 'LS',
      'Liberia': 'LR',
      'Libya': 'LY',
      'Liechtenstein': 'LI',
      'Lithuania': 'LT',
      'Luxembourg': 'LU',
      'Macao': 'MO',
      'Madagascar': 'MG',
      'Malawi': 'MW',
      'Malaysia': 'MY',
      'Maldives': 'MV',
      'Mali': 'ML',
      'Malta': 'MT',
      'Marshall Is.': 'MH',
      'Mauritania': 'MR',
      'Mauritius': 'MU',
      'Mexico': 'MX',
      'Micronesia': 'FM',
      'Moldova': 'MD',
      'Monaco': 'MC',
      'Mongolia': 'MN',
      'Montenegro': 'ME',
      'Montserrat': 'MS',
      'Morocco': 'MA',
      'Mozambique': 'MZ',
      'Myanmar': 'MM',
      'N. Cyprus': 'CY',
      'N. Mariana Is.': 'MP',
      'Namibia': 'NA',
      'Nauru': 'NR',
      'Nepal': 'NP',
      'Netherlands': 'NL',
      'New Caledonia': 'NC',
      'New Zealand': 'NZ',
      'Nicaragua': 'NI',
      'Niger': 'NE',
      'Nigeria': 'NG',
      'Niue': 'NU',
      'Norfolk Island': 'NF',
      'North Korea': 'KP',
      'North Macedonia': 'MK',
      'Norway': 'NO',
      'Oman': 'OM',
      'Pakistan': 'PK',
      'Palau': 'PW',
      'Palestine': 'PS',
      'Panama': 'PA',
      'Papua New Guinea': 'PG',
      'Paraguay': 'PY',
      'Peru': 'PE',
      'Philippines': 'PH',
      'Pitcairn Is.': 'PN',
      'Poland': 'PL',
      'Portugal': 'PT',
      'Puerto Rico': 'PR',
      'Qatar': 'QA',
      'Romania': 'RO',
      'Russia': 'RU',
      'Rwanda': 'RW',
      'S. Sudan': 'SS',
      'Saint Helena': 'SH',
      'Saint Lucia': 'LC',
      'Samoa': 'WS',
      'San Marino': 'SM',
      'Saudi Arabia': 'SA',
      'Senegal': 'SN',
      'Serbia': 'RS',
      'Seychelles': 'SC',
      'Sierra Leone': 'SL',
      'Singapore': 'SG',
      'Sint Maarten': 'SX',
      'Slovakia': 'SK',
      'Slovenia': 'SI',
      'Solomon Is.': 'SB',
      'Somalia': 'SO',
      'South Africa': 'ZA',
      'South Korea': 'KR',
      'Spain': 'ES',
      'Sri Lanka': 'LK',
      'St-Barthélemy': 'BL',
      'St-Martin': 'MF',
      'St. Kitts and Nevis': 'KN',
      'St. Pierre and Miquelon': 'PM',
      'St. Vin. and Gren.': 'VC',
      'Sudan': 'SD',
      'Suriname': 'SR',
      'Sweden': 'SE',
      'Switzerland': 'CH',
      'Syria': 'SY',
      'São Tomé and Principe': 'ST',
      'Taiwan': 'TW',
      'Tajikistan': 'TJ',
      'Tanzania': 'TZ',
      'Thailand': 'TH',
      'Timor-Leste': 'TL',
      'Togo': 'TG',
      'Tonga': 'TO',
      'Trinidad and Tobago': 'TT',
      'Tunisia': 'TN',
      'Turkey': 'TR',
      'Turkmenistan': 'TM',
      'Turks and Caicos Is.': 'TC',
      'Tuvalu': 'TV',
      'U.S. Virgin Is.': 'VI',
      'Uganda': 'UG',
      'Ukraine': 'UA',
      'United Arab Emirates': 'AE',
      'United Kingdom': 'GB',
      'United States of America': 'US',
      'Uruguay': 'UY',
      'Uzbekistan': 'UZ',
      'Vanuatu': 'VU',
      'Vatican': 'VA',
      'Venezuela': 'VE',
      'Vietnam': 'VN',
      'W. Sahara': 'EH',
      'Wallis and Futuna Is.': 'WF',
      'Yemen': 'YE',
      'Zambia': 'ZM',
      'Zimbabwe': 'ZW',
      'eSwatini': 'SZ',
      'Åland': 'AX'
    };

    return countryCodeMap[countryName] ??
        'UN'; // Default to UN flag if not found
  }

  void _showCountryDialog(String countryName) {
    final bool isVisited = visitedCountries.contains(countryName);
    final String countryCode = _getCountryCode(countryName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flag.fromString(
                countryCode,
                height: 24,
                width: 36,
              ),
              const SizedBox(width: 12),
              Flexible(child: Text(countryName)),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isVisited ? Icons.check_circle : Icons.location_on,
                size: 48,
                color: isVisited ? Colors.green : Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                isVisited
                    ? 'You have visited this country!'
                    : 'You haven\'t visited this country yet.',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close', style: TextStyle(color: Colors.black)),
            ),
            if (!isVisited)
              ElevatedButton(
                onPressed: () {
                  _checkInToCountry(countryName);
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('✅ Checked in to $countryName!'),
                      backgroundColor: Colors.green.shade700,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Check In'),
              ),
          ],
        );
      },
    );
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _isLoadingLocation = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _isLoadingLocation = false;
        });
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _currentPosition = position;
        _isLoadingLocation = false;
      });

      // Zoom to current location
      if (_currentPosition != null) {
        _zoomPanBehavior.focalLatLng = MapLatLng(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
        );
        _zoomPanBehavior.zoomLevel = 8;
      }
    } catch (e) {
      setState(() {
        _isLoadingLocation = false;
      });
      if (kDebugMode) {
        print('Error getting location: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoadingLocation
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Getting your location...'),
                ],
              ),
            )
          : Stack(
              children: [
                Container(
                  color: Colors.blue.shade400,
                  child: SfMaps(
                    layers: <MapShapeLayer>[
                      MapShapeLayer(
                        source: dataSource,
                        strokeWidth: 0.5,
                        strokeColor: Colors.black87,
                        zoomPanBehavior: _zoomPanBehavior,
                        color: Colors.grey.shade200,
                        onSelectionChanged: (int index) {
                          final String countryName = data[index].country;
                          _showCountryDialog(countryName);
                        },
                      ),
                    ],
                  ),
                ),
                // Transparent legend overlay at bottom
                Positioned(
                  bottom: 20,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.green.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Visited',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade400,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Not Visited',
                          style: TextStyle(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                // Zoom controls overlay at bottom right
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _zoomPanBehavior.zoomLevel =
                                  (_zoomPanBehavior.zoomLevel + 1)
                                      .clamp(2.0, 15.0);
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.white, size: 16),
                          tooltip: 'Zoom In',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () {
                            setState(() {
                              _zoomPanBehavior.zoomLevel =
                                  (_zoomPanBehavior.zoomLevel - 1)
                                      .clamp(2.0, 15.0);
                            });
                          },
                          icon: const Icon(Icons.remove, color: Colors.white, size: 16),
                          tooltip: 'Zoom Out',
                        ),
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
