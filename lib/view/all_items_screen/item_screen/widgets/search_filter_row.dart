import 'package:flutter/material.dart';
import 'package:warehouse_management/theme/app_theme_helper.dart';
import 'package:warehouse_management/utils/helpers.dart';

class SearchFilterRow extends StatelessWidget {
  final String? selectedBrand;
  final String sortOption;
  final bool isGridView;
  final Function(bool) onToggleView;
  final Function(String) onSearch;
  final Function(String?, String) onFilterChange;

  const SearchFilterRow({
    super.key,
    required this.selectedBrand,
    required this.sortOption,
    required this.isGridView,
    required this.onToggleView,
    required this.onSearch,
    required this.onFilterChange,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search Item Name, SKU',
              prefixIcon: Icon(
                Icons.search,
                color: AppThemeHelper.iconColor(context),
              ),
              filled: true,
              fillColor: AppThemeHelper.inputFieldBackground(context),
              contentPadding: const EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
            style: TextStyle(color: AppThemeHelper.textColor(context)),
            onChanged: (value) => onSearch(value),
          ),
        ),
        const SizedBox(width: 11),
        IconButton(
          icon: Icon(
            Icons.filter_alt_outlined,
            color: AppThemeHelper.iconColor(context),
          ),
          onPressed: () {
            showFilterOptions(
              context: context,
              selectedBrand: selectedBrand,
              sortOption: sortOption,
              onFilterChanged: onFilterChange,
            );
          },
        ),
        IconButton(
          icon: Icon(
            isGridView ? Icons.list : Icons.grid_view,
            color: AppThemeHelper.iconColor(context),
          ),
          onPressed: () => onToggleView(!isGridView),
        ),
      ],
    );
  }
}
