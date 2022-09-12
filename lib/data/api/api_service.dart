import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:restoran_submision/data/model/restaurants.dart';
import 'package:restoran_submision/utils/exception.dart';

import '../model/search_response.dart';

class ApiService {
  static const String _baseUrl = "https://restaurant-api.dicoding.dev/";

  Future<Restaurants> listRestauran() async {
    final response = await http.get(Uri.parse("${_baseUrl}list"));
    if (response.statusCode == 200) {
      return Restaurants.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException("Failed to load list restaurans");
    }
  }

  Future<SearchResponse> searchRestauran(String q) async {
    final response = await http.get(Uri.parse("${_baseUrl}search?q=$q"));
    if (response.statusCode == 200) {
      return SearchResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException("Failed to load list restaurans");
    }
  }
}
