import 'package:flutter/material.dart';

import '../utils/const.dart';

class SelectCategory extends StatefulWidget {
  final Function(List<String>) onTap; // Modify to accept a List<String> parameter

  SelectCategory({Key? key, required this.onTap}) : super(key: key);

  @override
  State<SelectCategory> createState() => _SelectCategoryState();
}

class _SelectCategoryState extends State<SelectCategory> {
  var selectedCategoriesUrls = <String>[]; // List to store selected URLs
  late List<String> categories;

  // Dynamically initialize the isSelected list based on categories
  late List<bool> isSelected;

  @override
  void initState() {
    super.initState();
    categories = getCategoryList(); // Fetch the category list
    isSelected = List<bool>.filled(categories.length, false); // Initialize selection state
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4),
      height: 50, // Height of the horizontal list
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                // Toggle the selection state of the category
                isSelected[index] = !isSelected[index];
              });

              // Add or remove URLs based on the category's selection state
              if (isSelected[index]) {
                for (String url in getRssUrlList(categories[index])) {
                  selectedCategoriesUrls.add(url);
                }
              } else {
                for (String url in getRssUrlList(categories[index])) {
                  selectedCategoriesUrls.remove(url);
                }
              }

              // Send the updated list of selected URLs to the previous page
              widget.onTap(selectedCategoriesUrls);
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 2.0),
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: isSelected[index] ? THEME_COLOR : Colors.blue,
                borderRadius: BorderRadius.circular(25.0),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  fontSize: getTextSize(context, 14),
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
