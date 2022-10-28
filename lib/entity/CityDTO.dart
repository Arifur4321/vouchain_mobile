class CityDTO {
  String id;
  String name;
  String idProvince;

  CityDTO({this.name, this.id, this.idProvince});

  factory CityDTO.fromJson(Map<String, dynamic> json) {
    return CityDTO(
        name: json["name"], id: json['id'], idProvince: json['idProvince']);
  }

  Map<String, String> toJson() =>
      {'name': name, 'id': id, 'idProvince': idProvince};
}
