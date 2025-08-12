/// DTO for {{Pascal}}.
class {{Pascal}}Dto {
  final String id;
  final String title;

  const {{Pascal}}Dto({required this.id, required this.title});

  factory {{Pascal}}Dto.fromJson(Map<String, dynamic> json) =>
      {{Pascal}}Dto(id: json['id'] as String, title: json['title'] as String);

  Map<String, dynamic> toJson() => {'id': id, 'title': title};
}
