// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';

// class MapWidget extends StatelessWidget {
//   final double latitude =
//       12.9715987; // Replace with the latitude from your map URL
//   final double longitude =
//       77.594566; // Replace with the longitude from your map URL

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 200,
//       decoration: BoxDecoration(
//         border: Border.all(color: Colors.grey),
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: FlutterMap(
//         options: MapOptions(
//           center: LatLng(latitude, longitude),
//           zoom: 15.0,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
//             subdomains: ['a', 'b', 'c'],
//           ),
//           MarkerLayer(
//             markers: [
//               Marker(
//                 point: LatLng(latitude, longitude),
//                 width: 40.0,
//                 height: 40.0,
//                 child: Icon(
//                   Icons.location_pin,
//                   color: Colors.red,
//                   size: 40.0,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final String googleMapsLink;
  final RegExp regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');

  MapWidget({required this.googleMapsLink}); // Constructor

  LatLng extractLatLngFromLink(String link) {
    final match = regex.firstMatch(link);
    if (match != null && match.groupCount == 2) {
      final latitude = double.parse(match.group(1)!);
      final longitude = double.parse(match.group(2)!);
      return LatLng(latitude, longitude);
    }
    throw Exception('Invalid Google Maps link');
  }

  @override
  Widget build(BuildContext context) {
    final LatLng latLng = extractLatLngFromLink(googleMapsLink);

    return Container(
      height: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: FlutterMap(
        options: MapOptions(
          center: latLng,
          zoom: 15.0,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: latLng,
                width: 40.0,
                height: 40.0,
                child: const Icon(
                  Icons.location_pin,
                  color: Colors.red,
                  size: 40.0,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
