class ProvinceDTO {
  String name;
  String cod;

  ProvinceDTO({this.cod, this.name});

  factory ProvinceDTO.fromJson(Map<String, dynamic> json) {
    return ProvinceDTO(cod: json["cod"], name: json['name']);
  }

  Map<String, String> toJson() => {'cod': cod, 'name': name};
}
