import 'package:bjp_app/config/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';

class EnterEmailScreen extends ConsumerStatefulWidget {
  const EnterEmailScreen({super.key});

  @override
  ConsumerState<EnterEmailScreen> createState() => _EnterEmailScreenState();
}

class _EnterEmailScreenState extends ConsumerState<EnterEmailScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _sendOTPToEmail() {
    if (!_formKey.currentState!.validate()) return;

    final email = _emailController.text.trim();
    ref
        .read(authControllerProvider.notifier)
        .sendOTPToEmail(context, email: email);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return Theme(
      data: AppThemeData.lightThemeData,
      child: Scaffold(
        appBar: AppBar(
          // leading: IconButton(
          //   icon: Icon(Icons.arrow_back),
          //   onPressed: () {
          //     context.pop();
          //   },
          // ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  SizedBox(height: 80),
                  Text(
                    'ইমেইল দিন',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: 50.0),
                  TextFormField(
                    controller: _emailController,
                    autofillHints: [AutofillHints.email],
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      label: Text('ইমেইল'),
                      hintText: 'এখানে লিখুন',
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (email) {
                      if (email == null || email.isEmpty) {
                        return 'ইমেইল দিন';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: authState.isLoading ? null : _sendOTPToEmail,
                    child:
                        authState.isLoading
                            ? CircularProgressIndicator()
                            : Text('পরবর্তী'),
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
