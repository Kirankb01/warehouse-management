import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/all_items_screen/add_item_screen/screen/add_item.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/product_grid_item.dart';
import 'package:warehouse_management/view/all_items_screen/item_screen/widgets/product_list_item.dart';
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
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              color: AppThemeHelper.cardColor(context),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: Icon(Icons.add, color: AppThemeHelper.iconColor(context)),
              tooltip: 'Add options',
              elevation: 8,
              onSelected: (value) {
                if (value == 'item') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (ctx) => const AddItem()),
                  ).then((_) {
                    productProvider.loadProducts();
                    _applyFiltersAndSorting(productProvider);
                  });
                } else if (value == 'brand') {
                  showAddBrandDialog(context);
                } else if (value == 'delete_brand') {
                  showDeleteBrandDialog(context);
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'item',
                  child: Row(
                    children: [
                      Icon(
                        Icons.inventory_2_outlined,
                        color: AppThemeHelper.popupMenuIconColor(context),
                      ),
                      const SizedBox(width: 10),
                      Text('Add New Item'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'brand',
                  child: Row(
                    children: [
                      Icon(
                        Icons.branding_watermark,
                        color: AppThemeHelper.popupMenuIconColor(context),
                      ),
                      const SizedBox(width: 10),
                      Text('Add New Brand'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete_brand',
                  child: Row(
                    children: [
                      Icon(Icons.delete_forever, color: AppThemeHelper.iconColor(context)),
                      const SizedBox(width: 10),
                      Text('Delete Brand'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Item Name, SKU',
                      prefixIcon: Icon(Icons.search, color: AppThemeHelper.iconColor(context)),
                      filled: true,
                      fillColor: AppThemeHelper.inputFieldBackground(context),
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    style: TextStyle(color: AppThemeHelper.textColor(context)),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.toLowerCase();
                      });
                      _applyFiltersAndSorting(productProvider);
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 11, right: 5),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          showFilterOptions(
                            context: context,
                            selectedBrand: _selectedBrand,
                            sortOption: _sortOption,
                            onFilterChanged: (brand, sort) {
                              setState(() {
                                _selectedBrand = brand;
                                _sortOption = sort;
                              });
                              _applyFiltersAndSorting(productProvider);
                            },
                          );
                        },
                        child: Icon(Icons.filter_alt_outlined, color: AppThemeHelper.iconColor(context)),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isGridView = !isGridView;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: Icon(
                            isGridView ? Icons.list : Icons.grid_view,
                            color: AppThemeHelper.iconColor(context),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
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
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 3 / 3.5,
                ),
                itemBuilder: (context, index) {
                  return ProductGridItem(
                    product: _filteredProducts[index],
                  );
                },
              )
                  : ListView.builder(
                itemCount: _filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = _filteredProducts[index];
                  return ProductListItem(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
