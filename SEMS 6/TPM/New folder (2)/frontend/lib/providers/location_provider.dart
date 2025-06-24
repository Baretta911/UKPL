import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class LocationProvider extends ChangeNotifier {
  Position? _currentPosition;
  String _currentLocation = 'Indonesia';
  String _currentTimezone = 'WIB';
  String _currentCurrency = 'IDR';
  bool _isLoading = false;
  String? _errorMessage;

  Position? get currentPosition => _currentPosition;
  String get currentLocation => _currentLocation;
  String get currentTimezone => _currentTimezone;
  String get currentCurrency => _currentCurrency;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Store locations with their timezone and currency info
  final Map<String, Map<String, String>> _storeLocations = {
    'Indonesia': {
      'timezone': 'WIB',
      'currency': 'IDR',
      'lat': '-6.2088',
      'lng': '106.8456',
    },
    'United States': {
      'timezone': 'EST',
      'currency': 'USD',
      'lat': '40.7128',
      'lng': '-74.0060',
    },
    'Japan': {
      'timezone': 'JST',
      'currency': 'JPY',
      'lat': '35.6762',
      'lng': '139.6503',
    },
    'London': {
      'timezone': 'GMT',
      'currency': 'EUR',
      'lat': '51.5074',
      'lng': '-0.1278',
    },
  };

  LocationProvider() {
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _getCurrentLocation();
  }

  Future<bool> _requestLocationPermission() async {
    final status = await Permission.location.request();
    return status == PermissionStatus.granted;
  }

  Future<void> _getCurrentLocation() async {
    _setLoading(true);
    _clearError();

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _setError('Location services are disabled');
        _setLoading(false);
        return;
      }

      // Check and request permissions
      bool hasPermission = await _requestLocationPermission();
      if (!hasPermission) {
        _setError('Location permission denied');
        _setLoading(false);
        return;
      }

      // Get current position
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );

      // Determine nearest store location
      _determineNearestStore();
    } catch (e) {
      _setError('Failed to get location: $e');
    }

    _setLoading(false);
  }

  void _determineNearestStore() {
    if (_currentPosition == null) return;

    double minDistance = double.infinity;
    String nearestLocation = 'Indonesia';

    for (final entry in _storeLocations.entries) {
      final storeData = entry.value;
      final storeLat = double.parse(storeData['lat']!);
      final storeLng = double.parse(storeData['lng']!);

      final distance = Geolocator.distanceBetween(
        _currentPosition!.latitude,
        _currentPosition!.longitude,
        storeLat,
        storeLng,
      );

      if (distance < minDistance) {
        minDistance = distance;
        nearestLocation = entry.key;
      }
    }

    setLocation(nearestLocation);
  }

  void setLocation(String location) {
    if (_storeLocations.containsKey(location)) {
      _currentLocation = location;
      _currentTimezone = _storeLocations[location]!['timezone']!;
      _currentCurrency = _storeLocations[location]!['currency']!;
      notifyListeners();
    }
  }

  String getStoreOperatingHours() {
    switch (_currentTimezone) {
      case 'WIB':
        return '09:00 - 21:00 WIB';
      case 'WITA':
        return '09:00 - 21:00 WITA';
      case 'WIT':
        return '09:00 - 21:00 WIT';
      case 'EST':
        return '10:00 AM - 10:00 PM EST';
      case 'GMT':
        return '09:00 - 21:00 GMT';
      case 'JST':
        return '10:00 - 22:00 JST';
      default:
        return '09:00 - 21:00';
    }
  }

  String getCurrentTime() {
    final now = DateTime.now();
    switch (_currentTimezone) {
      case 'WIB':
        return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')} WIB';
      case 'WITA':
        final witaTime = now.add(const Duration(hours: 1));
        return '${witaTime.hour.toString().padLeft(2, '0')}:${witaTime.minute.toString().padLeft(2, '0')} WITA';
      case 'WIT':
        final witTime = now.add(const Duration(hours: 2));
        return '${witTime.hour.toString().padLeft(2, '0')}:${witTime.minute.toString().padLeft(2, '0')} WIT';
      case 'EST':
        final estTime = now.subtract(const Duration(hours: 12)); // Approximate
        return '${estTime.hour.toString().padLeft(2, '0')}:${estTime.minute.toString().padLeft(2, '0')} EST';
      case 'GMT':
        final gmtTime = now.subtract(const Duration(hours: 7)); // Approximate
        return '${gmtTime.hour.toString().padLeft(2, '0')}:${gmtTime.minute.toString().padLeft(2, '0')} GMT';
      case 'JST':
        final jstTime = now.add(const Duration(hours: 2)); // Approximate
        return '${jstTime.hour.toString().padLeft(2, '0')}:${jstTime.minute.toString().padLeft(2, '0')} JST';
      default:
        return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    }
  }

  bool isStoreOpen() {
    final now = DateTime.now();
    final hour = now.hour;
    
    switch (_currentTimezone) {
      case 'WIB':
      case 'WITA':
      case 'WIT':
      case 'GMT':
        return hour >= 9 && hour < 21;
      case 'EST':
        return hour >= 10 && hour < 22;
      case 'JST':
        return hour >= 10 && hour < 22;
      default:
        return hour >= 9 && hour < 21;
    }
  }

  String getStoreAddress() {
    switch (_currentLocation) {
      case 'Indonesia':
        return 'Jl. Mainan Raya No. 123, Jakarta, Indonesia';
      case 'United States':
        return '456 Toy Street, New York, NY 10001, USA';
      case 'Japan':
        return '789 Omocha Dori, Shibuya, Tokyo 150-0002, Japan';
      case 'London':
        return '321 Toy Lane, London SW1A 1AA, United Kingdom';
      default:
        return 'Store address not available';
    }
  }

  List<String> getAvailableLocations() {
    return _storeLocations.keys.toList();
  }

  Future<void> refreshLocation() async {
    await _getCurrentLocation();
  }

  double? getDistanceToStore(String location) {
    if (_currentPosition == null || !_storeLocations.containsKey(location)) {
      return null;
    }

    final storeData = _storeLocations[location]!;
    final storeLat = double.parse(storeData['lat']!);
    final storeLng = double.parse(storeData['lng']!);

    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      storeLat,
      storeLng,
    ) / 1000; // Convert to kilometers
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
