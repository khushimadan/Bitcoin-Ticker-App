import 'package:flutter/material.dart';
import 'coin_data.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({super.key});

  @override
  State<PriceScreen> createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';
  List<DropdownMenuItem<String>> getCurrencyList() {
    List<DropdownMenuItem<String>> itemsList = [];
    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      itemsList.add(newItem);
    }
    return itemsList;
  }

  Map<String, String> coinValues = {};
  bool isWaiting = false;
  String bitcoinValue = '?';
  CoinData coinData = CoinData();
  late String crypto;
  void getData() async {
    isWaiting = true;
    try {
      var data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;
      setState(() {
        coinValues = data;
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bitcoin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                  value: isWaiting ? '?' : coinValues['BTC']!,
                  selectedCurrency: selectedCurrency,
                  crypto: 'BTC'),
              CryptoCard(
                  value: isWaiting ? '?' : coinValues['ETH']!,
                  selectedCurrency: selectedCurrency,
                  crypto: 'ETH'),
              CryptoCard(
                  value: isWaiting ? '?' : coinValues['LTC']!,
                  selectedCurrency: selectedCurrency,
                  crypto: 'LTC'),
            ],
          ),
          Container(
            color: Colors.green[300],
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            child: DropdownButton<String>(
              value: selectedCurrency,
              items: getCurrencyList(),
              onChanged: (value) {
                setState(() {
                  selectedCurrency = value!;
                  getData();
                });
              },
              dropdownColor: Colors.white,
              style: const TextStyle(
                color: Colors.black54,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {super.key,
      required this.value,
      required this.selectedCurrency,
      required this.crypto});

  final String value;
  final String selectedCurrency;
  final String crypto;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.green[200],
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $crypto = $value $selectedCurrency',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
