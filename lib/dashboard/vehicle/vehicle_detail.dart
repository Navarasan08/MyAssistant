import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class VehicleDetail extends StatefulWidget {
  const VehicleDetail({super.key, required this.product});

  final QueryDocumentSnapshot product;

  @override
  State<VehicleDetail> createState() => _VehicleDetailState();
}

class _VehicleDetailState extends State<VehicleDetail> {
  int selectedPage = 0;

  void setPage(int page) {
    setState(() {
      selectedPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedPage,
          type: BottomNavigationBarType.fixed,
          onTap: setPage,
          items: [
            BottomNavigationBarItem(icon: Icon(MdiIcons.fuel), label: "Petrol"),
            BottomNavigationBarItem(
                icon: Icon(Icons.home_repair_service),
                label: "Service / Repair"),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.speedometer), label: "Milage / KM"),
            BottomNavigationBarItem(
                icon: Icon(MdiIcons.note), label: "Notes / Reminder"),
          ]),
      body: Column(
        children: [],
      ),
    );
  }
}
