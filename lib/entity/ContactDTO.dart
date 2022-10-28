class ContactDTO {
  String type;
  String value;

  ContactDTO({this.value, this.type});

  factory ContactDTO.fromJson(Map<String, dynamic> json) {
    return ContactDTO(
      value: json["value"],
      type: json['type'],
    );
  }

  Map<String, String> toJson() => {
        'value': value,
        'type': type,
      };
}
