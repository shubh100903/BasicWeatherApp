import 'package:flutter/material.dart';

class AdditionalInfo extends StatelessWidget {
   AdditionalInfo({super.key, required this.title, required this.value, required this.icon});

   String title = '';
   String value = '';
   IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: SizedBox(
        width: 120,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          surfaceTintColor: Colors.blue,
          elevation: 10,
          child: Container(
            padding: const EdgeInsets.all(10),
            width: 120,
            child: Column(
              children: [
                Icon(icon,color: Colors.blue,size: 25,),
                const SizedBox(height: 8,),
                Text(title,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),),
                const SizedBox(height: 8,),
                Text(value,style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),)
              ],
            ),
          ),
        ),
      ),
    );
  }
}


// Weather api key = 56cd9bffc694cf4295fe4cffc4624bd1
// Weather api = https://api.openweathermap.org/data/2.5/weather?q={city name}&appid={API key}
