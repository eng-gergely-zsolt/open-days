import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import '../../utils/validator_utils.dart';
import '../../constants/page_routes.dart';
import './email_verification_controller.dart';

class EmailVerification extends ConsumerWidget {
  final String email;
  static final _formKey = GlobalKey<FormState>();

  const EmailVerification(this.email, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(emailVerificationControllerProvider);

    final firstDigit = ref.watch(controller.getFirstDigitProvider());
    final secondDigit = ref.watch(controller.getSecondDigitProvider());
    final thirdDigit = ref.watch(controller.getThirdDigitProvider());
    final fourthDigit = ref.watch(controller.getFourthDigitProvider());

    final isLoading = ref.watch(controller.getIsLoadinProvider());
    final emailVerificationRespons = controller.getEmailVerificationResponse();

    if (emailVerificationRespons != null) {
      if (emailVerificationRespons.isOperationSuccessful) {
        Future.microtask(() {
          Navigator.pop(context);
          Navigator.pushNamed(context, loginRoute);
        });
      } else {
        final snackBar = SnackBar(
          content: emailVerificationRespons.errorMessage == null
              ? Text(appLocale?.base_text_general_try_again_message as String)
              : Text(emailVerificationRespons.errorMessage as String),
        );

        Future.microtask(() {
          controller.setFirstDigitProvider("");
          controller.setSecondDigitProvider("");
          controller.setThirdDigitProvider("");
          controller.setFourthDigitProvider("");
        });

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }

      controller.deleteEmailVerificationResponse();
    }

    return WillPopScope(
      onWillPop: () => controller.invalidateController(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocale?.email_verification_header as String),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(38, 70, 83, 1),
                ),
              )
            : Container(
                margin: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: appHeight * 0.05),
                      Text(
                        appLocale?.email_verification_header as String,
                        textAlign: TextAlign.center,
                        style: CustomTheme.lightTheme.textTheme.headline4
                            ?.copyWith(color: CustomTheme.lightTheme.primaryColor),
                      ),
                      SizedBox(height: appHeight * 0.01),
                      Text(
                        appLocale?.email_verification_subtitle as String,
                        style: CustomTheme.lightTheme.textTheme.bodyText1
                            ?.copyWith(color: CustomTheme.lightTheme.iconTheme.color),
                      ),
                      SizedBox(height: appHeight * 0.1),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              maxLength: 100,
                              initialValue: email,
                              decoration: InputDecoration(
                                labelText: appLocale?.email,
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              validator: ((value) => ValidatorUtils.validateEmail(value)),
                            ),
                            SizedBox(height: appHeight * 0.1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: appWidth * 0.18,
                                  height: appWidth * 0.18,
                                  decoration: firstDigit == ""
                                      ? BoxDecoration(
                                          color: CustomTheme.lightTheme.cardColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        )
                                      : BoxDecoration(
                                          color: CustomTheme.lightTheme.primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        ),
                                  child: Center(
                                    child: TextFormField(
                                      autofocus: true,
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: CustomTheme.lightTheme.textTheme.headline4?.copyWith(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                        controller.setFirstDigitProvider(value);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: appWidth * 0.18,
                                  height: appWidth * 0.18,
                                  decoration: secondDigit == ""
                                      ? BoxDecoration(
                                          color: CustomTheme.lightTheme.cardColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        )
                                      : BoxDecoration(
                                          color: CustomTheme.lightTheme.primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        ),
                                  child: Center(
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: CustomTheme.lightTheme.textTheme.headline4?.copyWith(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                        controller.setSecondDigitProvider(value);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: appWidth * 0.18,
                                  height: appWidth * 0.18,
                                  decoration: thirdDigit == ""
                                      ? BoxDecoration(
                                          color: CustomTheme.lightTheme.cardColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        )
                                      : BoxDecoration(
                                          color: CustomTheme.lightTheme.primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        ),
                                  child: Center(
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: CustomTheme.lightTheme.textTheme.headline4?.copyWith(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        if (value.length == 1) {
                                          FocusScope.of(context).nextFocus();
                                        }
                                        controller.setThirdDigitProvider(value);
                                      },
                                    ),
                                  ),
                                ),
                                Container(
                                  width: appWidth * 0.18,
                                  height: appWidth * 0.18,
                                  decoration: fourthDigit == ""
                                      ? BoxDecoration(
                                          color: CustomTheme.lightTheme.cardColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        )
                                      : BoxDecoration(
                                          color: CustomTheme.lightTheme.primaryColor,
                                          borderRadius: const BorderRadius.all(Radius.circular(50)),
                                        ),
                                  child: Center(
                                    child: TextFormField(
                                      cursorColor: Colors.white,
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      style: CustomTheme.lightTheme.textTheme.headline4?.copyWith(
                                        color: Colors.white,
                                      ),
                                      decoration: const InputDecoration(
                                        focusedBorder: InputBorder.none,
                                        enabledBorder: InputBorder.none,
                                      ),
                                      inputFormatters: [
                                        LengthLimitingTextInputFormatter(1),
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      onChanged: (value) {
                                        if (value.length == 1) {
                                          FocusScope.of(context).unfocus();
                                        }
                                        controller.setFourthDigitProvider(value);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: appHeight * 0.1),
                      controller.isAllGigitGiven()
                          ? ElevatedButton(
                              child: Text(appLocale?.email_verification_main_button.toUpperCase()
                                  as String),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(double.infinity, 55),
                                backgroundColor: CustomTheme.lightTheme.primaryColor,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: (() {
                                if (_formKey.currentState!.validate()) {
                                  controller.verifyEmailByOtpCode(email);
                                }
                              }),
                            )
                          : ElevatedButton(
                              child: Text(appLocale?.email_verification_main_button.toUpperCase()
                                  as String),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey,
                                minimumSize: const Size(double.infinity, 55),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              onPressed: (() {}),
                            ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
