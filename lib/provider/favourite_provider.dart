import 'package:flutter/material.dart';
class FavouriteProvider extends ChangeNotifier {
  List<int> favourite=[];
  List<int> get fav => favourite;
  void toggleFavourite(int fav) {
    final isExist=favourite.contains(fav);
    if(isExist) {
      favourite.remove(fav);
    } else {
      favourite.add(fav);
    }
    notifyListeners();
  }

  bool isExist(int fav) {
    final isExist=favourite.contains(fav);
    return isExist;
  }
  void clearFavourite() {
    favourite=[];
    notifyListeners();
  }
}