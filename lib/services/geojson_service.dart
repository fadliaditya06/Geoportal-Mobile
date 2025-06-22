import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GeoJsonService {
  static Future<List<Polygon>> loadPolygonsFromAsset(String assetPath) async {
    final String data = await rootBundle.loadString(assetPath);
    final geoJson = jsonDecode(data);
    final List<Polygon> polygons = [];

    for (var feature in geoJson['features']) {
      final geometry = feature['geometry'];
      if (geometry == null || geometry['coordinates'] == null) continue;

      if (geometry['type'] == 'Polygon') {
        final coordinates = geometry['coordinates'][0];
        if (coordinates.isEmpty) continue;

        final points = coordinates
            .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
            .toList();

        polygons.add(
          Polygon(
            points: points,
            color: Colors.deepPurpleAccent.withOpacity(0.6),
            borderColor: Colors.deepPurpleAccent,
            borderStrokeWidth: 2,
          ),
        );
      }

      if (geometry['type'] == 'MultiPolygon') {
        for (final polygon in geometry['coordinates']) {
          final coordinates = polygon[0];
          if (coordinates.isEmpty) continue;

          final points = coordinates
              .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
              .toList();

          polygons.add(
            Polygon(
              points: points,
              color: Colors.deepOrange.withOpacity(0.6),
              borderColor: Colors.deepOrange,
              borderStrokeWidth: 2,
            ),
          );
        }
      }
    }

    return polygons;
  }

  static Future<List<Marker>> loadMarkersFromAsset(
    String assetPath,
    BuildContext context,
    Marker Function(LatLng, Map<String, dynamic>, BuildContext) markerBuilder,
  ) async {
    final String data = await rootBundle.loadString(assetPath);
    final geoJson = jsonDecode(data);
    final List<Marker> markers = [];

    for (var feature in geoJson['features']) {
      final geometry = feature['geometry'];
      if (geometry == null || geometry['coordinates'] == null) continue;

      LatLng? point;

      if (geometry['type'] == 'Polygon' || geometry['type'] == 'MultiPolygon') {
        final List coords = geometry['type'] == 'Polygon'
            ? geometry['coordinates'][0]
            : geometry['coordinates'][0][0];

        if (coords.isEmpty) continue;

        final points = coords
            .map<LatLng>((c) => LatLng(c[1].toDouble(), c[0].toDouble()))
            .toList();

        point = _getPolygonCenter(points);
      } else if (geometry['type'] == 'Point') {
        point = LatLng(
          geometry['coordinates'][1].toDouble(),
          geometry['coordinates'][0].toDouble(),
        );
      }

      if (point != null) {
        markers.add(markerBuilder(point, feature, context));
      }
    }

    return markers;
  }

  static LatLng _getPolygonCenter(List<LatLng> points) {
    double lat = 0;
    double lng = 0;
    for (var p in points) {
      lat += p.latitude;
      lng += p.longitude;
    }
    return LatLng(lat / points.length, lng / points.length);
  }
}
