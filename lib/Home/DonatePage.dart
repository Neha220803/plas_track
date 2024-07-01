import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:location/location.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:googleapis/androidpublisher/v3.dart';
import 'package:googleapis_auth/googleapis_auth.dart' as auth;

class DonatePlasticPage extends StatefulWidget {
  const DonatePlasticPage({Key? key}) : super(key: key);

  @override
  State<DonatePlasticPage> createState() => _DonatePlasticPageState();
}

class _DonatePlasticPageState extends State<DonatePlasticPage> {
  late Location location;
  bool _serviceEnabled = false;
  PermissionStatus? _permissionGranted;
  LocationData? _locationData;
  bool _loading = false; // Add a loading state variable

  final _formKey = GlobalKey<FormState>();
  final CollectionReference _petrol =
      FirebaseFirestore.instance.collection('petrol');

  TextEditingController _titleController = TextEditingController();
  late User? _user;
  String? mtoken = " ";
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    location = Location();
    _checkLocationPermission();
    _fetchUser();
    requestPermission();
    getToken();
    initInfo();
  }

  Future<void> _fetchUser() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    setState(() {
      _user = currentUser;
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User denied or not accepted permission');
    }
  }

  static Future<String> getAccessToken() async {
    final serviceAccountJson = {
      "type": "service_account",
      "project_id": "plastrack-ec49b",
      "private_key_id": "20488cce9c995909a7862c534c1421effa601fd0",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQC79r2BBCpKCGNX\n5CzgxAhFcgScpDTvDD2ZKaVov1M3Nw8Wc+LidBF18pSYcbxzD6l9m6wDVBGaVdV4\nC4MaFqxkxq6SrCX1DYGFyxGY8f7izm0mpry7IsXqnvaxKyS+/Z6kPYPmII1BQbBC\ntuRG2bozloDV7zUEf5yrxsaMe7Q0k6O5O3HU9ljoUOEaPaNqu6yKHiLAUd17jfn9\n8VInrfb36kcQ87/NnnVlw3HrzGLElOSmuv6/SgN2/bBdnEFdu2eS9tgb5dMpPD5j\nh965s3r0uUReLlmXjK8S8krzYt8VZdXMDiGhe+tAl7WX2hDZTbABhLLbvlxZwA8Y\nkiyjN5EPAgMBAAECggEAE7zrVXr8fd23oOkjFU9AlxpMBa7wqBGe/lBzQDanJGsx\nuGfe8WzC0KHynLeE1IhWggww2gCgAJb23a5HzBuJauO6PUi6i6spaMVUSb1PyL1o\nlOB5fSU/p02eFiizqSK04AZdrXLJooqlWbwe6JnAhd5OFSkTZi+IYjlzbBkpaUPR\noDXq5fMdXKfPZT3E9Ur4oxS+7qDJgth44yJbHK+sjaDUWyxu9tokEJzQwzU0CrVG\n21DL9PBsRCJlIQYzaPNHYaNp2k98q98qvyUT4xVKCt9urnvnJyCWsoJuK8Ptv8XI\nd3VA+kUz8RNtQ6rgeaEkQIzjSS9qD4zQdHaUUdbAEQKBgQDepJDx7BOuvCckfHrw\nPrRGafjrM6FhK/EqEyxoOjy1LKqG3SFOCsnO/I1excE2EZ4Fa2KsLBgPxIDAHpdd\nHlELyR9TSQzR+m3Olei11IyMQgaw2I+Z5IPhBgNVhXemKhqKQqx+OmwRnPIBE6QZ\ndxrO40FB2hsRxCX4mGEiEaVSxQKBgQDYIBDUIcxyFfL6jME0XCqXX9omYxynU3tX\n7ewJlPSFhWnJIUSQcG6eH/jLgOI1tFQul2MQEuutJe10P32MHm6WOvhYynci1Yk5\ne1herZuxnLISckFR2eEVWztDwxmD7CFAes9bjYS4TI1KT65o5QC9fleI4paY9oI0\nzqRT1YfBwwKBgGuPG0sUnumiklJpJMdds5/04EFYfxU/slF+U8zCncN1IajnuYhH\nY/lwPyfS56WkWzAJEfFVmAY+C2lFHiDpXYQRFOYae2wRzOyptXPqjD/SQgM7jBxv\nrlqOmhu9z/DhlFLJJSYSOVVE+hEVGQkIZlYeqc8TfFJX7XQswXhBCBp1AoGBALg9\nPZtY5KwsweGMs/cqyrQYZiNrQjXyGKewjxLsBDb+sFthHM30ypfJsZHp4OzfORQu\nwagmOPp15qK+rQwRtTwkMSmgD0eGuWBjIcY0QRF7/uFyvPRFxHcsOq1dWBb56K7L\nApGNZqKlv5ylqIyLC8J+PajXYIItQno53iQJV515AoGBAK9B8tg3CFQKnF6urUau\nAdkgTJ+OP/fl2GVnaH+n8Zv3Ljq54DdiyYRyhfMXN2UwR048EignRbWro52QopPQ\nO0urdTnfLSZakzhUEa0vF4rr0ziS5WrzMDJVLu/9HXoHq+eGAA2HjDyuEyrozCnY\nHfV+2hiqEa8HypmuAcPVeQPR\n-----END PRIVATE KEY-----\n",
      "client_email":
          "plastrack-notifications@plastrack-ec49b.iam.gserviceaccount.com",
      "client_id": "117188797425614471032",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/plastrack-notifications%40plastrack-ec49b.iam.gserviceaccount.com",
      "universe_domain": "googleapis.com"
    };

    List<String> scopes = [
      "https://www.googleapis.com/auth/userinfo.email",
      "https://www.googleapis.com/auth/firebase.database",
      "https://www.googleapis.com/auth/firebase.messaging"
    ];

    final accountCredentials =
        auth.ServiceAccountCredentials.fromJson(serviceAccountJson);
    final client = await clientViaServiceAccount(accountCredentials, scopes);

    return client.credentials.accessToken.data;
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        mtoken = token;
        print("My token is $mtoken");
      });
      saveToken(token!);
    });
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("Petrol_Bunks_Tokens")
        .doc("User2")
        .set({
      'token': token,
    });
  }

  void initInfo() {
    var androidInitialize =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationsSettings =
        InitializationSettings(android: androidInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationsSettings,
        onDidReceiveNotificationResponse: (details) async {
      try {
        if (details.payload != null && details.payload!.isNotEmpty) {
        } else {}
      } catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("...............onMessage.............");
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");

      BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification!.title.toString(),
        htmlFormatContentTitle: true,
      );
      AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'plastrack',
        'plastrack',
        importance: Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: Priority.high,
        playSound: true,
      );
      NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      await flutterLocalNotificationsPlugin.show(
        0,
        message.notification?.title,
        message.notification?.body,
        platformChannelSpecifics,
        payload: message.data['body'],
      );
    });
  }

  void _checkLocationPermission() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    print("Latitude: ${_locationData?.latitude}");
    print("Longitude: ${_locationData?.longitude}");
  }

  Future<void> _addData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true; // Start loading
      });

      try {
        await _petrol.add({
          "title": _titleController.text,
          "location":
              GeoPoint(_locationData!.latitude!, _locationData!.longitude!),
          "userId": _user?.uid,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Data added successfully')),
        );
        _titleController.clear();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add data: $e')),
        );
      } finally {
        setState(() {
          _loading = false; // Stop loading
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Donate Plastic'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'Title'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loading ? null : _addData,
                  child: _loading
                      ? CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : Text('Add Data'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
