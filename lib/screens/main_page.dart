import 'package:blankwallpaper/screens/wallpaper.dart';
import 'package:blankwallpaper/utils/widgets.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:blankwallpaper/modals/categoryList.dart';
import 'package:blankwallpaper/modals/wallpaper.dart';
import 'package:blankwallpaper/screens/category_page.dart';

class MainBody extends StatelessWidget {
  final CategoryList categoryList;
  MainBody({this.categoryList});

  @override
  Widget build(BuildContext context) {
    ThemeData _themeData = Theme.of(context);
    if (categoryList == null) {
      return Container();
    }
    final List<Wallpaper> _trendingImages = categoryList.trending;
    final List<Wallpaper> _popularImages = categoryList.popular;

    return Container(
      color: Theme.of(context).primaryColor,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ShowMore(
                text: 'Trending',
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryPage(
                              category: categoryList.allCategory)));
                }),
            CarouselSlider(
              autoPlay: true,
              height: 200.0,
              items: _trendingImages
                  .asMap()
                  .map((i, item) => MapEntry(i, Builder(
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => WallpaperPage(
                                                heroId: 'trending$i',
                                                name: item.name,
                                                imageUrl: item.url,
                                                themeData: _themeData,
                                              )));
                                },
                                child: Hero(
                                  tag: 'trending$i',
                                  child: Container(
                                    width: double.infinity,
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(8.0),
                                      child: FadeInImage(
                                        image: NetworkImage(item.url),
                                        fit: BoxFit.cover,
                                        placeholder: AssetImage(
                                            'assets/images/loading.gif'),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )))
                  .values
                  .toList(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Popular',
                style: Theme.of(context).textTheme.body1,
              ),
            ),
            ListView.builder(
              itemCount: _popularImages.length,
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => WallpaperPage(
                                    heroId: 'popular$index',
                                    imageUrl: _popularImages[index].url,
                                    name: _popularImages[index].name,
                                    themeData: _themeData,
                                  )));
                    },
                    child: Hero(
                      tag: 'popular$index',
                      child: Container(
                        width: double.infinity,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: FadeInImage(
                            image: NetworkImage(_popularImages[index].url),
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage('assets/images/loading.gif'),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
