class Wallpaper {
  String name;
  String url;
  bool isTrending;
  bool isPopular;

  Wallpaper({this.name, this.url, this.isTrending, this.isPopular});

  factory Wallpaper.fromJson(Map<String, dynamic> parsedJson) {
    return Wallpaper(
        name: parsedJson['name'],
        url: parsedJson['url'],
        isTrending: parsedJson['isTrending'],
        isPopular: parsedJson['isPopular']);
  }
}
