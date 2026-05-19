import 'package:flutter/material.dart';
import 'geo_helper.dart';

class MapCapas {
  final String id;
  final String url;
  final bool esApi;

  final Color color;
  final IconData icon;

  bool visible;
  GeoData? data;

  MapCapas({
    required this.id,
    required this.url,
    required this.esApi,
    required this.color,
    required this.icon,
    this.visible = true,
  });
}
