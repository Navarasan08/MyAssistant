import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_assistant/utils/colors.dart';

class AppConstants {
  AppConstants._();

  static const List<String> viewMode = ["Table", "List", "Goal"];
  static const List<String> fieldType = ["String", "int", "date"];
  static const List<Map> templateType = [
    {
      "title": "automobile",
      "icons": [
        "bike",
        "car",
      ],
    },
    {
      "title": "notes",
      "icons": [],
    },
    {
      "title": "checklist",
      "icons": [
        "noteCheckOutline",
        "notebookEditOutline",
        "notebookMultiple",
        "notebookPlusOutline"
      ],
    },
    {
      "title": "expense",
      "icons": [],
    },
  ];

  static const String initialViewMode = "Table";
  static const String initialFieldType = "String";
  static const int tableFieldCount = 5;

  static OutlineInputBorder inputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(7),
    borderSide: BorderSide(
      width: 2,
      color: AppColors.lightNavyBlue,
    ),
  );

  static InputDecoration get inputDecoration => InputDecoration(
        border: inputBorder,
        disabledBorder: inputBorder,
        errorBorder: inputBorder.copyWith(
          borderSide: BorderSide(
            width: 2,
            color: AppColors.red,
          ),
        ),
        enabledBorder: inputBorder,
        focusedBorder: inputBorder,
        focusedErrorBorder: inputBorder,
        hintText: "Event Title",
        hintStyle: TextStyle(
          color: AppColors.black,
          fontSize: 17,
        ),
        labelStyle: TextStyle(
          color: AppColors.black,
          fontSize: 17,
        ),
        helperStyle: TextStyle(
          color: AppColors.black,
          fontSize: 17,
        ),
        errorStyle: TextStyle(
          color: AppColors.red,
          fontSize: 12,
        ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
      );
}

class BreakPoints {
  static const double web = 800;
}
