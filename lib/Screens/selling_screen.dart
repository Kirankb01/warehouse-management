import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final TextEditingController customerNameController = TextEditingController();
  final List<Map<String, TextEditingController>> items = [];

  final List<String> itemList = [
    'Mouse',
    'Keyboard',
    'Monitor',
    'Printer',
    'Scanner',
    'UPS',
  ];

  double total = 0.0;

  @override
  void initState() {
    super.initState();
    _addNewItem();
  }

  void _addNewItem() {
    final product = TextEditingController();
    final quantity = TextEditingController();
    final price = TextEditingController();

    quantity.addListener(_calculateTotal);
    price.addListener(_calculateTotal);

    setState(() {
      items.add({
        'product': product,
        'quantity': quantity,
        'price': price,
      });
    });

    _calculateTotal();
  }

  void _removeItem(int index) {
    items[index]['quantity']!.removeListener(_calculateTotal);
    items[index]['price']!.removeListener(_calculateTotal);

    setState(() {
      items.removeAt(index);
    });

    _calculateTotal();
  }

  void _calculateTotal() {
    double newTotal = 0.0;
    for (var item in items) {
      final qty = int.tryParse(item['quantity']!.text) ?? 0;
      final price = double.tryParse(item['price']!.text) ?? 0.0;
      newTotal += qty * price;
    }

    setState(() {
      total = newTotal;
    });
  }

  void _submitSale() {
    final customerName = customerNameController.text.trim();

    if (customerName.isEmpty) {
      _showSnackBar("Please enter customer name");
      return;
    }

    bool hasInvalid = items.any((item) =>
    item['product']!.text.trim().isEmpty ||
        int.tryParse(item['quantity']!.text) == null ||
        double.tryParse(item['price']!.text) == null);

    if (hasInvalid) {
      _showSnackBar("Please enter valid product details");
      return;
    }

    // Capture sale date and time
    DateTime saleDateTime = DateTime.now();

    // Example: You can print or send this data to DB
    print("Sale date and time: $saleDateTime");

    _showSnackBar("Sale submitted successfully! Total: ₹${total.toStringAsFixed(2)}");

    // Clear fields
    customerNameController.clear();
    for (var item in items) {
      item['product']!.clear();
      item['quantity']!.clear();
      item['price']!.clear();
    }
    _calculateTotal();
  }


  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _selectProduct(int index) async {
    final TextEditingController searchController = TextEditingController();
    List<String> filteredList = List.from(itemList);

    final selected = await showModalBottomSheet<String>(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.only(top: 20, left: 16, right: 16, bottom: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: 'Search product...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() {
                        filteredList = itemList
                            .where((item) => item.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 300),
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredList.length,
                      itemBuilder: (context, i) {
                        return ListTile(
                          title: Text(filteredList[i]),
                          onTap: () => Navigator.pop(context, filteredList[i]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );

    if (selected != null) {
      setState(() {
        items[index]['product']!.text = selected;
      });
    }
  }


  Widget _buildItemForm(int index) {
    final item = items[index];
    return Card(
      color: Colors.white,
      margin: EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () => _selectProduct(index),
              child: AbsorbPointer(
                child: TextField(
                  controller: item['product'],
                  decoration: InputDecoration(
                    labelText: 'Select Product',
                    suffixIcon: Icon(Icons.arrow_drop_down),
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: item['quantity'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Quantity'),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: item['price'],
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Price (₹)'),
                  ),
                ),
                if (items.length > 1)
                  IconButton(
                    onPressed: () => _removeItem(index),
                    icon: Icon(Icons.delete, color: Colors.red),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    customerNameController.dispose();
    for (var item in items) {
      item['product']!.dispose();
      item['quantity']!.dispose();
      item['price']!.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Sell Products', style: AppTextStyles.appBarText),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            TextField(
              controller: customerNameController,
              decoration: InputDecoration(labelText: 'Customer Name'),
            ),
            SizedBox(height: 20),
            Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...List.generate(items.length, (index) => _buildItemForm(index)),
            SizedBox(height: 10),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white
              ),
              onPressed: _addNewItem,
              icon: Icon(Icons.add,color: Colors.blueGrey,),
              label: Text('Add Another Item',style: TextStyle(color: Colors.blueGrey),),
            ),
            Divider(height: 30, thickness: 1),
            Text(
              'Total Price: ₹${total.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: _submitSale,
              icon: Icon(Icons.check_circle),
              label: Text('Submit Sale'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 16),
                textStyle: TextStyle(fontSize: 16),
              ),
            ),
            SizedBox(
              height: 50,
            )
          ],
        ),
      ),
    );
  }
}
