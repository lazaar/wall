import 'package:blankwallpaper/screens/wallpaper.dart';
import 'package:flutter/material.dart';
import 'package:blankwallpaper/modals/category.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blankwallpaper/bloc/change_theme_bloc.dart';
import 'package:blankwallpaper/bloc/change_theme_state.dart';

class CategoryPage extends StatelessWidget {
  final Category category;
  CategoryPage({this.category});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
        ThemeData _themeData = state.themeData;
        return Theme(
          data: state.themeData,
          child: Scaffold(
            appBar: AppBar(
                centerTitle: true,
                elevation: 5,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    Text(
                      'Wallpapers',
                      style: state.themeData.textTheme.headline,
                    )
                  ],
                ),
                backgroundColor: state.themeData.primaryColor),
            body: Container(
              color: state.themeData.primaryColor,
              child: Container(
                color: state.themeData.primaryColor,
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ListView.builder(
                        itemCount: category.wallpapers.length,
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
                                              heroId: 'category$index',
                                              imageUrl: category
                                                  .wallpapers[index].url,
                                              name: category
                                                  .wallpapers[index].name,
                                              themeData: _themeData,
                                            )));
                              },
                              child: Hero(
                                tag: 'category$index',
                                child: Container(
                                  width: double.infinity,
                                  height: 200,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: FadeInImage(
                                      image: NetworkImage(
                                          category.wallpapers[index].url),
                                      fit: BoxFit.cover,
                                      placeholder: AssetImage(
                                          'assets/images/loading.gif'),
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
              ),
            ),
          ),
        );
      },
    );
  }
}
