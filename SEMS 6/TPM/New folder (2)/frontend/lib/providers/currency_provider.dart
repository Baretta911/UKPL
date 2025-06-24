import 'package:flutter/foundation.dart';
import '../services/api_service.dart';

class CurrencyProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  Map<String, double> _exchangeRates = {
    'USD': 0.000067,
    'JPY': 0.0098,
    'EUR': 0.000062,
  };
  
  String _baseCurrency = 'IDR';
  bool _isLoading = false;
  String? _errorMessage;
  DateTime? _lastUpdated;

  Map<String, double> get exchangeRates => _exchangeRates;
  String get baseCurrency => _baseCurrency;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  DateTime? get lastUpdated => _lastUpdated;

  // Currency symbols
  final Map<String, String> _currencySymbols = {
    'IDR': 'Rp',
    'USD': '\$',
    'JPY': '¥',
    'EUR': '€',
  };

  // Currency names
  final Map<String, String> _currencyNames = {
    'IDR': 'Indonesian Rupiah',
    'USD': 'US Dollar',
    'JPY': 'Japanese Yen',
    'EUR': 'Euro',
  };

  CurrencyProvider() {
    _loadExchangeRates();
  }

  Future<void> _loadExchangeRates() async {
    _setLoading(true);
    _clearError();

    try {
      final rates = await _apiService.getCurrencyRates();
      _exchangeRates = rates;
      _lastUpdated = DateTime.now();
    } catch (e) {
      _setError('Failed to load exchange rates: $e');
      // Keep using default rates
    }

    _setLoading(false);
  }

  Future<void> refreshRates() async {
    await _loadExchangeRates();
  }

  double convertCurrency(double amount, String fromCurrency, String toCurrency) {
    if (fromCurrency == toCurrency) return amount;

    // Convert from IDR to target currency
    if (fromCurrency == 'IDR' && _exchangeRates.containsKey(toCurrency)) {
      return amount * _exchangeRates[toCurrency]!;
    }

    // Convert from target currency to IDR
    if (toCurrency == 'IDR' && _exchangeRates.containsKey(fromCurrency)) {
      return amount / _exchangeRates[fromCurrency]!;
    }

    // Convert between two non-IDR currencies
    if (_exchangeRates.containsKey(fromCurrency) && _exchangeRates.containsKey(toCurrency)) {
      // First convert to IDR, then to target currency
      final idrAmount = amount / _exchangeRates[fromCurrency]!;
      return idrAmount * _exchangeRates[toCurrency]!;
    }

    // Default: return original amount if conversion not supported
    return amount;
  }

  String formatCurrency(double amount, String currency) {
    final symbol = _currencySymbols[currency] ?? currency;
    
    switch (currency) {
      case 'IDR':
        return '$symbol ${amount.toStringAsFixed(0)}';
      case 'JPY':
        return '$symbol${amount.toStringAsFixed(0)}';
      case 'USD':
      case 'EUR':
        return '$symbol${amount.toStringAsFixed(2)}';
      default:
        return '$symbol${amount.toStringAsFixed(2)}';
    }
  }

  String getCurrencySymbol(String currency) {
    return _currencySymbols[currency] ?? currency;
  }

  String getCurrencyName(String currency) {
    return _currencyNames[currency] ?? currency;
  }

  List<String> getSupportedCurrencies() {
    return ['IDR', ...._exchangeRates.keys.toList()];
  }

  Map<String, double> convertPriceToAllCurrencies(double priceInIDR) {
    final convertedPrices = <String, double>{};
    
    convertedPrices['IDR'] = priceInIDR;
    
    for (final currency in _exchangeRates.keys) {
      convertedPrices[currency] = convertCurrency(priceInIDR, 'IDR', currency);
    }
    
    return convertedPrices;
  }

  String getLocationCurrency(String location) {
    switch (location) {
      case 'Indonesia':
        return 'IDR';
      case 'United States':
        return 'USD';
      case 'Japan':
        return 'JPY';
      case 'London':
        return 'EUR';
      default:
        return 'IDR';
    }
  }

  double getPriceForLocation(double basePrice, String location) {
    final targetCurrency = getLocationCurrency(location);
    return convertCurrency(basePrice, 'IDR', targetCurrency);
  }

  String formatPriceForLocation(double basePrice, String location) {
    final targetCurrency = getLocationCurrency(location);
    final convertedPrice = getPriceForLocation(basePrice, location);
    return formatCurrency(convertedPrice, targetCurrency);
  }

  bool isRateDataFresh() {
    if (_lastUpdated == null) return false;
    
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated!);
    
    // Consider data fresh if updated within last hour
    return difference.inHours < 1;
  }

  String getLastUpdatedText() {
    if (_lastUpdated == null) return 'Never updated';
    
    final now = DateTime.now();
    final difference = now.difference(_lastUpdated!);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  double getExchangeRate(String currency) {
    return _exchangeRates[currency] ?? 1.0;
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
