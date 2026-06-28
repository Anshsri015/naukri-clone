import 'package:flutter/material.dart';
import '../../core/api_service.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;
  bool _isLoading = false;

  String? _selectedDegree;
  String? _selectedExperience;
  String? _selectedJobField;
  final _cgpaController = TextEditingController();

  final List<String> _degrees = [
    'B.Tech / B.E.',
    'BCA',
    'MCA',
    'M.Tech',
    'MBA',
    'B.Sc',
    'M.Sc',
    'Other',
  ];

  final List<String> _jobFields = [
    'Android Development',
    'iOS Development',
    'Web Development',
    'Data Science / ML',
    'DevOps / Cloud',
    'UI/UX Design',
    'Product Management',
    'QA / Testing',
    'Other',
  ];

  @override
  void dispose() {
    _cgpaController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);

    try {
      await ApiService.saveProfile({
        'degree': _selectedDegree,
        'cgpa': _cgpaController.text.isEmpty ? null : _cgpaController.text,
        'experience_type': _selectedExperience,
        'job_field': _selectedJobField,
      });

      if (mounted) {
        Navigator.pushReplacementNamed(context, '/jobs');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save profile. Please try again.')),
        );
      }
    }

    setState(() => _isLoading = false);
  }

  void _handleNext() {
    if (_currentStep == 0) {
      if (_selectedDegree == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your degree')),
        );
        return;
      }
      setState(() => _currentStep = 1);
    } else if (_currentStep == 1) {
      if (_selectedExperience == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your experience level')),
        );
        return;
      }
      setState(() => _currentStep = 2);
    } else {
      if (_selectedJobField == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select your preferred job field')),
        );
        return;
      }
      _saveProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF4A90D9),
        title: const Text(
          'Complete Your Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator
            LinearProgressIndicator(
              value: (_currentStep + 1) / 3,
              backgroundColor: Colors.grey.shade200,
              color: const Color(0xFF4A90D9),
            ),
            const SizedBox(height: 8),
            Text(
              'Step ${_currentStep + 1} of 3',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 32),

            if (_currentStep == 0) _buildDegreeStep(),
            if (_currentStep == 1) _buildExperienceStep(),
            if (_currentStep == 2) _buildJobFieldStep(),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _handleNext,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4A90D9),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                  _currentStep == 2 ? 'Submit' : 'Next',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDegreeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🎓 What is your degree?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select your highest qualification',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ..._degrees.map((degree) => GestureDetector(
          onTap: () => setState(() => _selectedDegree = degree),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedDegree == degree
                    ? const Color(0xFF4A90D9)
                    : Colors.grey.shade300,
                width: _selectedDegree == degree ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
              color: _selectedDegree == degree
                  ? const Color(0xFF4A90D9).withOpacity(0.08)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  _selectedDegree == degree
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: const Color(0xFF4A90D9),
                ),
                const SizedBox(width: 12),
                Text(degree, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        )),
        const SizedBox(height: 16),
        TextField(
          controller: _cgpaController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'CGPA (Optional)',
            hintText: 'e.g. 8.5',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExperienceStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💼 What is your experience level?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select your current status',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ...['Fresher (0-1 year)', 'Experienced (1-3 years)', 'Senior (3+ years)']
            .map((exp) => GestureDetector(
          onTap: () => setState(() => _selectedExperience = exp),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedExperience == exp
                    ? const Color(0xFF4A90D9)
                    : Colors.grey.shade300,
                width: _selectedExperience == exp ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
              color: _selectedExperience == exp
                  ? const Color(0xFF4A90D9).withOpacity(0.08)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  _selectedExperience == exp
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: const Color(0xFF4A90D9),
                ),
                const SizedBox(width: 12),
                Text(exp, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildJobFieldStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '🔍 Which field are you looking for?',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        const Text(
          'Select your preferred job field',
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 24),
        ..._jobFields.map((field) => GestureDetector(
          onTap: () => setState(() => _selectedJobField = field),
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              border: Border.all(
                color: _selectedJobField == field
                    ? const Color(0xFF4A90D9)
                    : Colors.grey.shade300,
                width: _selectedJobField == field ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
              color: _selectedJobField == field
                  ? const Color(0xFF4A90D9).withOpacity(0.08)
                  : Colors.white,
            ),
            child: Row(
              children: [
                Icon(
                  _selectedJobField == field
                      ? Icons.radio_button_checked
                      : Icons.radio_button_unchecked,
                  color: const Color(0xFF4A90D9),
                ),
                const SizedBox(width: 12),
                Text(field, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        )),
      ],
    );
  }
}