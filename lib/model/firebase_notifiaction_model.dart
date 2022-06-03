import 'dart:convert';

class FirebaseNotificationModel {
  FirebaseNotificationModel({
    this.id,
    this.type,
    this.clickAction,
  });

  String? id;
  String? type;
  String? clickAction;

  FirebaseNotificationModel copyWith({
    String? id,
    String? type,
    String? clickAction,
  }) =>
      FirebaseNotificationModel(
        id: id ?? this.id,
        type: type ?? this.type,
        clickAction: clickAction ?? this.clickAction,
      );

  factory FirebaseNotificationModel.fromJson(String str) => FirebaseNotificationModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory FirebaseNotificationModel.fromMap(Map<String, dynamic> json) => FirebaseNotificationModel(
    id: json["id"],
    type: json["type"],
    clickAction: json["click_action"],
  );

  Map<String, dynamic> toMap() => {
    "id": id,
    "type": type,
    "click_action": clickAction,
  };
}
