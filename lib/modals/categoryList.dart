import 'package:blankwallpaper/modals/category.dart';
import 'package:blankwallpaper/modals/wallpaper.dart';

class CategoryList {
  List<Category> categories;
  List<Wallpaper> trending = new List();
  List<Wallpaper> popular = new List();
  Category allCategory;

  CategoryList(List<Category> categories) {
    this.categories = categories;
    List<Wallpaper> allWallpapers = new List();

    for (var item in categories) {
      trending.addAll(item.getTrending());
      popular.addAll(item.getPopular());
      allWallpapers.addAll(item.wallpapers);
    }
    allWallpapers.shuffle();
    allCategory = new Category(
        name: "all",
        thumbnail:
            "https://image.freepik.com/free-vector/abstract-dynamic-pattern-wallpaper-vector_53876-43459.jpg",
        wallpapers: allWallpapers);
  }

  List<Category> getAll() {
    return null;
  }

  factory CategoryList.fromJson(List<dynamic> parsedJson) {
    List<Category> categories =
        parsedJson.map((i) => Category.fromJson(i)).toList();

    return CategoryList(categories);
  }
}
