class GoalDetail {
  String? description;
  String? startDate;
  String? isDaily;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? isActive;

  GoalDetail(
      {this.description,
      this.startDate,
      this.isDaily,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.isActive = "1"});

  GoalDetail.fromJson(Map<String, dynamic> json) {
    description = json['description'];
    startDate = json['startDate'];
    isDaily = json['isDaily'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['description'] = this.description;
    data['startDate'] = this.startDate;
    data['isDaily'] = this.isDaily;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['updatedAt'] = this.updatedAt;
    data['isActive'] = this.isActive;
    return data;
  }
}
