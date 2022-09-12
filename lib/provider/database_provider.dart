import 'package:flutter/foundation.dart';
import 'package:restoran_submision/data/model/restaurants.dart';

import '../data/db/db_helper.dart';
import '../utils/constants.dart';
import '../utils/result_state.dart';

class DatabaseProvider extends ChangeNotifier {
  final DatabaseHelper databaseHelper;

  DatabaseProvider({required this.databaseHelper}) {
    _getFavorite();
  }

  late ResultState _state = ResultState.Nothing;

  ResultState get state => _state;

  String _message = '';

  String get message => _message;

  List<Restaurant> _restaurans = [];

  List<Restaurant> get restaurans => _restaurans;

  void _getFavorite() async {
    _restaurans = await databaseHelper.getFavorites();
    if (_restaurans.isNotEmpty) {
      _state = ResultState.Loaded;
    } else {
      _state = ResultState.Empty;
      _message = emptyAnim;
    }
    notifyListeners();
  }

  void addFavorite(Restaurant restaurant) async {
    try {
      await databaseHelper.insertFavorites(restaurant);
      _getFavorite();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }

  Future<bool> isFavorite(String id) async {
    final bookmarkedRestauran = await databaseHelper.getFavoriteById(id);
    return bookmarkedRestauran.isNotEmpty;
  }

  void removeFavorite(String id) async {
    try {
      await databaseHelper.removeFavorite(id);
      _getFavorite();
    } catch (e) {
      _state = ResultState.Error;
      _message = 'Error: $e';
      notifyListeners();
    }
  }
}
