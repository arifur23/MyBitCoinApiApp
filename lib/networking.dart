import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkHelper {

  Future getData(String url) async {
    http.Response response = await http.get(Uri.parse(url));

    if(response.statusCode == 200){
      String data = response.body;
      print(response.statusCode);
      return jsonDecode(data);

    }
    else{
      print("Error in fetching data ");
    }
  }
}