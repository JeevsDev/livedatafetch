import 'dart:async';
import 'package:flutter/material.dart';
import 'crypto_service.dart';
import 'api_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final CryptoService cryptoService = CryptoService(ApiConfig.bitcoinPriceApiUrl);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Text('Bitcoin Price Live Fetch'),
        ),
        body: Center(
          child: BitcoinPriceWidget(cryptoService: cryptoService),
        ),
      ),
    );
  }
}

class BitcoinPriceWidget extends StatefulWidget {
  final CryptoService cryptoService;

  BitcoinPriceWidget({required this.cryptoService});

  @override
  _BitcoinPriceWidgetState createState() => _BitcoinPriceWidgetState();
}

class _BitcoinPriceWidgetState extends State<BitcoinPriceWidget> {
  double bitcoinPrice = 0.0;

  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 30), (timer) {
      _fetchBitcoinPrice();
    });
    _fetchBitcoinPrice();
  }

  Future<void> _fetchBitcoinPrice() async {
    try {
      final price = await widget.cryptoService.fetchBitcoinPrice();
      setState(() {
        bitcoinPrice = price;
      });
    } catch (e) {
      print('Error fetching Bitcoin price: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(
          Icons.currency_bitcoin_sharp, 
          size: 100, 
          color: Colors.orange, 
        ),
        SizedBox(height: 30), 
        const Text(
          'Bitcoin Price:',
          style: TextStyle(fontSize: 20),
        ),
        SizedBox(height: 20,),
        Text(
          '\$$bitcoinPrice USD',
          style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

