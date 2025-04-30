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
import '../controllers/auth_controller.dart';

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
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // isNumeric function
  bool isNumeric(String s) {
    return double.tryParse(s) != null;
  }

  String? _selectedDivisionId;
  String? _selectedDistrictId;
  String? _selectedUpazilaId;

  void _registerUser() {
    // if (_formKey.currentState!.validate()) {
    FocusScope.of(context).unfocus();

    final name = _nameController.text.trim();
    final nid = _nidController.text.trim();
    final email = _emailController.text.trim();
    final dob = _dobController.text.trim();
    final phoneNumber = _phoneNumberController.text.trim();
    final password = _passwordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    lgr.i('''
      all given values are:

      name: $name
      nid: $nid
      email: $email
      dob: $dob
      phoneNumber: $phoneNumber
      division: $_selectedDivisionId
      district: $_selectedDistrictId
      password: $password
      confirmPassword: $confirmPassword


''');

    final newUser = RegisterInputModel(
      name: name,
      nid: nid,
      email: email,
      dob: dob,
      phone: phoneNumber,
      division: _selectedDivisionId!,
      district: _selectedDistrictId!,
      upazila: _selectedUpazilaId!,
      password: password,
      confirmPassword: confirmPassword,
    );

    lgr.i('newUser: ${newUser.toJson()}');

    ref.read(authControllerProvider.notifier).register(context, data: newUser);

    lgr.i('User registered');
    // }
  }

  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(Duration(days: 365 * 18)),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final List<District> districtsForSelectedDivision =
        _selectedDivisionId != null
            ? (divisionDistrictsMap[_selectedDivisionId] ?? [])
            : [];
    final List<SubDistrict> subDistrictsForSelectedDistrict =
        _selectedDistrictId != null
            ? (districtSubdistrictMap[_selectedDistrictId] ?? [])
            : [];
    return Theme(
      data: AppThemeData.lightThemeData,child: Scaffold(
        appBar: AppBar(),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 50),
                  Text(
                    'মেম্বার রেজিস্ট্রেশন',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 50.0),
                  TextFormField(
                    controller: _nameController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _nidController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _emailController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
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
                    onChanged: (textValue) {
                      //inputOnChange("phone_number", textValue);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _dobController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
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
                    onTap: () {
                      _selectDate();
                    },

                    onChanged: (textValue) {
                      //inputOnChange("phone_number", textValue);
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _phoneNumberController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('ফোন নম্বর*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      //! fix this for every case
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
                    onChanged: (textValue) {
                      //inputOnChange("phone_number", textValue);
                    },
                  ),

                  SizedBox(height: 20.0),

                  DropdownButtonFormField<String>(
                    value: _selectedDivisionId,
                    decoration: InputDecoration(
                      hintText: 'বিভাগ*',
                      labelText: 'বিভাগ',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        divisionMap.entries.map((entry) {
                          return DropdownMenuItem(
                            value: entry.value, // Store the division ID
                            child: Text(
                              entry.key,
                            ), // Display Bangla division name
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDivisionId = value;
                        // Reset the district selection when division changes.
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
                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedDistrictId,
                    decoration: InputDecoration(
                      hintText: 'জেলা*',
                      labelText: 'জেলা',
                      border: OutlineInputBorder(),
                    ),
                    // If no division is selected, disable the dropdown.
                    onChanged:
                        _selectedDivisionId == null
                            ? null
                            : (value) {
                              setState(() {
                                _selectedDistrictId = value;
                              });
                            },
                    items:
                        districtsForSelectedDivision.map((district) {
                          return DropdownMenuItem(
                            value: district.id, // district ID is stored
                            child: Text(
                              district.name,
                            ), // district name is displayed
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

                  SizedBox(height: 20.0),
                  DropdownButtonFormField<String>(
                    value: _selectedUpazilaId,
                    decoration: InputDecoration(
                      hintText: 'উপজেলা*',
                      labelText: 'উপজেলা',
                      border: OutlineInputBorder(),
                    ),
                    // If no division is selected, disable the dropdown.
                    onChanged:
                        _selectedDivisionId == null
                            ? null
                            : (value) {
                              setState(() {
                                _selectedUpazilaId = value;
                              });
                            },
                    items:
                        subDistrictsForSelectedDistrict.map((district) {
                          return DropdownMenuItem(
                            value: district.id, // district ID is stored
                            child: Text(
                              district.name,
                            ), // district name is displayed
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
                  SizedBox(height: 20.0),
                  TextFormField(
                    controller: _passwordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('পাসওয়ার্ড*'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'পাসওয়ার্ড দিন';
                      } else if (value.length < 8) {
                        // at least 8 characters in bengali
                        // kompokkhe 8 ta character
                        return 'পাসওয়ার্ড কমপক্ষে ৮ অক্ষরের হতে হবে';
                      } else if (value.contains(RegExp(r'[0-9]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি সংখ্যা থাকতে হবে';
                      } else if (value.contains(RegExp(r'[A-Z]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি বড় হাতের অক্ষর থাকতে হবে';
                      } else if (value.contains(RegExp(r'[a-z]')) == false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি ছোট হাতের অক্ষর থাকতে হবে';
                      } else if (value.contains(RegExp(r'[@$!%*?&]')) ==
                          false) {
                        return 'পাসওয়ার্ডে অন্ততঃ একটি বিশেষ অক্ষর থাকতে হবে';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),

                  TextFormField(
                    controller: _confirmPasswordController,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('পাসওয়ার্ড নিশ্চিত করুন*'),
                      hintText: 'এখানে লিখুন',
                    ),
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
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _registerUser,
                    child:
                        authState.isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
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
