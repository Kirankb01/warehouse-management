import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:warehouse_management/Screens/addItem.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';
import 'package:warehouse_management/models/product.dart';
import 'package:warehouse_management/providers/product_provider.dart';
import 'package:warehouse_management/utils/helpers.dart';
import 'package:warehouse_management/widgets/product_grid_item.dart';
import 'package:warehouse_management/widgets/product_list_item.dart';


class ItemsScreen extends StatefulWidget {
  const ItemsScreen({super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  bool isGridView = false;
  String? _selectedBrand; // For filtering by brand
  String _sortOption = ''; // For sorting choice

  // To hold filtered and sorted list
  List<Product> _filteredProducts = [];
  String searchQuery = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Load products initially with no filters
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
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.only(right: 15, top: 5),
              child: Icon(Icons.add),
            ),
            onTap: () async {
              // Navigate to add item screen and wait for result
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const AddItem()),
              );
              // After returning, reload products and re-apply filters/sorting
              productProvider.loadProducts();
              _applyFiltersAndSorting(productProvider);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            // Search bar placeholder (You can add search later)
            Row(
              children: [
                Flexible(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search Item Name, SKU',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
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
                          _showFilterOptions(productProvider);
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


  void _showFilterOptions(ProductProvider productProvider) {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Wrap(
            children: [
              const Text(
                'Filter Options',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              ListTile(
                title: const Text('Sort by Name (A-Z)'),
                onTap: () {
                  _sortOption = 'name_asc';
                  Navigator.pop(context);
                  _applyFiltersAndSorting(productProvider);
                },
                selected: _sortOption == 'name_asc',
              ),
              ListTile(
                title: const Text('Sort by Stock (High to Low)'),
                onTap: () {
                  _sortOption = 'stock_desc';
                  Navigator.pop(context);
                  _applyFiltersAndSorting(productProvider);
                },
                selected: _sortOption == 'stock_desc',
              ),
              ListTile(
                title: const Text('Low Stock (< 10)'),
                onTap: () {
                  _sortOption = 'low_stock';
                  Navigator.pop(context);
                  _applyFiltersAndSorting(productProvider);
                },
                selected: _sortOption == 'low_stock',
              ),
              ListTile(
                title: const Text('Filter by Brand'),
                onTap: () {
                  Navigator.pop(context);
                  _showBrandFilterDialog(productProvider);
                },
              ),
              ListTile(
                title: const Text('Clear Filters'),
                onTap: () {
                  _sortOption = '';
                  _selectedBrand = null;
                  Navigator.pop(context);
                  _applyFiltersAndSorting(productProvider);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBrandFilterDialog(ProductProvider productProvider) {
    final uniqueBrands =
        productProvider.products.map((p) => p.brand).toSet().toList();

    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            children: [
              const Text(
                'Available Brands',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Divider(),
              ...uniqueBrands.map(
                (brand) => ListTile(
                  title: Text(brand),
                  selected: _selectedBrand == brand,
                  onTap: () {
                    _selectedBrand = brand;
                    Navigator.pop(context);
                    _applyFiltersAndSorting(productProvider);
                  },
                ),
              ),
              ListTile(
                title: const Text('Clear Brand Filter'),
                onTap: () {
                  _selectedBrand = null;
                  Navigator.pop(context);
                  _applyFiltersAndSorting(productProvider);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
