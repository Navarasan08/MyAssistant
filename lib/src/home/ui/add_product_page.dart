// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/utils/constants.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key, this.existProduct});

  final QueryDocumentSnapshot? existProduct;

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _nameC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Stream<QuerySnapshot>? iconStream;
  String? iconName;
  String viewMode = AppConstants.initialViewMode;
  bool isAddOption = true;

  @override
  void initState() {
    super.initState();

    iconStream = FirestoreService.getIcons();

    if (widget.existProduct != null) {
      Product _product = Product.fromFirestoreJson(widget.existProduct!.id,
          widget.existProduct!.data() as Map<String, dynamic>);
      isAddOption = false;
      _nameC.text = _product.name ?? "";
      iconName = _product.icon;
      viewMode = _product.viewMode!;
    }
  }

  @override
  void dispose() {
    super.dispose();
    iconStream = null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New App"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Center(
            child: SizedBox(
              width: ResponsiveWidget.isWeb(context) ? size.width / 3 : size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Select View :",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    value: viewMode,
                    hint: Text(
                      "Select View Mode",
                    ),
                    validator: (value) =>
                        Validators.requiredValidation(value, "View Mode"),
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    items: AppConstants.viewMode
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      if (!isAddOption) {
                        DialogModel.showSnackBar(
                            context, "View Mode cannot be changed");
                        return;
                      }
                      setState(() {
                        viewMode = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 15),
                  Text(
                    "Select Icon :",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                      stream: iconStream,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return DropdownButtonFormField<String>(
                            value: iconName,
                            isExpanded: true,
                            decoration:
                                InputDecoration(border: OutlineInputBorder()),
                            validator: (value) =>
                                Validators.requiredValidation(value, "Icon Field"),
                            hint: Text("Select Any Icon"),
                            items: snapshot.data!.docs
                                .map<DropdownMenuItem<String>>((e) {
                              String? icon = (e.data() as Map)['name'];
                              return DropdownMenuItem<String>(
                                value: icon,
                                child: Row(
                                  children: [
                                    Icon(MdiIcons.fromString("$icon")),
                                    SizedBox(width: 10),
                                    Text("$icon")
                                  ],
                                ),
                              );
                            }).toList(),
                            onChanged: (String? val) {
                              setState(() {
                                iconName = val;
                              });
                            },
                          );
                        }
                        return Container();
                      }),
                  SizedBox(height: 10),
                  Text(
                    "App Name :",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _nameC,
                    validator: (value) =>
                        Validators.requiredValidation(value!, "Name"),
                    decoration: InputDecoration(hintText: "Name of the App"),
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: CustomSubmitButton(
                        title: "Submit",
                        onPressed: () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                              
                          User user = FirebaseAuth.instance.currentUser!;
                              
                          try {
                            DialogModel.showLoader(context);
                              
                            Product product = Product(
                              name: _nameC.text,
                              createdBy: user.uid,
                              createdAt: DateTime.now().toString(),
                              icon: iconName ?? "",
                              viewMode: viewMode,
                              isActive: "1",
                            );
                            if (isAddOption) {
                              await FirestoreService.addProduct(product);
                            } else {
                              await FirestoreService.updateProduct(
                                  widget.existProduct!.id, {
                                "name": _nameC.text,
                                "updatedAt": DateTime.now().toString(),
                                "icon": iconName,
                              });
                            }
                            DialogModel.hideLoader(context);
                            Navigator.pop(context);
                            DialogModel.showSnackBar(context,
                                "App ${isAddOption ? 'Added' : 'Updated'} Succssfully");
                          } catch (e) {
                            Navigator.pop(context);
                            DialogModel.showSimpleDialog(context,
                                title: 'Failed', msg: "$e");
                          }
                        }),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
