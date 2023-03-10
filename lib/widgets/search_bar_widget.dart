import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/widgets/error.dart';
import 'package:myproject/common/widgets/loader.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/features/product/models/product.dart';
import 'package:myproject/features/product/screen/products_list_screen.dart';
import 'package:myproject/routes.dart';

class ProductSearchDelegate extends SearchDelegate {
// ----------index page 1

  List<Product>? searchData = [];
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
    List<Product> matchQuery = [];
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
              .contains(query.toLowerCase()) ||
          fruit.price.toString().trim().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }

    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getProductFutureProvider).when(
              data: (data) {
                searchData = data;

                return ListView.builder(
                  itemCount: matchQuery.length,
                  itemBuilder: (context, index) {
                    var product = matchQuery[index];
                    if (matchQuery.isEmpty) {
                      // return const RequestAddedEstsharayWidget();
                    }
                    return ListTile(
                      title: Text(product.name),
                      onTap: () {
                        onTap:
                        () => Navigator.pushNamed(
                              context,
                              product_details_screen,
                              arguments: product,
                            );
                      },
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
    List<Product> matchQuery = [];
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
              .contains(query.toLowerCase()) ||
          fruit.price.toString().trim().contains(query.toLowerCase())) {
        matchQuery.add(fruit);
      }
    }

    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(getProductFutureProvider).when(
              data: (data) {
                searchData = data;
                return ListView.builder(
                  itemCount: matchQuery.length,
                  itemBuilder: (context, index) {
                    var product = matchQuery[index];
                    if (matchQuery.isEmpty) {
                      // return const RequestAddedEstsharayWidget();
                    }
                    return ListTile(
                      title: Text(product.name),
                      onTap: () => Navigator.pushNamed(
                        context,
                        product_details_screen,
                        arguments: product,
                      ),
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
