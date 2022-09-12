import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restoran_submision/data/api/api_service.dart';
import 'package:restoran_submision/data/model/search_response.dart';
import 'package:restoran_submision/utils/constants.dart';
import 'package:restoran_submision/utils/exception.dart';

import '../../utils/result_state.dart';

class SearchPageProvider extends ChangeNotifier {
  final ApiService apiService;

  SearchPageProvider({required this.apiService});

  late SearchResponse _restaurants;

  SearchResponse get restaurants => _restaurants;

  late ResultState _resultState = ResultState.Nothing;

  ResultState get resultState => _resultState;
  late String message = '';

  Future<dynamic> fetchRestauran(q) async {
    try {
      _resultState = ResultState.Loading;
      notifyListeners();
      final response = await apiService.searchRestauran(q);
      if (response.restaurants.isEmpty) {
        _resultState = ResultState.Empty;
        notifyListeners();
        return message = emptyAnim;
      } else {
        _resultState = ResultState.Loaded;
        notifyListeners();
        return _restaurants = response;
      }
    } on SocketException {
      _resultState = ResultState.NoConnection;
      notifyListeners();
      return message = animNoInternet;
    } on ServerException catch (e) {
      _resultState = ResultState.Error;
      notifyListeners();
      return message = e.message;
    }
  }
}
