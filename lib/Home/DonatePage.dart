import 'package:flutter/material.dart';

class DonatePlasticPage extends StatefulWidget {
  const DonatePlasticPage({super.key});

  @override
  State<DonatePlasticPage> createState() => _DonatePlasticPageState();
}

class _DonatePlasticPageState extends State<DonatePlasticPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/flag.png',
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            "Do you want your plastic to be collected?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              fixedSize: const Size(300, 50),
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => DonatePlastic(),
              //   ),
              // );
            },
            child: const Text("Yes, Flag my location"),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              fixedSize: const Size(300, 50),
            ),
            onPressed: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => SuccesLog(),
              //   ),
              // );
            },
            child: const Text("Return Home"),
          ),
        ],
      ),
    );
  }
}
