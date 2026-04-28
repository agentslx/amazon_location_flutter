import 'package:flutter_test/flutter_test.dart';
import 'package:amazon_location_flutter/amazon_location_flutter.dart';

void main() {
  test('LatLng equality', () {
    const a = LatLng(latitude: -33.8568, longitude: 151.2153);
    const b = LatLng(latitude: -33.8568, longitude: 151.2153);
    expect(a, equals(b));
  });

  test('AutocompleteResult stores fields', () {
    const result = AutocompleteResult(
      placeId: 'abc123',
      label: 'Sydney Opera House',
      placeType: 'PointOfInterest',
    );
    expect(result.placeId, 'abc123');
    expect(result.label, 'Sydney Opera House');
  });
}
