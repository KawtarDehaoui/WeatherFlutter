import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Weather extends StatefulWidget {
  const Weather({Key? key}) : super(key: key);

  @override
  _WeatherState createState() => _WeatherState();
}

class _WeatherState extends State<Weather> {
  String _city = 'Rabat';
  String _temp = '0';
  String _weatherDescription = 'Unknown';
  String _hum = '0';
  String _pressure = '0';
  String _country = 'MA';
  String _language = 'fr';
  String _weatherIcon = 'assets/sun.jpg';
  bool _isLoading = true;

  final String _apiKey = '064de5450d646439947ff36a7c2e81f9';

  @override
  void initState() {
    super.initState();
    fetchWeatherData();
  }

  Future<void> fetchWeatherData() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://api.openweathermap.org/data/2.5/weather?q=$_city&appid=$_apiKey&units=metric&lang=$_language'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        setState(() {
          _temp = data['main']['temp'].toString();
          _weatherDescription = data['weather'][0]['description'];
          _hum = data['main']['humidity'].toString();
          _pressure = data['main']['pressure'].toString();
          _country = data['sys']['country'].toString();
          _updateWeatherIcon(_weatherDescription);
          _isLoading = false;
        });
      } else {
        setState(() {
          _weatherDescription = 'Error retrieving data';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _weatherDescription = 'Network error';
        _isLoading = false;
      });
    }
  }

  void _updateWeatherIcon(String description) {
    description = description.toLowerCase();
    setState(() {
      if (description.contains('clear') || description.contains('ensoleillé')) {
        _weatherIcon = 'assets/sun.jpg';
      } else if (description.contains('cloud') || description.contains('nuage')) {
        _weatherIcon = 'assets/cloud.png';
      } else if (description.contains('rain') || description.contains('pluie')) {
        _weatherIcon = 'assets/rain.jpg';
      } else if (description.contains('storm') || description.contains('orage')) {
        _weatherIcon = 'assets/storm.jpg';
      } else if (description.contains('snow') || description.contains('neige')) {
        _weatherIcon = 'assets/snow.jpg';
      } else {
        _weatherIcon = 'assets/sun.jpg';
      }
    });
  }

  String translate(String key) {
    Map<String, Map<String, String>> translations = {
      'fr': {
        'temperature': 'Température',
        'humidity': 'Humidité',
        'pressure': 'Pression',
        'close': 'Fermer',
        'choose_city': 'Choisir une ville',
      },
      'en': {
        'temperature': 'Temperature',
        'humidity': 'Humidity',
        'pressure': 'Pressure',
        'close': 'Close',
        'choose_city': 'Choose a city',
      },
      'ar': {
        'temperature': 'درجة الحرارة',
        'humidity': 'الرطوبة',
        'pressure': 'الضغط',
        'close': 'إغلاق',
        'choose_city': 'اختر مدينة',
      },
    };
    return translations[_language]?[key] ?? key;
  }

  @override
  Widget build(BuildContext context) {
    String flagUrl = 'https://flagsapi.com/$_country/flat/64.png';

    return Scaffold(
      appBar: AppBar(
        title: const Text('WeatherApp'),
        actions: [
          IconButton(
            icon: const Text('AR'),
            onPressed: () {
              setState(() {
                _language = 'ar';
                _isLoading = true;
              });
              fetchWeatherData();
            },
          ),
          IconButton(
            icon: const Text('EN'),
            onPressed: () {
              setState(() {
                _language = 'en';
                _isLoading = true;
              });
              fetchWeatherData();
            },
          ),
          IconButton(
            icon: const Text('FR'),
            onPressed: () {
              setState(() {
                _language = 'fr';
                _isLoading = true;
              });
              fetchWeatherData();
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              flagUrl,
              width: 50,
              height: 50,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 50, color: Colors.red);
              },
            ),
            const SizedBox(height: 20),
            Image.asset(
              _weatherIcon,
              height: 100,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.error, size: 150, color: Colors.red);
              },
            ),
            const SizedBox(height: 20),
            Text(
              _weatherDescription,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(translate('temperature')),
                          content: Text('$_temp°C'),
                          actions: <Widget>[
                            TextButton(
                              child: Text(translate('close')),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.thermostat, size: 50, color: Colors.blue),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(translate('humidity')),
                          content: Text('$_hum%'),
                          actions: <Widget>[
                            TextButton(
                              child: Text(translate('close')),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.water_drop, size: 50, color: Colors.blue),
                ),
                const SizedBox(width: 20),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text(translate('pressure')),
                          content: Text('$_pressure hPa'),
                          actions: <Widget>[
                            TextButton(
                              child: Text(translate('close')),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Icon(Icons.compress, size: 50, color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 40),
            TextField(
              decoration: InputDecoration(
                labelText: translate('choose_city'),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onSubmitted: (String value) {
                setState(() {
                  _city = value;
                  _isLoading = true;
                });
                fetchWeatherData();
              },
            ),
          ],
        ),
      ),
    );
  }
}
