import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:blankwallpaper/bloc/change_theme_bloc.dart';
import 'package:blankwallpaper/bloc/change_theme_state.dart';
import 'package:blankwallpaper/screens/category.dart';
import 'package:blankwallpaper/services/getData.dart';
import 'package:blankwallpaper/screens/main_page.dart';
import 'package:blankwallpaper/screens/settings.dart';
import 'package:blankwallpaper/utils/exapndingnav.dart';
import 'package:flutter/material.dart';
import 'package:blankwallpaper/modals/categoryList.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var pageIndex = 0;
  PageController pageController = PageController();
  CategoryList categoryList;

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void fetchData() async {
    categoryList = await loadCategories();
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder(
      bloc: changeThemeBloc,
      builder: (BuildContext context, ChangeThemeState state) {
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
              child: PageView(
                  physics: BouncingScrollPhysics(),
                  controller: pageController,
                  onPageChanged: onPageChanged,
                  children: <Widget>[
                    MainBody(
                      categoryList: categoryList,
                    ),
                    Category(
                      categoryList: categoryList,
                    ),
                    SettingsPage(),
                  ]),
            ),
            bottomNavigationBar: ExpandingBottomBar(
              backgroundColor: state.themeData.primaryColor,
              navBarHeight: 60.0,
              items: [
                ExpandingBottomBarItem(
                  icon: Icons.home,
                  text: "Home",
                  selectedColor: state.themeData.accentColor,
                ),
                ExpandingBottomBarItem(
                  icon: Icons.category,
                  text: "Categories",
                  selectedColor: state.themeData.accentColor,
                ),
                ExpandingBottomBarItem(
                  icon: Icons.settings,
                  text: "Settings",
                  selectedColor: state.themeData.accentColor,
                ),
              ],
              selectedIndex: pageIndex,
              onIndexChanged: navigationTapped,
            ),
          ),
        );
      },
    );
  }

  void onPageChanged(int value) {
    setState(() {
      pageIndex = value;
    });
  }

  void navigationTapped(int value) {
    pageController.animateToPage(value,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
  }
}
