import 'package:flutter/material.dart';
import 'package:warehouse_management/constants/app_colors.dart';
import 'package:warehouse_management/constants/app_text_styles.dart';


class EditAccountDetails extends StatelessWidget {
  const EditAccountDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        title: Text('Organization Profile', style: AppTextStyles.appBarText),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 25),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    backgroundColor: AppColors.summaryContainer,
                    content: Text('Updated successfully!'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              child: Text(
                'Save',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: MediaQuery.of(context).size.width < 600 ? 16 : 22,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                height: 600,
                child: Card(
                  color: AppColors.card,
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.other_houses_outlined,
                              size: 20,
                            ),
                            SizedBox(width: 10),
                            Text('Organization Name'),
                          ],
                        ),
                        TextFormField(
                          decoration: InputDecoration(),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.email, size: 20,),
                            SizedBox(width: 10),
                            Text('Registered Email'),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.access_time, size: 20,),
                            SizedBox(width: 10),
                            Text('Time Zone'),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.date_range, size: 20,),
                            SizedBox(width: 10),
                            Text('Date Format'),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.language, size: 20,),
                            SizedBox(width: 10),
                            Text('Country'),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 20),
                        Row(
                          children: [
                            Icon(Icons.attach_money, size: 20,),
                            SizedBox(width: 10),
                            Text('Currency'),
                          ],
                        ),

                        TextFormField(
                          decoration: InputDecoration(),
                          keyboardType: TextInputType.text,
                        ),

                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
