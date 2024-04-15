// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plas_track/SideNavBar/SideBar.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideBar(),
      appBar: AppBar(
        title: Text(
          "Plastrack",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FlutterMap(
          options: MapOptions(
              initialCenter: LatLng(12.9775876, 80.2133303),
              initialZoom: 13,
              interactionOptions: const InteractionOptions(
                  flags: ~InteractiveFlag.doubleTapZoom)),
          children: [
            openStreetMaptileLater,
            MarkerLayer(markers: [
              Marker(
                  point: LatLng(12.9775876, 80.2133303),
                  child: Icon(
                    Icons.location_pin,
                    size: 60,
                    color: Colors.red,
                  )),
              Marker(
                  point: LatLng(12.9830269, 80.2594001),
                  child: Icon(
                    Icons.location_pin,
                    size: 60,
                    color: Colors.red,
                  )),
              Marker(
                  point: LatLng(12.9880288, 80.20471330000001),
                  child: Icon(
                    Icons.location_pin,
                    size: 60,
                    color: Colors.red,
                  )),
              Marker(
                  point: LatLng(12.9737143, 80.21829749999999),
                  child: Icon(
                    Icons.location_pin,
                    size: 60,
                    color: Colors.red,
                  ))
            ]),
          ]),
    );
  }
}

TileLayer get openStreetMaptileLater => TileLayer(
      urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
      userAgentPackageName: 'dev.fleaflet.flutter_map.example',
    );
