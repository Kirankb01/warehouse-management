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

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 4;
    if (width >= 800) return 3;
    return 2;
  }

  double _getChildAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width >= 1200) return 1.2;
    if (width >= 800) return 1.2;
    return 0.83;
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
              child: _filteredProducts.isEmpty
                  ? Center(
                child: Text(
                  'No items found',
                  style: TextStyle(color: AppThemeHelper.textColor(context)),
                ),
              )
                  : isGridView
                  ? GridView.builder(
                itemCount: _filteredProducts.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _getCrossAxisCount(context),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: _getChildAspectRatio(context),
                ),
                itemBuilder: (context, index) =>
                    ProductGridItem(product: _filteredProducts[index]),
              )
                  : ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) =>
                    ProductListItem(product: _filteredProducts[index]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
