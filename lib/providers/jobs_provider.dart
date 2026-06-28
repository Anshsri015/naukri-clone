import 'package:flutter/material.dart';
import '../core/api_service.dart';
import '../models/job_model.dart';

class JobsProvider extends ChangeNotifier {
  List<JobModel> _jobs = [];
  List<JobModel> _filteredJobs = [];
  bool _isLoading = false;
  String? _error;

  List<JobModel> get jobs => _filteredJobs;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Jobs fetch karo
  Future<void> fetchJobs() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await ApiService.getJobs();
      _jobs = (response.data as List)
          .map((j) => JobModel.fromJson(j))
          .toList();
      _filteredJobs = _jobs;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = 'Jobs load nahi hue. Please try again.';
      notifyListeners();
    }
  }

  // Search filter
  void searchJobs(String query) {
    if (query.isEmpty) {
      _filteredJobs = _jobs;
    } else {
      _filteredJobs = _jobs.where((job) {
        return job.title.toLowerCase().contains(query.toLowerCase()) ||
            job.company.toLowerCase().contains(query.toLowerCase());
      }).toList();
    }
    notifyListeners();
  }
}