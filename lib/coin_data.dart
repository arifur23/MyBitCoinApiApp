import 'package:bitcoin_tiker_challenge/networking.dart';

class CoinData {

 String apiKey = 'A031A10D-68BE-4435-A166-09D20EF01DEC';
 String base = 'BTC';

   List<String> currenciesList = [
    'AUD',
    'BRL',
    'CAD',
    'CNY',
    'EUR',
    'GBP',
    'HKD',
    'IDR',
    'ILS',
    'INR',
    'JPY',
    'MXN',
    'NOK',
    'NZD',
    'PLN',
    'RON',
    'RUB',
    'SEK',
    'SGD',
    'USD',
    'ZAR'
  ];


   List<String> cryptoList = [
    'BTC',
    'ETH',
    'LTC',
  ];



   Future getBTCRate(String idQuote) async{

    NetworkHelper networkHelper = NetworkHelper();
    Map<String, String> currenciesValues = {};
    for(String crypto in cryptoList) {
     try {
      String url = 'https://rest.coinapi.io/v1/exchangerate/$crypto/$idQuote?apikey=$apiKey';
      var bitCoinData = await networkHelper.getData(url);
      double rate = bitCoinData['rate'];
      if (rate == null) {
       print("Null rate");
      }
      else {
       print(rate);
       currenciesValues[crypto] = rate.toString();
      }
     }catch(e){
      print(e);
     }
    }
    return currenciesValues;
   }
}
