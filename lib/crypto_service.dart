import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_config.dart';


class CryptoService {
  final String apiUrl;

  CryptoService(this.apiUrl);

  Future<double> fetchBitcoinPrice() async {
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('bitcoin')) {
          final bitcoinData = data['bitcoin'];
          if (bitcoinData.containsKey('usd')) {
            return bitcoinData['usd'].toDouble();
          }
        }
        throw Exception('Invalid data format from API');
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Failed to fetch data: $e');
    }
  }
}




