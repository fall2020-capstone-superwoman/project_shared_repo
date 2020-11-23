import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import './recipeinputsearch.dart';
import './recipeslist.dart';
import './biopage2.dart';
import './detailpage.dart';

class TabNavigationItem {
  final Widget page;
  final String title;
  final Icon icon;

  TabNavigationItem({
    @required this.page,
    @required this.title,
    @required this.icon,
  });

  static List<TabNavigationItem> get items => [
    TabNavigationItem(
      page: BioPage(),
      icon: Icon(Icons.face),
      title: "My Details",
    ),
    TabNavigationItem(
      page: RecipeInputPage(),
      icon: Icon(Icons.add_box),
      title: "Search Recipes",
    ),
    TabNavigationItem(
      page: ListViewPage(),
      icon: Icon(Icons.assignment_returned_rounded),
      title: "Saved Recipes",
    ),
  ];
}
