import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/features/product/models/category.dart';

import '../screen/products_list_screen.dart';

class CategorySearchDelegate extends SearchDelegate {
// ----------index page 1

  List<Category>? searchData = [];
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Category> matchQuery = [];
    for (var fruit in searchData!) {
      if (fruit.name.toLowerCase().trim().contains(query.toLowerCase()) ||
          // fruit.category.name .toLowerCase().trim().contains(query.toLowerCase()) ||
          fruit.description
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase()) ||
          fruit.discount
              .toString()
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }

    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getCategoryFutureProvider).when(
              data: (data) {
                searchData = data;

                return ListView.builder(
                  itemCount: matchQuery.length,
                  itemBuilder: (context, index) {
                    var row = matchQuery[index];
                    if (matchQuery.isEmpty) {
                      // return const RequestAddedEstsharayWidget();
                    }
                    return ListTile(
                      title: Text(row.name),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsListScreen(
                              catId: row.id,
                              catName: row.name,
                            ),
                          )),
                    );
                  },
                );
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Category> matchQuery = [];
    for (var fruit in searchData!) {
      if (fruit.name.toLowerCase().trim().contains(query.toLowerCase()) ||
          // fruit.category.name .toLowerCase().trim().contains(query.toLowerCase()) ||
          fruit.description
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase()) ||
          fruit.discount
              .toString()
              .toLowerCase()
              .trim()
              .contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }

    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getCategoryFutureProvider).when(
              data: (data) {
                searchData = data;
                return ListView.builder(
                  itemCount: matchQuery.length,
                  itemBuilder: (context, index) {
                    var row = matchQuery[index];
                    if (matchQuery.isEmpty) {
                      // return const RequestAddedEstsharayWidget();
                    }
                    return ListTile(
                      title: Text(row.name),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductsListScreen(
                              catId: row.id,
                              catName: row.name,
                            ),
                          )),
                    );
                  },
                );
              },
              error: (err, trace) {
                return ErrorScreen(
                  error: err.toString(),
                );
              },
              loading: () => const Loader(),
            );
      },
    );
  }
}
