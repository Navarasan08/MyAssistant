import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/models/product_detail.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/utils/constants.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/extentions.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class AddHeaderPage extends StatefulWidget {
  const AddHeaderPage({super.key, required this.productId, this.existHeaders});

  final String productId;
  final List<QueryDocumentSnapshot>? existHeaders;

  @override
  State<AddHeaderPage> createState() => _AddHeaderPageState();
}

class _AddHeaderPageState extends State<AddHeaderPage> {
  final _nameC = TextEditingController();
  final _idC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? autoIncrementField;

  List<TableHeader> headers = [];
  bool showAddField = true;
  bool isAddOption = true;
  bool isEdited = false;
  String? fieldType = AppConstants.initialFieldType;

  void addHeaders(TableHeader field) {
    setState(() {
      headers.add(field);
    });
  }

  void updateHeaders(TableHeader header) {
    setState(() {
      isEdited = true;
      header.fieldType = fieldType;
      header.name = _nameC.text;
    });
  }

  void removeField(TableHeader field) {
    setState(() {
      headers.remove(field);
    });
  }

  void fieldView(bool val) {
    setState(() {
      showAddField = val;
    });
  }

  void showEditFieldView(TableHeader header) {
    _nameC.text = header.name ?? "";
    _idC.text = header.id ?? "";
    fieldType = header.fieldType;
    fieldView(true);
  }

  void submit() async {
    if (autoIncrementField != null) {
      headers.map((e) => e.isAutoIncrement = "0");
      headers.singleWhere((e) => e.name == autoIncrementField).isAutoIncrement =
          "1";
    }

    try {
      DialogModel.showLoader(context);

      if (isAddOption) {
        await FirestoreService.addProductHeaders(widget.productId, headers);
      } else {
        await Future.forEach(widget.existHeaders!, (h) async {
          TableHeader header = headers.singleWhere(
              (e) => e.id == (h.data() as Map<String, dynamic>)['id']);
          await FirestoreService.updateHeader(
            widget.productId,
            h.id,
            header,
          );
        });
      }

      DialogModel.hideLoader(context);

      Navigator.pop(context);
    } catch (e) {
      DialogModel.hideLoader(context);
      DialogModel.showSimpleDialog(context, title: "Failure", msg: "$e");
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.existHeaders != null) {
      List<TableHeader> _existHeaders = widget.existHeaders!
          .map((e) => TableHeader.fromJson(e.data()))
          .toList();
      headers = _existHeaders;
      showAddField = false;
      isAddOption = false;

      List<TableHeader> _Incrheaders =
          headers.where((e) => e.isAutoIncrement == "1").toList();
      if (_Incrheaders.isNotEmpty) {
        autoIncrementField = _Incrheaders.first.name;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(title: Text("${isAddOption ? 'Add' : 'Update'} Headers")),
      body: Center(
        child: SizedBox(
          width: ResponsiveWidget.isWeb(context) ? size.width / 3 : size.width,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextButton.icon(
                          onPressed: !isAddOption
                              ? null
                              : () {
                                  if (headers.length >=
                                      AppConstants.tableFieldCount) {
                                    DialogModel.showSnackBar(context,
                                        "You have reached the maximum Field Count");
                                    return;
                                  }
                                  fieldView(true);
                                  // showDialog(
                                  //     context: context,
                                  //     builder: (context) =>
                                  //         AddFieldDialog(addField: addheaders));
                                },
                          icon: Icon(Icons.add_circle),
                          label: Text("Add Field",
                              style: TextStyle(fontWeight: FontWeight.w600)),
                        ),
                        SizedBox(height: 10),
                        if (showAddField) _addNewFieldWidget(),
                        Divider(),
                        Column(
                          children: headers
                              .map((e) => ListTile(
                                    dense: true,
                                    leading: CircleAvatar(
                                      child: Text("${headers.indexOf(e) + 1}"),
                                    ),
                                    title: Text("${e.name}"),
                                    subtitle: Row(
                                      children: [
                                        Text("Type: ${e.fieldType} "),
                                        if (e.isAutoIncrement == "1")
                                          Text(
                                            "(A I)",
                                            style: TextStyle(color: Colors.red),
                                          ),
                                      ],
                                    ),
                                    trailing: isAddOption
                                        ? IconButton(
                                            icon: Icon(Icons.delete,
                                                color: Colors.red),
                                            onPressed: () {
                                              removeField(e);
                                            },
                                          )
                                        : IconButton(
                                            onPressed: () {
                                              showEditFieldView(e);
                                            },
                                            icon: Icon(Icons.edit)),
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Auto Increment Field",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DropdownButtonFormField<String>(
                  value: autoIncrementField,
                  isExpanded: true,
                  decoration: InputDecoration(border: OutlineInputBorder()),
                  hint: Text("Choose Auto Increment Field"),
                  items: headers
                      .map((e) => e.name)
                      .map<DropdownMenuItem<String>>((e) {
                    return DropdownMenuItem<String>(value: e, child: Text("$e"));
                  }).toList(),
                  onChanged: (String? val) {
                    setState(() {
                      autoIncrementField = val;
                    });
                  },
                ),
              ),
              CustomSubmitButton(
                title: "Submit",
                onPressed: isAddOption
                    ? submit
                    : isEdited
                        ? submit
                        : null,
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addNewFieldWidget() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: fieldType,
            isExpanded: true,
            validator: (value) =>
                Validators.requiredValidation(value!, "Field Type"),
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
            ),
            items: AppConstants.fieldType
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                fieldType = newValue!;
              });
            },
          ),
        ),
        SizedBox(width: 5),
        Expanded(
          flex: 4,
          child: TextFormField(
            decoration: InputDecoration(hintText: "Enter a Title"),
            controller: _nameC,
            validator: (val) => Validators.requiredValidation(val!, "Name"),
          ),
        ),
        SizedBox(width: 5),
        ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (isAddOption) {
                  TableHeader field = TableHeader(
                    name: _nameC.text,
                    fieldType: fieldType,
                    isActive: "1",
                    createdAt: DateTime.now().toString(),
                  );
                  addHeaders(field);
                } else {
                  TableHeader field =
                      headers.firstWhere((e) => e.id == _idC.text);

                  updateHeaders(field);
                }
                fieldView(false);
                _nameC.clear();
                _idC.clear();
              }
            },
            child: Text(isAddOption ? "Save" : "Update")),
      ],
    );
  }
}
