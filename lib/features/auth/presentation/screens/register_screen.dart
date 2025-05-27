import 'package:bjp_app/config/app_theme_data.dart';
import 'package:bjp_app/features/auth/domain/register_input_model.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/district.dart';
import '../../../../core/database/district_sub_district_map.dart';
import '../../../../core/database/division_district_map_data.dart';
import '../../../../core/database/sub_district.dart';
import '../../../../core/utils/utils.dart';
import 'login_screen.dart'; // Make sure to import your LoginScreen

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _nidController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  String? _selectedDivisionId;
  String? _selectedDistrictId;
  String? _selectedUpazilaId;

  void _registerUser() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      // Just for debugging - print all values
      final name = _nameController.text.trim();
      final nid = _nidController.text.trim();
      final email = _emailController.text.trim();
      final dob = _dobController.text.trim();
      final phoneNumber = _phoneNumberController.text.trim();
      final password = _passwordController.text.trim();
      final confirmPassword = _confirmPasswordController.text.trim();

      lgr.i('''
        Registration values:
        name: $name
        nid: $nid
        email: $email
        dob: $dob
        phoneNumber: $phoneNumber
        division: $_selectedDivisionId
        district: $_selectedDistrictId
        upazila: $_selectedUpazilaId
        password: $password
        confirmPassword: $confirmPassword
      ''');

      // Navigate to LoginScreen after successful validation
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<District> districtsForSelectedDivision = _selectedDivisionId != null
        ? (divisionDistrictsMap[_selectedDivisionId] ?? [])
        : [];
    final List<SubDistrict> subDistrictsForSelectedDistrict = _selectedDistrictId != null
        ? (districtSubdistrictMap[_selectedDistrictId] ?? [])
        : [];

    return Theme(
      data: AppThemeData.lightThemeData,
      child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Text(
                    'মেম্বার রেজিস্ট্রেশন',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 50.0),
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('নাম*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.name,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'নাম দিন';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _nidController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('জাতীয় পরিচয়পত্র (NID) নম্বর*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'জাতীয় পরিচয়পত্র নম্বর দিন';
                      } else if (value != null &&
                          double.tryParse(value) != null &&
                          (value.length < 10 || value.length > 17)) {
                        return 'জাতীয় পরিচয়পত্র নম্বর ১০ থেকে ১৭ অক্ষরের হতে হবে';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('ইমেইল*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'ইমেইল দিন';
                      } else if (!EmailValidator.validate(value)) {
                        return 'ইমেইল সঠিক নয়';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _dobController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('জন্ম তারিখ*'),
                      prefixIcon: Icon(Icons.calendar_today),
                      hintText: 'এখানে লিখুন',
                    ),
                    readOnly: true,
                    keyboardType: TextInputType.datetime,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'জন্ম তারিখ দিন';
                      }
                      final dob = DateTime.parse(value!);
                      final age = DateTime.now().difference(dob).inDays ~/ 365;
                      if (age < 18) {
                        return 'আপনি ১৮ বছরের কম বয়স্ক';
                      }
                      return null;
                    },
                    onTap: _selectDate,
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _phoneNumberController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('ফোন নম্বর*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value?.trim().isEmpty ?? true) {
                        return 'ফোন নম্বর দিন';
                      } else if (value!.length != 11 && !value.contains('+')) {
                        return 'ফোন নম্বর ১১ অক্ষরের হতে হবে';
                      } else if (value.startsWith('+') &&
                          !isNumeric(value.substring(1))) {
                        return 'ফোন নম্বর সঠিক নয়';
                      } else if (!value.startsWith('+88') &&
                          value.length != 11) {
                        return 'ফোন নম্বর ১১ অক্ষরের হতে হবে';
                      } else if (value.startsWith('+88') &&
                          value.length != 14) {
                        return 'ফোন নম্বর ১৪ অক্ষরের হতে হবে';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedDivisionId,
                    decoration: const InputDecoration(
                      hintText: 'বিভাগ*',
                      labelText: 'বিভাগ',
                      border: OutlineInputBorder(),
                    ),
                    items: divisionMap.entries.map((entry) {
                      return DropdownMenuItem(
                        value: entry.value,
                        child: Text(entry.key),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDivisionId = value;
                        _selectedDistrictId = null;
                      });
                    },
                    validator: (String? value) {
                      if (value == null) {
                        return 'বিভাগ দিন';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedDistrictId,
                    decoration: const InputDecoration(
                      hintText: 'জেলা*',
                      labelText: 'জেলা',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _selectedDivisionId == null
                        ? null
                        : (value) {
                      setState(() {
                        _selectedDistrictId = value;
                      });
                    },
                    items: districtsForSelectedDivision.map((district) {
                      return DropdownMenuItem(
                        value: district.id,
                        child: Text(district.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (_selectedDivisionId == null) {
                        return 'প্রথমে বিভাগ নির্বাচন করুন';
                      }
                      if (value == null) {
                        return 'জেলা দিন';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedUpazilaId,
                    decoration: const InputDecoration(
                      hintText: 'উপজেলা*',
                      labelText: 'উপজেলা',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: _selectedDivisionId == null
                        ? null
                        : (value) {
                      setState(() {
                        _selectedUpazilaId = value;
                      });
                    },
                    items: subDistrictsForSelectedDistrict.map((district) {
                      return DropdownMenuItem(
                        value: district.id,
                        child: Text(district.name),
                      );
                    }).toList(),
                    validator: (value) {
                      if (_selectedDistrictId == null) {
                        return 'প্রথমে জেলা নির্বাচন করুন';
                      }
                      if (value == null) {
                        return 'উপজেলা দিন';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('পাসওয়ার্ড*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'পাসওয়ার্ড দিন';
                      } else if (value.length < 8) {
                        return 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';
                      } else if (value.contains(RegExp(r'[0-9]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি সংখ্যা থাকতে হবে';
                      } else if (value.contains(RegExp(r'[A-Z]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি বড় হাতের অক্ষর থাকতে হবে';
                      } else if (value.contains(RegExp(r'[a-z]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি ছোট হাতের অক্ষর থাকতে হবে';
                      } else if (value.contains(RegExp(r'[@$!%*?&]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি বিশেষ অক্ষর থাকতে হবে';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: const InputDecoration(
                      label: Text('পাসওয়ার্ড নিশ্চিত করুন*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    obscureText: true,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'পাসওয়ার্ড দিন';
                      } else if (value != _passwordController.text) {
                        return 'পাসওয়ার্ড মেলে না';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _registerUser,
                    child: const Text(
                      'সংরক্ষণ করুন',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}