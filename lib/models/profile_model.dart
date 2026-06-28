class ProfileModel {
  final int? id;
  final int userId;
  final String degree;
  final String? cgpa;
  final String experienceType;
  final String jobField;

  ProfileModel({
    this.id,
    required this.userId,
    required this.degree,
    this.cgpa,
    required this.experienceType,
    required this.jobField,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      userId: json['user_id'],
      degree: json['degree'],
      cgpa: json['cgpa'],
      experienceType: json['experience_type'],
      jobField: json['job_field'],
    );
  }
}