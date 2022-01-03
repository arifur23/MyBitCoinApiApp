import 'dart:io';

import 'package:bitcoin_tiker_challenge/coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PriceScreen extends StatefulWidget {
  const PriceScreen({Key? key}) : super(key: key);

  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {

  String selectedCurrency = 'USD';

  String base = 'BTC';
  late double rate = 0.0;

  Map<String, String> currenciesValues = {};

  bool isWaiting = false;

  DropdownButton<String> getDropDownButtonAndroid() {

  List <DropdownMenuItem<String>> dropDownList = [];
  CoinData coinData = CoinData();
  for(String currency in coinData.currenciesList){
    var dropDownItem = DropdownMenuItem(child:  Text(currency), value: currency,);
    dropDownList.add(dropDownItem);
  }
    return DropdownButton(items: dropDownList,value: selectedCurrency, onChanged: (value){
      setState(() {
        selectedCurrency = value!;
      });
      updateUI();
    },);
  }
  
  CupertinoPicker getCupertinoPicker(){
    List<Text> cupertinoChildren = [];
    CoinData coinData = CoinData();
    for( String currency in coinData.currenciesList){
      var cupertinoChild = Text(currency);
      cupertinoChildren.add(cupertinoChild);
    }
    
    return CupertinoPicker(itemExtent: 40.0, onSelectedItemChanged: (value){
      setState(() {
        selectedCurrency = coinData.currenciesList[value];
      });
      updateUI();
    }, children: cupertinoChildren);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateUI();
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];
    CoinData coinData = CoinData();
    for (String crypto in coinData.cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          selectedCurrency: selectedCurrency,
          value: isWaiting ? '?' : currenciesValues[crypto].toString(),
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

 void updateUI() async {
    try {
      isWaiting = true;
      var data = await CoinData().getBTCRate(selectedCurrency);
      isWaiting = false;
      setState(() {
        currenciesValues = data;
      });
    }
    catch(e){
      print(e);
    }
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: const EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isAndroid ? getDropDownButtonAndroid() : getCupertinoPicker(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard({
    required this.value,
    required this.selectedCurrency,
    required this.cryptoCurrency,
  });

  final String value;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $value $selectedCurrency',
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
