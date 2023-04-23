import 'package:my_assistant/main.dart';
import 'package:my_assistant/models/goal_detail.dart';

class Product {
  String? name;
  String? id;
  String? icon;
  String? viewMode;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? isActive;
  GoalDetail? goalDetail;

  Product(
      {this.name,
      this.id,
      this.icon,
      this.createdAt,
      this.createdBy,
      this.viewMode,
      this.updatedAt,
      this.goalDetail,
      this.isActive = "1"}) {
        this.id = uuid.v1();
    this.createdAt = DateTime.now().toString();
      }

  Product.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    id = json['id'];
    icon = json['icon'];
    viewMode = json['viewMode'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    goalDetail = json['goalDetail'] != null
        ? GoalDetail.fromJson(json['goalDetail'])
        : null;
  }

  Product.fromFirestoreJson(String docId, Map<String, dynamic> json) {
    name = json['name'];
    id = docId;
    icon = json['icon'];
    viewMode = json['viewMode'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    goalDetail = json['goalDetail'] != null
        ? GoalDetail.fromJson(json['goalDetail'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['id'] = this.id;
    data['icon'] = this.icon;
    data['viewMode'] = this.viewMode;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['isActive'] = this.isActive;
    data['goalDetail'] = this.goalDetail?.toJson();
    return data;
  }
}
