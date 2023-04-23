import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:my_assistant/models/goal_detail.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/src/product/goal/product_goal.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/validator.dart';
import 'package:my_assistant/widgets/custom_button.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class AddGoalDetail extends StatefulWidget {
  const AddGoalDetail({super.key, required this.product, required this.isPop});

  final Product product;
  final bool isPop;

  @override
  State<AddGoalDetail> createState() => _AddGoalDetailState();
}

class _AddGoalDetailState extends State<AddGoalDetail> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionC = TextEditingController();
  final _startDateC = TextEditingController();

  bool isDaily = false;
  bool autoUpdate = false;

  void setLoading(bool val) {
    if (val) {
      DialogModel.showLoader(context);
    } else {
      DialogModel.hideLoader(context);
    }
  }

  @override
  void initState() {
    super.initState();

    if (widget.product.goalDetail != null) {
      _descriptionC.text = widget.product.goalDetail?.description ?? "";
      _startDateC.text = widget.product.goalDetail?.startDate ?? "";
      isDaily = widget.product.goalDetail?.isDaily == "1";
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: Text("Add Goal Detail"),
      ),
      body: Center(
        child: SizedBox(
          width: ResponsiveWidget.isWeb(context) ? size.width / 3 : size.width,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Description :",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _descriptionC,
                    maxLines: 2,
                    validator: (value) =>
                        Validators.requiredValidation(value!, "Description"),
                    decoration: InputDecoration(hintText: "Description"),
                  ),
                  SizedBox(height: 10),
                  TextFormField(
                    controller: _startDateC,
                    decoration: InputDecoration(
                        hintText: "Start Date",
                        suffixIcon: IconButton(
                            onPressed: () async {
                              DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime(2100));
      
                              if (pickedDate != null) {
                                String formattedDate =
                                    DateFormat('yyyy-MM-dd').format(pickedDate);
                                setState(() {
                                  _startDateC.text = formattedDate;
                                });
                              } else {}
                            },
                            icon: Icon(Icons.calendar_month))),
                  ),
                  SizedBox(height: 10),
                  CheckboxListTile(
                      title: Text("Is Daily Update"),
                      value: isDaily,
                      onChanged: (bool? val) {
                        setState(() {
                          isDaily = val ?? false;
                        });
                      }),
                  SizedBox(height: 10),
                  Center(
                    child: CustomSubmitButton(
                        title: "Submit",
                        onPressed: () {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
      
                          User user = FirebaseAuth.instance.currentUser!;
      
                          try {
                            setLoading(true);
                            GoalDetail goalDetail = GoalDetail(
                              description: _descriptionC.text,
                              createdAt: DateTime.now().toString(),
                              createdBy: user.uid,
                              isActive: "1",
                              isDaily: isDaily ? "1" : "0",
                              startDate: _startDateC.text,
                            );
                            FirestoreService.addGoalDetail(
                                    widget.product.id!, goalDetail)
                                .then((value) {
                              setLoading(false);
                              Map<String, dynamic> _data = {
                                ...widget.product.toJson(),
                                "goalDetail": goalDetail.toJson(),
                              };
                              Product prod = Product.fromJson(_data);
                              if (widget.isPop) {
                                Navigator.pop(context);
                              }
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          GoalPage(product: prod)));
      
                              DialogModel.showSnackBar(
                                  context, "Goal Updated Succssfully");
                            });
                          } catch (e) {
                            setLoading(false);
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
