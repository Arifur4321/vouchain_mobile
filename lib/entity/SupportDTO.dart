import 'package:vouchain_wallet_app/entity/ContactDTO.dart';

class SupportDTO<T> {
  String title;
  String content;
  List<T> contacts;

  SupportDTO({this.title, this.content, this.contacts});

  factory SupportDTO.fromJson(Map<String, dynamic> json) {
    List<T> decodedList;
    if (json['contacts'] != null) {
      decodedList =
          json['contacts'].map((i) => ContactDTO.fromJson(i)).toList();
    }
    return SupportDTO(
      title: json["title"],
      content: json['content'],
      contacts: decodedList,
    );
  }
}
