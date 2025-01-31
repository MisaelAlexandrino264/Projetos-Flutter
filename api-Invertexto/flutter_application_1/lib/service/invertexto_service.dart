import 'dart:convert';

import 'package:http/http.dart' as http;

final String _token = "15494|IoZopQHHl7UerqlfPFky4whMsYS98SDk";

Future<Map> converteNumeroPorExtenso(String? _valor) async{
  http.Response response;
  response = await http.get(Uri.parse("https://api.invertexto.com/v1/number-to-words?token=$_token&number=$_valor&language=pt&currency=BRL"));
  return json.decode(response.body);
}

Future<Map>buscaCEP(String? _cep) async{
  http.Response response;
  response = await http.get(Uri.parse("https://api.invertexto.com/v1/cep/$_cep?token=$_token"));
  return json.decode(response.body);
}

Future<Map>localizarIP(String? ip) async{
  http.Response response;
  response = await http.get(Uri.parse("https://api.invertexto.com/v1/geoip/$ip?token=$_token"));
  return json.decode(response.body);
}