class JobModel {
  final int id;
  final String title;
  final String company;
  final String location;
  final String salary;
  final String experience;
  final String type;
  final String description;
  final List<String> skills;
  final String postedOn;

  JobModel({
    required this.id,
    required this.title,
    required this.company,
    required this.location,
    required this.salary,
    required this.experience,
    required this.type,
    required this.description,
    required this.skills,
    required this.postedOn,
  });

  factory JobModel.fromJson(Map<String, dynamic> json) {
    return JobModel(
      id: json['id'],
      title: json['title'],
      company: json['company'],
      location: json['location'],
      salary: json['salary'],
      experience: json['experience'],
      type: json['type'],
      description: json['description'] ?? '',
      skills: List<String>.from(json['skills'] ?? []),
      postedOn: json['posted_on'] ?? '',
    );
  }
}