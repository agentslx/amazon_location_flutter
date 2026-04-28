/// A single autocomplete suggestion from the GeoPlaces API.
class AutocompleteResult {
  const AutocompleteResult({
    required this.placeId,
    required this.label,
    required this.placeType,
  });

  /// The unique place identifier (used for subsequent geocode calls).
  final String placeId;

  /// Human-readable label (e.g. "Sydney Opera House, Bennelong Point").
  final String label;

  /// The type of place (e.g. "PointOfInterest", "Street").
  final String placeType;

  @override
  String toString() =>
      'AutocompleteResult(placeId: $placeId, label: $label, placeType: $placeType)';
}
