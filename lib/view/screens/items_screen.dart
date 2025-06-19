import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/view/screens/add_item.dart';
import 'package:warehouse_management/view/widgets/product_grid_item.dart';
import 'package:warehouse_management/view/widgets/product_list_item.dart';
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Items', style: AppTextStyles.appBarText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: PopupMenuButton<String>(
              color: AppColors.pureWhite,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              icon: const Icon(Icons.add,color: AppColors.pureBlack),
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
              itemBuilder:
                  (context) => [
                    PopupMenuItem(
                      value: 'item',
                      child: Row(
                        children: const [
                          Icon(
                            Icons.inventory_2_outlined,
                            color: AppColors.popupMenuIconColor,
                          ),
                          SizedBox(width: 10),
                          Text('Add New Item'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'brand',
                      child: Row(
                        children: const [
                          Icon(Icons.branding_watermark, color: AppColors.popupMenuIconColor),
                          SizedBox(width: 10),
                          Text('Add New Brand'),
                        ],
                      ),
                    ),
                    PopupMenuItem(
                      value: 'delete_brand',
                      child: Row(
                        children: const [
                          Icon(Icons.delete_forever),
                          SizedBox(width: 10),
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
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: AppColors.pureWhite,
                      contentPadding: const EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25),
                        borderSide: BorderSide.none,
                      ),
                    ),
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
                        child: const Icon(Icons.filter_alt_outlined),
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
              child:
                  _filteredProducts.isEmpty
                      ? const Center(child: Text('No items found'))
                      : isGridView
                      ? GridView.builder(
                        itemCount: _filteredProducts.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 8,
                              crossAxisSpacing: 8,
                              childAspectRatio: 3 / 3,
                            ),
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ProductGridItem(product: product);
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
