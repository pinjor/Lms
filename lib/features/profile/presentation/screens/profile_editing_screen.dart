import 'package:bjp_app/config/app_theme_data.dart';
import 'package:bjp_app/core/database/sub_district.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/database/district.dart';
import '../../../../core/database/district_sub_district_map.dart';
import '../../../../core/database/division_district_map_data.dart';
import '../controllers/profile_controller.dart';

class ProfileEditingScreen extends ConsumerStatefulWidget {
  const ProfileEditingScreen({super.key});

  @override
  ConsumerState<ProfileEditingScreen> createState() =>
      _ProfileEditingScreenState();
}

class _ProfileEditingScreenState extends ConsumerState<ProfileEditingScreen> {
  String? _selectedDivisionId;
  String? _selectedDistrictId;
  String? _selectedUpazilaId;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _mobileController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Keep initial values for change tracking.
  String? _initialName;
  String? _initialEmail;
  String? _initialMobile;
  String? _initialDivisionId;
  String? _initialDistrictId;
  String? _initialUpazilaId;

  @override
  void initState() {
    super.initState();
    // Trigger the API call after the first frame.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref
          .read(profileControllerProvider.notifier)
          .fetchUserProfile(context: context);
    });

    _nameController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _mobileController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.removeListener(_onFieldChanged);
    _emailController.removeListener(_onFieldChanged);
    _mobileController.removeListener(_onFieldChanged);
    _nameController.dispose();
    _emailController.dispose();
    _mobileController.dispose();
    super.dispose();
  }

  bool get _hasChanges =>
      _nameController.text != (_initialName ?? '') ||
      _emailController.text != (_initialEmail ?? '') ||
      _mobileController.text != (_initialMobile ?? '') ||
      _selectedDivisionId != _initialDivisionId ||
      _selectedDistrictId != _initialDistrictId ||
      _selectedUpazilaId != _initialUpazilaId;

  void _updateUserProfile() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(profileControllerProvider.notifier)
        .updateProfile(
          name: _nameController.text.trim(),
          email: _emailController.text.trim(),
          mobile: _mobileController.text.trim(),
          divisionId: _selectedDivisionId ?? '',
          districtId: _selectedDistrictId ?? '',
          upazilaId: _selectedUpazilaId ?? '',
          context: context,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<dynamic>>(profileControllerProvider, (
      previous,
      next,
    ) {
      next.whenData((profile) {
        if (profile != null) {
          // Update text controllers only if the values have changed
          if (_nameController.text != (profile.name ?? '')) {
            _nameController.text = profile.name ?? '';
          }
          if (_emailController.text != (profile.email ?? '')) {
            _emailController.text = profile.email ?? '';
          }
          if (_mobileController.text != (profile.mobile ?? '')) {
            _mobileController.text = profile.mobile ?? '';
          }
          if (_selectedDivisionId !=
              profile.memberRegistrationInfo?.divisionId) {
            _selectedDivisionId = profile.memberRegistrationInfo?.divisionId;
          }
          if (_selectedDistrictId !=
              profile.memberRegistrationInfo?.districtId) {
            _selectedDistrictId = profile.memberRegistrationInfo?.districtId;
          }
          if (_selectedUpazilaId != profile.memberRegistrationInfo?.upazilaId) {
            _selectedUpazilaId = profile.memberRegistrationInfo?.upazilaId;
          }
          // Save initial values for comparison.
          _initialName = profile.name;
          _initialEmail = profile.email;
          _initialMobile = profile.mobile;
          _initialDivisionId = profile.memberRegistrationInfo?.divisionId;
          _initialDistrictId = profile.memberRegistrationInfo?.districtId;
          _initialUpazilaId = profile.memberRegistrationInfo?.upazilaId;
          setState(() {});
        }
      });
    });

    final profileAsync = ref.watch(profileControllerProvider);
    return profileAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (profile) {
        if (profile == null) {
          return const Center(
            child: Text('''আপনার তথ্য সফলভাবে পরিবর্তন করা হয়েছে।'''),
          );
        }

        final List<District> districtsForSelectedDivision =
            _selectedDivisionId != null
                ? (divisionDistrictsMap[_selectedDivisionId] ?? [])
                : [];
        final List<SubDistrict> subDistrictsForSelectedDistrict =
            _selectedDistrictId != null
                ? (districtSubdistrictMap[_selectedDistrictId] ?? [])
                : [];

        return Theme(
          data: AppThemeData.lightThemeData,
          child: Scaffold(
            body: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            label: Text('নাম'),
                            hintText: 'এখানে লিখুন',
                          ),
                          keyboardType: TextInputType.text,
                          controller: _nameController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'নাম দিন';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20.0),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            label: Text('ইমেইল'),
                            hintText: 'এখানে লিখুন',
                          ),
                          keyboardType: TextInputType.emailAddress,
                          controller: _emailController,
                          enabled: false,
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'ইমেইল দিন';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16.0),
                        TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          decoration: const InputDecoration(
                            label: Text('মোবাইল নম্বর'),
                            hintText: 'এখানে লিখুন',
                          ),
                          keyboardType: TextInputType.number,
                          controller: _mobileController,

                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'মোবাইল নম্বর দিন';
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
                          items:
                              divisionMap.entries.map((entry) {
                                return DropdownMenuItem(
                                  value: entry.value,
                                  child: Text(entry.key),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedDivisionId = value;
                              _selectedDistrictId = null;
                              _selectedUpazilaId = null;
                            });
                          },
                          validator: (value) {
                            if (value == null) return 'বিভাগ দিন';
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
                          onChanged:
                              _selectedDivisionId == null
                                  ? null
                                  : (value) {
                                    setState(() {
                                      _selectedDistrictId = value;
                                      _selectedUpazilaId = null;
                                    });
                                  },
                          items:
                              districtsForSelectedDivision.map((district) {
                                return DropdownMenuItem(
                                  value: district.id,
                                  child: Text(district.name),
                                );
                              }).toList(),
                          validator: (value) {
                            if (_selectedDivisionId == null) {
                              return 'প্রথমে বিভাগ নির্বাচন করুন';
                            }
                            if (value == null) return 'জেলা দিন';
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
                          onChanged:
                              _selectedDistrictId == null
                                  ? null
                                  : (value) {
                                    setState(() {
                                      _selectedUpazilaId = value;
                                    });
                                  },
                          items:
                              subDistrictsForSelectedDistrict.map((
                                subDistrict,
                              ) {
                                return DropdownMenuItem(
                                  value: subDistrict.id,
                                  child: Text(subDistrict.name),
                                );
                              }).toList(),
                          validator: (value) {
                            if (_selectedDistrictId == null) {
                              return 'প্রথমে জেলা নির্বাচন করুন';
                            }
                            if (value == null) return 'উপজেলা দিন';
                            return null;
                          },
                        ),
                        const SizedBox(height: 40.0),
                        ElevatedButton(
                          onPressed:
                              _hasChanges
                                  ? () {
                                    FocusScope.of(context).unfocus();
                                    _updateUserProfile();
                                  }
                                  : null,
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
          ),
        );
      },
    );
  }
}
