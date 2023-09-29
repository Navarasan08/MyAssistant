import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/service/category_firestore_service.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';

class AddCheckListScreen extends StatefulWidget {
  const AddCheckListScreen(
      {super.key, required this.categId, required this.productId, this.item});

  final String categId;
  final String productId;
  final QueryDocumentSnapshot? item;

  @override
  State<AddCheckListScreen> createState() => _AddCheckListScreenState();
}

class _AddCheckListScreenState extends State<AddCheckListScreen> {
  final _titleC = TextEditingController();
  final _subtitleC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  DateTime? selectedDate;

  void addCategory() async {
    try {
      DialogModel.showLoader(context);

      if (widget.item != null) {
        await CategoryFirestoreService.updateProductItem(
          widget.categId,
          widget.productId,
          widget.item!.id,
          title: _titleC.text,
          subtitle: _subtitleC.text,
          isChecked: (widget.item!.data() as Map)['isChecked'],
          targetDate: selectedDate?.toString(),
        );

      DialogModel.showSnackBar(context, "Item Updated!");
      } else {
        await CategoryFirestoreService.addProductItem(
          widget.categId,
          widget.productId,
          title: _titleC.text,
          subtitle: _subtitleC.text,
          targetDate: selectedDate?.toString(),
        );

      DialogModel.showSnackBar(context, "Item Added!");
      }

      DialogModel.hideLoader(context);


      Navigator.pop(context);
    } catch (e) {
      DialogModel.hideLoader(context);
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(DateTime.now().year + 2),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.item != null) {
      var item = widget.item!.data() as Map;

      _titleC.text = item['title'];
      _subtitleC.text = item['subtitle'];
      selectedDate = item['targetDate'] != null && item['targetDate'] != ""
          ? DateTime.tryParse(item['targetDate'])
          : null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add CheckList"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Title :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _titleC,
                validator: (value) =>
                    Validators.requiredValidation(value!, "Title"),
                decoration: InputDecoration(hintText: "Enter Title*"),
              ),
              SizedBox(height: 20),
              Text(
                "Subtitle :",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _subtitleC,
                decoration: InputDecoration(hintText: "Enter SubTitle"),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  ElevatedButton(
                      onPressed: () {
                        _selectDate(context);
                      },
                      child: Text("Set Target Date")),
                  SizedBox(width: 10),
                  if (selectedDate != null) Text("$selectedDate")
                ],
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
