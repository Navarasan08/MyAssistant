import 'package:equatable/equatable.dart';
import 'package:my_assistant/main.dart';

class ProductDetail {
  String? productId;
  String? productName;
  String? viewMode;
  String? createdAt;
  String? createdBy;
  String? updatedAt;
  String? isActive;
  List<TableHeader>? header;
  List<Rows>? rows;

  ProductDetail(
      {this.productId,
      this.productName,
      this.viewMode,
      this.header,
      this.createdAt,
      this.createdBy,
      this.updatedAt,
      this.isActive = "1",
      this.rows}) {
    this.productId = uuid.v1();
    this.createdAt = DateTime.now().toString();
  }

  ProductDetail.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    viewMode = json['viewMode'];
    createdAt = json['createdAt'];
    createdBy = json['createdBy'];
    updatedAt = json['updatedAt'];
    isActive = json['isActive'];
    if (json['header'] != null) {
      header = <TableHeader>[];
      json['header'].forEach((v) {
        header!.add(new TableHeader.fromJson(v));
      });
    }
    if (json['rows'] != null) {
      rows = <Rows>[];
      json['rows'].forEach((v) {
        rows!.add(new Rows.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['viewMode'] = this.viewMode;
    data['createdAt'] = this.createdAt;
    data['createdBy'] = this.createdBy;
    data['isActive'] = this.isActive;
    data['updatedAt'] = this.updatedAt;
    if (this.header != null) {
      data['header'] = this.header!.map((v) => v.toJson()).toList();
    }
    if (this.rows != null) {
      data['rows'] = this.rows!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class TableHeader extends Equatable {
  String? id;
  String? name;
  String? fieldType;
  String? size;
  String? isAutoIncrement;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  TableHeader(
      {this.id,
      this.name,
      this.fieldType,
      this.size,
      this.isAutoIncrement = "0",
      this.isActive = "1",
      this.createdAt,
      this.updatedAt}) {
    this.id = uuid.v1();
    this.createdAt = DateTime.now().toString();
  }

  TableHeader.fromJson(json) {
    id = json['id'];
    name = json['name'];
    fieldType = json['fieldType'];
    size = json['size'];
    isAutoIncrement = json['isAutoIncrement'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['fieldType'] = this.fieldType;
    data['isAutoIncrement'] = this.isAutoIncrement;
    data['size'] = this.size;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}

class Rows {
  String? rowId;
  String? createdAt;
  String? updatedAt;
  String? createdBy;
  String? isActive;
  List<Field>? field;

  Rows({
    this.rowId,
    this.createdAt,
    this.updatedAt,
    this.isActive = "1",
    this.field,
  }) {
    this.rowId = uuid.v1();
    this.createdAt = DateTime.now().toString();
  }

  Rows.fromJson(json) {
    rowId = json['rowId'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    createdBy = json['createdBy'];
    isActive = json['isActive'];
    if (json['field'] != null) {
      field = <Field>[];
      json['field'].forEach((v) {
        field!.add(new Field.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rowId'] = this.rowId;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['createdBy'] = this.createdBy;
    data['isActive'] = this.isActive;
    if (this.field != null) {
      data['field'] = this.field!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Field {
  String? id;
  String? headerName;
  String? headerId;
  String? value;
  String? isActive;
  String? createdAt;
  String? updatedAt;

  Field(
      {this.id,
      this.headerName,
      this.headerId,
      this.value,
      this.isActive = "1",
      this.createdAt,
      this.updatedAt}) {
    this.id = uuid.v1();
  }

  Field.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    headerName = json['headerName'];
    headerId = json['headerId'];
    value = json['value'];
    isActive = json['isActive'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['headerName'] = this.headerName;
    data['headerId'] = this.headerId;
    data['value'] = this.value;
    data['isActive'] = this.isActive;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
