import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myproject/common/utils/colors.dart';
import 'package:myproject/features/product/controller/category_controller.dart';
import 'package:myproject/features/product/widgets/category_search_delegate.dart';
import 'package:myproject/widgets/list_tile_animation_widget.dart';
import 'package:myproject/widgets/nodata_widget.dart';
import '../../../common/utils/utils.dart';
import '../../../common/widgets/error.dart';
import '../../../common/widgets/loader.dart';
import '../../../widgets/image_rect_widget.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'products_list_screen.dart';

class CategoryScreen extends ConsumerStatefulWidget {
  static const String routeName = '/category-screen';

  @override
  ConsumerState<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends ConsumerState<CategoryScreen> {
  ScrollController scrollController1 = ScrollController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SelectableText(
          'التصنيفات',
          style: TextStyle(color: textColor),
        ),
        actions: [
          IconButton(
              onPressed: () {
                msgShow(
                  'البحث متقدم',
                );
                showSearch(
                  context: context,
                  delegate: CategorySearchDelegate(),
                );
              },
              icon: Icon(
                Icons.search,
              )),
        ],
      ),
      body: ref.watch(getCategoryFutureProvider).when(
            data: (dataList) {
              if (dataList == null) {
                return const NoDataWidget();
              }

              return Scrollbar(
                thickness: 7,
                scrollbarOrientation: ScrollbarOrientation.right,
                interactive: true,
                radius: Radius.circular(30),
                controller: scrollController1,
                thumbVisibility: true,
                child: AnimationLimiter(
                  child: ListView.builder(
                    physics: BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    key: PageStorageKey<String>('catPg'),
                    itemCount: dataList.length,
                    controller: scrollController1,
                    itemBuilder: (context, index) {
                      var row = dataList[index];
                      return ListTileAnimation(
                        index: index,
                        child: ImageWidget(
                          row.name,
                          path: row.image,
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductsListScreen(
                                  catId: dataList[index].id,
                                  catName: dataList[index].name,
                                ),
                              )),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
            error: (err, trace) {
              return ErrorScreen(
                error: err.toString(),
              );
            },
            loading: () => const Loader(),
          ),
    );
  }
}
