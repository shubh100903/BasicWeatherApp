import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather_app/utils/additional_info.dart';
import 'package:weather_app/utils/hourly_forecast.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  bool isLoading = true;
  double currTemp = 0;
  var cloudCondition = "";
  String cityname = "London";
  int humidity = 0, pressure = 0;
  double windSpeed = 0;

  TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future<void> getCurrentWeather() async {
    // Try block is used to catch errors
    try {
      String apikey = "56cd9bffc694cf4295fe4cffc4624bd1";
      final response = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$cityname&appid=$apikey'));


      if (response.statusCode == 200)
      // Status code 200 means your api connection is stable
      {
        final data = jsonDecode(response.body);
        print(data);

        setState(() {
          currTemp = double.parse((data['main']['temp'] - 273.15).toStringAsFixed(3));
          humidity = data['main']['humidity'];
          pressure = data['main']['pressure'];
          windSpeed = data['wind']['speed'];
          cloudCondition = data['weather'][0]['main'];
          isLoading = false;
        });
      } else {
        print("Error :${response.statusCode}");
      }

    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          cityname[0].toUpperCase() + cityname.substring(1),
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 25),
        ),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                });
                getCurrentWeather();
              },
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
                size: 25,
              )),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        surfaceTintColor: Colors.lightBlueAccent,
                        elevation: 10,
                        child: Column(
                          children: [
                            Text(
                              currTemp == 0 ? "Loading..." : '$currTemp °C',
                              style: const TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Icon(
                              cloudCondition == 'Clouds' ||
                                      cloudCondition == 'Mist' ||
                                      cloudCondition == 'Haze' ||
                                      cloudCondition == 'Rain'
                                  ? Icons.cloud
                                  : Icons.sunny,
                              size: 64,
                              color: cloudCondition == 'Clouds' ||
                                      cloudCondition == 'Mist' ||
                                      cloudCondition == 'Haze' ||
                                      cloudCondition == 'Rain'
                                  ? Colors.blueGrey
                                  : Colors.yellow.shade700,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            Text(
                              cloudCondition.isEmpty
                                  ? "Fetching Data..."
                                  : cloudCondition,
                              style: const TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Hourly Forecast',
                          style: TextStyle(
                              fontSize: 25, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 12,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          HourlyForecast(temperature: currTemp,icon: cloudCondition=='Haze'||cloudCondition=='Mist'||cloudCondition=='Haze'||cloudCondition=='Clouds'?Icons.cloud:Icons.sunny,condition: cloudCondition,),
                          HourlyForecast(temperature: currTemp,icon: cloudCondition=='Haze'||cloudCondition=='Mist'||cloudCondition=='Haze'||cloudCondition=='Clouds'?Icons.cloud:Icons.sunny,condition: cloudCondition,),
                          HourlyForecast(temperature: currTemp,icon: cloudCondition=='Haze'||cloudCondition=='Mist'||cloudCondition=='Haze'||cloudCondition=='Clouds'?Icons.cloud:Icons.sunny,condition: cloudCondition,),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Additional Information',
                        style:
                            TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AdditionalInfo(title: 'Wind', value: '$windSpeed Kmph', icon: Icons.air),
                          AdditionalInfo(title: 'Humidity', value: '$humidity %', icon: Icons.water),
                          AdditionalInfo(title: 'Pressure', value: '$pressure hPa', icon: Icons.arrow_downward),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 35,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () async {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text(
                                      'Change Location',
                                      style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    content: TextFormField(
                                      controller: cityController,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter City Name',
                                      ),
                                      inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[a-zA-Z]'))],
                                    ),
                                    actions: [
                                      // Cancel Button
                                      TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Cancel')),
                                      // OK Button
                                      TextButton(
                                          onPressed: () {
                                            setState(() {
                                              cityname = cityController.text;
                                              isLoading = true;
                                            });
                                            getCurrentWeather();
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'))
                                    ],
                                  );
                                });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            padding: const EdgeInsets.all(12.0),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16.0)),
                          ),
                          child: const Text(
                            'Change Location',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          )),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

// API - Application Programming Interface
// - API is a kind of tool or link which allows to communicate with our software to another software or we can use the services of another software like it's data without interfering into their data.
// - It helps to enable different software integration.
