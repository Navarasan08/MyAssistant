import 'package:flutter/material.dart';
import 'package:my_assistant/service/category_firestore_service.dart';
import 'package:my_assistant/utils/constants.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({super.key});

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _nameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedTemplate;

  void addCategory() async {
    try {
      DialogModel.showLoader(context);

      await CategoryFirestoreService.addCategory(
          name: _nameC.text, templateType: "$selectedTemplate");
      DialogModel.hideLoader(context);

      DialogModel.showSnackBar(context, "Category Added!");

      Navigator.pop(context);
    } catch (e) {
      DialogModel.hideLoader(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Category"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Category Name :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameC,
                validator: (value) =>
                    Validators.requiredValidation(value!, "Name"),
                decoration: InputDecoration(hintText: "Name of My Category"),
              ),
              SizedBox(height: 20),
              Text(
                "Select Template Type :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: selectedTemplate,
                isExpanded: true,
                decoration: InputDecoration(border: OutlineInputBorder()),
                validator: (value) =>
                    Validators.requiredValidation(value, "Template Type"),
                hint: Text("Select Any Type"),
                items: [
                  for (var template in AppConstants.templateType)
                    DropdownMenuItem<String>(
                        value: template['title'], child: Text(template['title'])),
                ],
                onChanged: (String? val) {
                  setState(() {
                    selectedTemplate = val;
                  });
                },
              ),
              SizedBox(height: 20),
              Center(
                child: CustomSubmitButton(
                  title: "Submit",
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) {
                      return;
                    }

                    addCategory();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
