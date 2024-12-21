import 'package:flutter/material.dart';

class HourlyForecast extends StatelessWidget {
   HourlyForecast({super.key, required this.temperature, required this.icon, required this.condition});

  IconData icon;
  String condition = "";
  double temperature = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Card(
        surfaceTintColor: Colors.lightBlueAccent,
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Container(
          padding: const EdgeInsets.all(10),
          width: 120,
          child: Column(
            children: [
               Text(
               '$temperature',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 8,
              ),
              Icon(icon,size: 25,
                    color: condition == 'Haze'||
                            condition == 'Rain'||
                            condition == 'Mist'||
                            condition == 'Clouds' ? Colors.grey:Colors.yellow),
              const SizedBox(
                height: 8,
              ),
               Text('$condition',style: TextStyle(fontWeight: FontWeight.bold),)
            ],
          ),
        ),
      ),
    );
  }
}
