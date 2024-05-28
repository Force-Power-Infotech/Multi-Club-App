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
  final String googleMapsLink =
      'https://www.google.com/maps/place/42+A+Bus+Stand/@22.523776,88.3752148,2711m/data=!3m1!1e3!4m14!1m7!3m6!1s0x3a0270d190004ad7:0x73a87dd58a052eab!2sThe+Bengal+Rowing+Club+(BRC)!8m2!3d22.5094781!4d88.3548955!16s%2Fg%2F1q5gpd9n0!3m5!1s0x3a0276ba563a10cb:0x7207e039b8f9aeca!8m2!3d22.530824!4d88.3894609!16s%2Fg%2F11g873r2lz?entry=ttu'; // Replace with your Google Maps link
  final RegExp regex = RegExp(r'@(-?\d+\.\d+),(-?\d+\.\d+)');

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
                child: Icon(
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
