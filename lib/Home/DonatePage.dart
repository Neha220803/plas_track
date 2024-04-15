// ignore_for_file: prefer_const_constructors

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
            "images/flag.png",
            height: 150,
          ),
          const SizedBox(height: 20),
          const Text(
            "Do you want your plastic to be collected?",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Stack(alignment: Alignment.center, children: [
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
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset('images/success.png', height: 150),
                            const SizedBox(height: 20),
                            Text(
                              "Successful!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              "Thank You for Your Contribution!",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 40),
                              child: Text(
                                "Your response has been noted for the recycling program. You will receive the appropriate reward when the order reaches the warehouse.",
                                textAlign: TextAlign.center,
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("OK"),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
              child: const Text("Yes, Flag my location"),
            ),
          ]),
          const SizedBox(height: 10),
          // ElevatedButton(
          //   style: ElevatedButton.styleFrom(
          //     foregroundColor: Colors.white,
          //     backgroundColor: Colors.black,
          //     shape: RoundedRectangleBorder(
          //       borderRadius: BorderRadius.circular(30),
          //     ),
          //     fixedSize: const Size(300, 50),
          //   ),
          //   onPressed: () {
          //     // Navigator.push(
          //     //   context,
          //     //   MaterialPageRoute(
          //     //     builder: (context) => SuccesLog(),
          //     //   ),
          //     // );
          //   },
          //   child: const Text("Return Home"),
          // ),
        ],
      ),
    );
  }
}
