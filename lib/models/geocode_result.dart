import 'lat_lng.dart';

/// A geocode result containing coordinates and address metadata.
class GeocodeResult {
  const GeocodeResult({
    required this.label,
    required this.position,
    this.country,
    this.municipality,
  });

  /// Full address label.
  final String label;

  /// Geographic coordinates.
  final LatLng position;

  /// Country name or code (if available).
  final String? country;

  /// Municipality / city (if available).
  final String? municipality;

  @override
  String toString() =>
      'GeocodeResult(label: $label, position: $position, country: $country, municipality: $municipality)';
}
