import 'package:flutter/material.dart';
import 'package:blankwallpaper/modals/categoryList.dart';
import 'package:blankwallpaper/screens/category_page.dart';

class Category extends StatelessWidget {
  final CategoryList categoryList;
  Category({this.categoryList});

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width / 2;
    return Container(
        color: Theme.of(context).primaryColor,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Categories',
                        style: Theme.of(context).textTheme.body1),
                  ),
                ],
              ),
              GridView.builder(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                itemCount: categoryList.categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoryPage(
                                    category: categoryList.categories[index])));
                      },
                      child: Column(
                        children: <Widget>[
                          Card(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Container(
                              width: _width,
                              height: _width - 50,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: FadeInImage(
                                  image: NetworkImage(
                                      categoryList.categories[index].thumbnail),
                                  fit: BoxFit.cover,
                                  placeholder:
                                      AssetImage('assets/images/loading.gif'),
                                ),
                              ),
                            ),
                          ),
                          Text(categoryList.categories[index].name,
                              style: Theme.of(context).textTheme.body2),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }
}
