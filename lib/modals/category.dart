import 'package:blankwallpaper/modals/wallpaper.dart';

class Category {
  String name;
  String thumbnail;
  List<Wallpaper> wallpapers;

  Category({this.name, this.thumbnail, this.wallpapers});

  List<Wallpaper> getTrending() {
    return wallpapers.where((item) => item.isTrending).toList();
  }

  List<Wallpaper> getPopular() {
    return wallpapers.where((item) => item.isPopular).toList();
  }

  factory Category.fromJson(Map<String, dynamic> parsedJson) {
    var list = parsedJson['wallpapers'] as List;
    List<Wallpaper> imagesList =
        list.map((i) => Wallpaper.fromJson(i)).toList();

    return Category(
        name: parsedJson['category'],
        thumbnail: parsedJson['thumbnail'],
        wallpapers: imagesList);
  }
}
