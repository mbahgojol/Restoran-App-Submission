import 'dart:io';

import 'package:flutter/material.dart';
import 'package:restoran_submision/data/model/restaurants.dart';
import 'package:restoran_submision/utils/constants.dart';

import '../../data/api/api_service.dart';
import '../../utils/exception.dart';
import '../../utils/result_state.dart';

class HomePageProvider extends ChangeNotifier {
  final ApiService apiService;

  HomePageProvider({required this.apiService}) {
    _fetchRestauran();
  }

  late Restaurants _restaurants;

  Restaurants get restaurants => _restaurants;

  late ResultState _resultState = ResultState.Empty;

  ResultState get resultState => _resultState;
  late String message = '';

  Future<dynamic> _fetchRestauran() async {
    try {
      _resultState = ResultState.Loading;
      notifyListeners();
      final response = await apiService.listRestauran();
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
