import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_assistant/service/category_firestore_service.dart';
import 'package:my_assistant/utils/constants.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key, required this.category});

  final QueryDocumentSnapshot category;

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _nameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedTemplate;

  Map? selectedTemplateType;

  void addProduct() async {
    try {
      DialogModel.showLoader(context);

      await CategoryFirestoreService.addProduct(
        widget.category.id,
        name: _nameC.text,
        templateType: "${widget.category['templateType']}",
        icon: selectedTemplate!,
      );
      DialogModel.hideLoader(context);

      DialogModel.showSnackBar(context, "Product Added!");

      Navigator.pop(context);
    } catch (e) {
      DialogModel.hideLoader(context);
    }
  }

  @override
  void initState() {
    super.initState();

    for (var element in AppConstants.templateType) {
      if (element['title'] == widget.category['templateType']) {
        selectedTemplateType = element;
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add ${widget.category['name']}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${widget.category['name']} Name :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _nameC,
                validator: (value) =>
                    Validators.requiredValidation(value!, "Name"),
                decoration: InputDecoration(hintText: "Name of My Product"),
              ),
              SizedBox(height: 20),
              Text(
                "Select Icon :",
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
                  if (selectedTemplateType != null)
                    for (var icon in selectedTemplateType!['icons'])
                      DropdownMenuItem<String>(
                          value: icon,
                          child: Row(
                            children: [
                              Icon(MdiIcons.fromString(icon)),
                              SizedBox(width: 10),
                              Text(icon),
                            ],
                          )),
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

                    addProduct();
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
