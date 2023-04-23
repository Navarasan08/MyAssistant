import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_assistant/models/product_detail.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/widgets/custom_button.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class AddFieldPage extends StatefulWidget {
  const AddFieldPage({
    super.key,
    required this.productId,
    required this.fieldCount,
    this.rowId,
    this.isAddOption = true,
  });

  final String productId;
  final int fieldCount;
  final String? rowId;
  final bool isAddOption;

  @override
  State<AddFieldPage> createState() => _AddFieldPageState();
}

class _AddFieldPageState extends State<AddFieldPage> {
  Stream<QuerySnapshot>? headerStream;

  var fieldList = [];
  List<QueryDocumentSnapshot> existFields = [];

  @override
  void initState() {
    super.initState();

    headerStream = FirestoreService.getProductHeaders(widget.productId)
        .asBroadcastStream();

    headerStream!.listen((headerSnapshot) {
      var headers = headerSnapshot.docs;

      headers.forEach((h) {
        var header = h.data() as Map;

        var controller = TextEditingController();

        if (header['isAutoIncrement'] == "1") {
          controller.text = "${widget.fieldCount + 1}";
        }

        if (!widget.isAddOption) {
          FirestoreService.getField(widget.productId, widget.rowId!, h.id)
              .first
              .then((value) {
            existFields.add(value.docs.first);
            var obj = value.docs.first.data() as Map<String, dynamic>;
            controller.text = obj['value'];
          });
        }

        // if (existFields != null) {
        //   isAddOption = false;
        //   QueryDocumentSnapshot _field = existFields!.singleWhere(
        //       (e) => (e.data() as Map<String, dynamic>)['headerId'] == h.id);

        //   controller.text = (_field.data() as Map<String, dynamic>)['value'];
        // }

        fieldList.add({
          "controller": controller,
          "header": header,
          "headerId": h.id,
        });

        setState(() {});

        print(header);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.isAddOption ? 'Add' : 'Update'} Fields"),
      ),
      body: fieldList.isEmpty
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: SizedBox(
                width: ResponsiveWidget.isWeb(context)
                    ? size.width / 3
                    : size.width,
                child: Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(children: [
                          for (var field in fieldList) ...[
                            if (field['header']['fieldType'] == "date")
                              TextFormField(
                                controller: field['controller'],
                                keyboardType:
                                    field['header']['fieldType'] == "int"
                                        ? TextInputType.number
                                        : null,
                                enabled:
                                    field['header']['isAutoIncrement'] != "1",
                                decoration: InputDecoration(
                                    labelText: field['header']['name'],
                                    suffixIcon: IconButton(
                                        onPressed: () async {
                                          DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1950),
                                                  lastDate: DateTime(2100));

                                          if (pickedDate != null) {
                                            String formattedDate =
                                                DateFormat('yyyy-MM-dd')
                                                    .format(pickedDate);
                                            TextEditingController controller =
                                                field['controller'];
                                            setState(() {
                                              controller.text = formattedDate;
                                            });
                                          } else {}
                                        },
                                        icon: Icon(Icons.calendar_month))),
                              )
                            else
                              TextFormField(
                                controller: field['controller'],
                                decoration: InputDecoration(
                                    labelText: field['header']['name']),
                              ),
                            SizedBox(height: 10),
                          ]
                        ]),
                      ),
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: CustomSubmitButton(
                        onPressed: () async {
                          try {
                            DialogModel.showLoader(context);

                            if (widget.isAddOption) {
                              List<Field> fields = [];

                              fieldList.forEach((e) {
                                fields.add(Field(
                                  headerId: e['headerId'],
                                  headerName: e['header']['name'],
                                  value:
                                      (e['controller'] as TextEditingController)
                                          .text,
                                  isActive: "1",
                                  createdAt: DateTime.now().toString(),
                                ));
                              });

                              await FirestoreService.addFields(
                                  widget.productId, fields);
                            } else {
                              await Future.forEach(fieldList, (field) async {
                                var updateField = {
                                  "value": (field['controller']
                                          as TextEditingController)
                                      .text,
                                  "updatedAt": DateTime.now().toString(),
                                };

                                var _field = existFields.singleWhere((e) =>
                                    (e.data()
                                        as Map<String, dynamic>)['headerId'] == field['headerId']);
                                await FirestoreService.updateField(
                                    widget.productId,
                                    widget.rowId!,
                                    _field.id,
                                    updateField);
                              });
                            }

                            DialogModel.hideLoader(context);

                            Navigator.pop(context);
                          } catch (e) {
                            DialogModel.hideLoader(context);
                            DialogModel.showSimpleDialog(context,
                                title: "Failure", msg: "$e");
                          }
                        },
                        title: "Submit",
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }
}
