import 'dart:convert';

import 'package:http/http.dart' as http;

class ApiHelper {
  ApiHelper._();

  static final ApiHelper apiHelper = ApiHelper._();

  Future<Map?> getCurrency({
    required String from,
    required String to,
    required String amount,
  }) async {
    String myURL =
        "https://currency-converter-by-api-ninjas.p.rapidapi.com/v1/convertcurrency?have=$from&want=$to&amount=$amount";
    http.Response res = await http.get(Uri.parse(myURL), headers: {
      "X-RapidAPI-Key": "a254c4ddfdmsh3ec2ddd42635b68p1a6dbajsn96d919206393",
      "X-RapidAPI-Host": "currency-converter-by-api-ninjas.p.rapidapi.com"
    });

    if (res.statusCode == 200) {
      Map data = jsonDecode(res.body);
      return data;
    }
    return null;
  }
}
