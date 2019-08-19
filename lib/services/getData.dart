import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';
import 'package:blankwallpaper/modals/categoryList.dart';

Future<String> _loadACategoriesAsset() async {
  return await rootBundle.loadString('./assets/data/wallpapers.json');
}

Future loadCategories() async {
  String jsonString = await _loadACategoriesAsset();
  final jsonResponse = json.decode(jsonString);
  CategoryList categoryList = new CategoryList.fromJson(jsonResponse);
  return categoryList;
}
