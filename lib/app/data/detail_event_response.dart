class DetailEventResponse {
  int? id;
  String? name;
  String? description;
  String? eventDate;
  String? location;
  int? userId;
  String? createdAt;
  String? updatedAt;
  String? dibuatOleh;

  DetailEventResponse(
      {this.id,
      this.name,
      this.description,
      this.eventDate,
      this.location,
      this.userId,
      this.createdAt,
      this.updatedAt,
      this.dibuatOleh});

  DetailEventResponse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    eventDate = json['event_date'];
    location = json['location'];
    userId = json['user_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    dibuatOleh = json['dibuat_oleh'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['description'] = description;
    data['event_date'] = eventDate;
    data['location'] = location;
    data['user_id'] = userId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['dibuat_oleh'] = dibuatOleh;
    return data;
  }
}
