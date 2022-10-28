class SimpleDTO {
  String errorDescription;
  String status;

  SimpleDTO({this.status, this.errorDescription});

  factory SimpleDTO.fromJson(Map<String, dynamic> json) {
    return SimpleDTO(
      status: json["status"],
      errorDescription: json['errorDescription'],
    );
  }

  Map<String, String> toJson() => {
        'status': status,
        'errorDescription': errorDescription,
      };
}
