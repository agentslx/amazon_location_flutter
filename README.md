# amazon_location_flutter

Dart/Flutter client for the [Amazon Location Service GeoPlaces API](https://docs.aws.amazon.com/location/latest/APIReference/Welcome.html) (autocomplete + geocode).

Uses a static API key for authentication — no Cognito Identity Pool or SigV4 signing required.

## Usage

```dart
final client = AmazonLocationClient(
  apiKey: 'your-api-key',
  region: 'ap-southeast-2',
);

// Autocomplete
final suggestions = await client.autocomplete('Sydney Opera');

// Geocode
final result = await client.geocode(suggestions.first.label);
print(result?.position); // LatLng(latitude: -33.8568, longitude: 151.2153)

client.dispose();
```
