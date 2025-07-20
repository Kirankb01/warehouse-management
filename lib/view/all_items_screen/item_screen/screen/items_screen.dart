import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/popup_menu.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/product_grid_item.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/product_list_item.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/search_filter_row.dart';
import 'package:warehouse_management/viewmodel/product_provider.dart';

class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool isGridView = false;
  String? _selectedBrand;
  String _sortOption = '';
  List<Product> _filteredProducts = [];
  String searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final productProvider = Provider.of<ProductProvider>(context);
    _filteredProducts = List.from(productProvider.products);
  }

  void _applyFiltersAndSorting(ProductProvider productProvider) {
    final products = filterAndSortProducts(
      products: productProvider.products,
      selectedBrand: _selectedBrand,
      sortOption: _sortOption,
      searchQuery: searchQuery,
    );

    setState(() {
      _filteredProducts = products;
    });
  }


  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: AppThemeHelper.scaffoldBackground(context),
      appBar: AppBar(
        backgroundColor: AppThemeHelper.scaffoldBackground(context),
        title: Text('Items', style: AppTextStyles.appBarText),
        actions: [
          AddOptionsPopupMenu(
            productProvider: productProvider,
            onItemAdded: () => _applyFiltersAndSorting(productProvider),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SearchFilterRow(
              selectedBrand: _selectedBrand,
              sortOption: _sortOption,
              isGridView: isGridView,
              onToggleView: (val) => setState(() => isGridView = val),
              onSearch: (val) {
                setState(() => searchQuery = val.toLowerCase());
                _applyFiltersAndSorting(productProvider);
              },
              onFilterChange: (brand, sort) {
                setState(() {
                  _selectedBrand = brand;
                  _sortOption = sort;
                });
                _applyFiltersAndSorting(productProvider);
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final maxWidth = constraints.maxWidth;

                  int crossAxisCount;
                  double itemHeight;

                  if (maxWidth >= 1024) {
                    crossAxisCount = 5;
                    itemHeight = 280;
                  } else if (maxWidth >= 600) {
                    crossAxisCount = 3;
                    itemHeight = 245;
                  } else {
                    crossAxisCount = 2;
                    itemHeight = 230;
                  }

                  final itemWidth = maxWidth / crossAxisCount;
                  final childAspectRatio = itemWidth / itemHeight;

                  if (_filteredProducts.isEmpty) {
                    return Center(
                      child: Text(
                        'No items found',
                        style: TextStyle(color: AppThemeHelper.textColor(context)),
                      ),
                    );
                  }

                  return isGridView
                      ? GridView.builder(
                    itemCount: _filteredProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: childAspectRatio,
                    ),
                    itemBuilder: (context, index) =>
                        ProductGridItem(product: _filteredProducts[index]),
                  )
                      : ListView.builder(
                    itemCount: _filteredProducts.length,
                    itemBuilder: (context, index) =>
                        ProductListItem(product: _filteredProducts[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
