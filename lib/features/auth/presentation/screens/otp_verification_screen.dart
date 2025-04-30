import 'package:bjp_app/config/app_theme_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:otp_timer_button/otp_timer_button.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../config/app_colors.dart';
import '../controllers/auth_controller.dart';

class OtpVeificationScreen extends ConsumerStatefulWidget {
  const OtpVeificationScreen({super.key, required this.email});

  final String email;

  @override
  ConsumerState<OtpVeificationScreen> createState() =>
      _OtpVeificationScreenState();
}

class _OtpVeificationScreenState extends ConsumerState<OtpVeificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final OtpTimerButtonController controller = OtpTimerButtonController();

  void _verifyOTP() {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      ref
          .read(authControllerProvider.notifier)
          .verifyOTP(
            context,
            email: widget.email,
            otp: _otpController.text.trim(),
          );

      // Navigation handled by GoRouter redirect method automatically
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  //AppLogoWidget(),
                  SizedBox(height: 20),
                  Text(
                    'আপনার ইমেইল যাচাই করুন',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  // Text(
                  //   'A 6 Digit OTP Code has been Sent',
                  //   style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  //         color: Colors.grey,
                  // ),
                  // ),
                  SizedBox(height: 24.0),
                  PinCodeTextField(
                    length: 6,
                    obscureText: false,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.box,
                      borderRadius: BorderRadius.circular(8),
                      //fieldHeight: 50,
                      // fieldWidth: 40,
                      activeFillColor: AppColors.themeColor,
                      selectedFillColor: AppColors.themeColor,
                      inactiveColor: AppColors.themeColor,
                      selectedColor: AppColors.themeColor,
                    ),
                    animationDuration: Duration(milliseconds: 300),
                    keyboardType: TextInputType.number,
                    //enableActiveFill: true,
                    appContext: context,
                    controller: _otpController,
                  ),
                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _verifyOTP,
                    child: Text(
                      'পরবর্তী',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 24.0),
                  RichText(
                    text: TextSpan(
                      text: 'এই কোডটির মেয়াদ শেষ হবে ',
                      style: TextStyle(color: Colors.grey),
                      children: [
                        TextSpan(
                          text: '৩০ সে.',
                          style: TextStyle(color: AppColors.themeColor),
                        ),
                      ],
                    ),
                  ),
                  // TextButton(
                  //   onPressed: () {},
                  //   child: Text('Resend Code'),
                  // ),
                  OtpTimerButton(
                    controller: controller,
                    onPressed: () {},
                    text: Text('পুনরায় পাঠান'),
                    duration: 30,
                    buttonType: ButtonType.text_button,
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
