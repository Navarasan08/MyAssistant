import 'dart:developer';

import 'package:calendar_view/calendar_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:my_assistant/models/product.dart';
import 'package:my_assistant/service/firestore_service.dart';
import 'package:my_assistant/src/product/goal/add_goal_detail.dart';
import 'package:my_assistant/utils/dialog.dart';
import 'package:my_assistant/utils/extentions.dart';
import 'package:my_assistant/widgets/custom_cell.dart';
import 'package:my_assistant/widgets/responsive_widget.dart';

class GoalStatus extends Equatable {
  DateTime date;
  bool status;

  GoalStatus(this.date, this.status);

  @override
  List<Object?> get props => [date];
}

class ProductGoalPage extends StatelessWidget {
  const ProductGoalPage({super.key, required this.product});
  final Product product;

  @override
  Widget build(BuildContext context) {
    if (product.goalDetail == null) {
      return AddGoalDetail(product: product, isPop: false);
    }
    return GoalPage(product: product);
  }
}

class GoalPage extends StatefulWidget {
  const GoalPage({super.key, required this.product});
  final Product product;

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  var eventController = EventController();

  Stream<QuerySnapshot>? goalStream;

  @override
  void initState() {
    super.initState();
    goalStream = FirestoreService.getGoalStatus(widget.product.id!);

    FirestoreService.getGoalStatus(widget.product.id!).listen((field) {
      for (var field in field.docs) {
        var _field = field.data() as Map<String, dynamic>;
        String? dateStr = _field['date'];
        bool status = _field['status'] == "1";

        if (dateStr != null) {
          DateTime? date = DateTime.tryParse(dateStr);

          if (date != null) {
            // addEvent(status, date);
            var _gs = GoalStatus(date, status);
          }
        }
      }
    });
  }

  void addEvent(bool status, DateTime date) {
    eventController.add(CalendarEventData(
      title: status ? "Success" : "Failure",
      color: status ? Colors.green : Colors.red,
      date: date,
    ));
  }

  void removeEvent(CalendarEventData event) {
    eventController.remove(event);
  }

  void updateDB() {}

  void addStatus(CalendarEventData event, DateTime date) {
    if (event.title == "Success") {
      addEvent(false, date);
      removeEvent(event);
    } else {
      removeEvent(event);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.product.name}"),
        actions: [
          IconButton(
              onPressed: () {
                context.pushRoute(AddGoalDetail(
                  product: widget.product,
                  isPop: true,
                ));
              },
              icon: Icon(Icons.edit))
        ],
      ),
      body: !kIsWeb
          ? _body()
          : Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  Expanded(child: _body()),
                  SizedBox(width: 20),
                  Expanded(
                      child: Scaffold(
                    floatingActionButton:
                        FloatingActionButton(onPressed: () {}, child: Icon(Icons.add),),
                  ))
                ],
              ),
            ),
    );
  }

  Widget _body() {
    return StreamBuilder<QuerySnapshot>(
        stream: goalStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<QueryDocumentSnapshot> data = snapshot.data!.docs;

            return MonthView(
              controller: eventController,
              cellAspectRatio: !kIsWeb ? 0.55 : 1.2,
              cellBuilder: (date, events, isToday, isInMonth) {
                QueryDocumentSnapshot? _goalStatus = getGoalStatus(data, date);
                GoalStatus? goalStatus = _goalStatus != null
                    ? GoalStatus(date, _goalStatus['status'] == '1')
                    : null;

                return CustomCell(
                  date: date,
                  shouldHighlight: isToday,
                  backgroundColor: isInMonth ? Colors.white : Color(0xfff0f0f0),
                  event: goalStatus != null
                      ? Image.asset(
                          "assets/images/${goalStatus.status ? 'tick' : 'fail'}.png")
                      : null,
                  onTileTap: () {
                    String? startDateStr = widget.product.goalDetail?.startDate;
                    if (startDateStr != null) {
                      DateTime? startDate = DateTime.tryParse(startDateStr);
                      DateTime tomorrow = DateTime.now();
                      if (startDate != null) {
                        if (date.isBefore(startDate) ||
                            date.isAfter(tomorrow)) {
                          DialogModel.showSnackBar(
                              context,
                              date.isBefore(startDate)
                                  ? "Selected Date is not in Goal"
                                  : "Future date is not avilable!");
                          return;
                        }
                      }
                    }

                    // Update status

                    if (_goalStatus != null) {
                      FirestoreService.updateGoalStatus(widget.product.id!,
                          _goalStatus.id, !goalStatus!.status);
                    } else {
                      FirestoreService.saveGoalStatus(widget.product.id!, {
                        "date": date.dateToStringWithFormat(),
                        "status": "1",
                      });
                    }
                  },
                );
              },
              minMonth: DateTime(1990),
              maxMonth: DateTime(2050),
              initialMonth: DateTime.now(),
              onPageChange: (date, pageIndex) => print("$date, $pageIndex"),
              onCellTap: (events, date) {
                // update status

                // if (events.isNotEmpty) {
                //   CalendarEventData event = events[0];
                // addStatus(event, date);
                // } else {
                // addEvent(true, date);
                // }
              },
              startDay: WeekDays.sunday,
              // onEventTap: addStatus,
              onDateLongPress: (date) => print(date),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text("${snapshot.error}"),
            );
          }

          return Center(
            child: CircularProgressIndicator(),
          );
        });
  }

  QueryDocumentSnapshot? getGoalStatus(
      List<QueryDocumentSnapshot<Object?>> data, DateTime date) {
    List list = data.where(
      (e) {
        var dateObj = e.data() as Map<String, dynamic>;

        String today = date.dateToStringWithFormat();

        return dateObj['date'] == today;
      },
    ).toList();

    if (list.isNotEmpty) {
      return list[0];
    }
  }
}
