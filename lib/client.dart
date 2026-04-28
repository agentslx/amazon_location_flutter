import 'dart:convert';

import 'package:http/http.dart' as http;

import 'exceptions/amazon_location_exception.dart';
import 'models/autocomplete_result.dart';
import 'models/geocode_result.dart';
import 'models/lat_lng.dart';

/// Client for the Amazon Location Service GeoPlaces API v2.
///
/// Uses a static API key passed as a query parameter — no SigV4 signing needed.
class AmazonLocationClient {
  AmazonLocationClient({
    required this.apiKey,
    required this.region,
    http.Client? httpClient,
  }) : _http = httpClient ?? http.Client();

  final String apiKey;
  final String region;
  final http.Client _http;

  String get _baseUrl => 'https://places.geo.$region.amazonaws.com';

  /// Search for place suggestions matching [query].
  ///
  /// Returns up to [maxResults] results (default 5).
  /// Optionally bias results towards [biasPosition].
  Future<List<AutocompleteResult>> autocomplete(
    String query, {
    int maxResults = 5,
    LatLng? biasPosition,
    String? language,
  }) async {
    final body = <String, dynamic>{
      'QueryText': query,
      'MaxResults': maxResults,
    };
    if (biasPosition != null) {
      // AWS expects [longitude, latitude] order.
      body['BiasPosition'] = [biasPosition.longitude, biasPosition.latitude];
    }
    if (language != null) body['Language'] = language;

    final response = await _post('/v2/autocomplete', body);
    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['ResultItems'] as List<dynamic>? ?? [];

    return items.map((item) {
      final map = item as Map<String, dynamic>;
      return AutocompleteResult(
        placeId: map['PlaceId'] as String? ?? '',
        label: map['Title'] as String? ?? '',
        placeType: map['PlaceType'] as String? ?? '',
      );
    }).toList();
  }

  /// Geocode a text query and return the top result with coordinates.
  ///
  /// Returns `null` if no results are found.
  Future<GeocodeResult?> geocode(
    String queryText, {
    String? language,
  }) async {
    final body = <String, dynamic>{
      'QueryText': queryText,
      'MaxResults': 1,
    };
    if (language != null) body['Language'] = language;

    final response = await _post('/v2/geocode', body);
    final data = json.decode(response.body) as Map<String, dynamic>;
    final items = data['ResultItems'] as List<dynamic>? ?? [];
    if (items.isEmpty) return null;

    final item = items[0] as Map<String, dynamic>;
    final position = item['Position'] as List<dynamic>?;
    if (position == null || position.length < 2) return null;

    // AWS returns [longitude, latitude] — swap to LatLng(lat, lng).
    final lng = (position[0] as num).toDouble();
    final lat = (position[1] as num).toDouble();

    final address = item['Address'] as Map<String, dynamic>? ?? {};

    return GeocodeResult(
      label: address['Label'] as String? ?? queryText,
      position: LatLng(latitude: lat, longitude: lng),
      country: address['Country'] as String?,
      municipality: address['Municipality'] as String?,
    );
  }

  /// Release the underlying HTTP client.
  void dispose() => _http.close();

  Future<http.Response> _post(String path, Map<String, dynamic> body) async {
    final uri = Uri.parse('$_baseUrl$path').replace(
      queryParameters: {'key': apiKey},
    );
    final response = await _http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(body),
    );
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw AmazonLocationException(
        statusCode: response.statusCode,
        message: response.body,
      );
    }
    return response;
  }
}
