class LoginUser {
  String? id;
  String? fullName;
  String? imageUrl;
  String? emailId;
  String? password;
  String? role;
  String? status;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  LoginUser(
      {this.id,
      this.fullName,
      this.imageUrl,
      this.emailId,
      this.password,
      this.role,
      this.status,
      this.isActive = "1",
      this.createdAt,
      this.updatedAt});

  LoginUser.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullName = json['fullName'];
    imageUrl = json['imageUrl'];
    emailId = json['emailId'];
    password = json['password'];
    role = json['role'];
    status = json['status'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullName'] = this.fullName;
    data['imageUrl'] = this.imageUrl;
    data['emailId'] = this.emailId;
    data['password'] = this.password;
    data['role'] = this.role;
    data['status'] = this.status;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
