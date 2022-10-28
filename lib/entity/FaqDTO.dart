class FaqDTO {
  String question;
  String answer;

  FaqDTO({this.question, this.answer});

  factory FaqDTO.fromJson(Map<String, dynamic> json) {
    return FaqDTO(
      question: json["question"],
      answer: json['answer'],
    );
  }

  Map<String, String> toJson() => {
    'question': question,
    'answer': answer,
  };
}
