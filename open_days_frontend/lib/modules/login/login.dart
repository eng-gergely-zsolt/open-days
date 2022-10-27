import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/modules/home_base/home_base.dart';
import 'package:open_days_frontend/modules/login/login_controller.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Login extends ConsumerWidget {
  const Login({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appLocale = AppLocalizations.of(context);

    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top;

    var loginController = ref.read(loginControllerProvider);
    var isLoading = ref.watch(loginController.getIsLoadinProvider());

    if (loginController.getLoginResponse() != null) {
      if (loginController.getLoginResponse()?.operationResult ==
          operationResultSuccess) {
        Future.microtask(() => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeBase()),
            ));
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong. Please try again!'),
        );

        Future.microtask(
            () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }
    }

    loginController.deleteResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)?.login as String),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(1, 30, 65, 1),
                ),
              )
            : Container(
                padding: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                child: Form(
                  key: _formKey,
                  child: SingleChildScrollView(
                    child: Column(children: [
                      SizedBox(height: appHeight * 0.2),
                      TextFormField(
                        maxLength: 50,
                        initialValue: loginController.getUsername(),
                        decoration: InputDecoration(
                          labelText: appLocale?.username,
                          prefixIcon: const Icon(Icons.person),
                        ),
                        onChanged: ((value) =>
                            loginController.setUsername(value)),
                        validator: (value) {
                          return loginController.validateUsername(value);
                        },
                      ),
                      TextFormField(
                        maxLength: 50,
                        obscureText: true,
                        initialValue: loginController.getPassword(),
                        decoration: InputDecoration(
                          labelText: appLocale?.password,
                          prefixIcon: const Icon(Icons.password),
                        ),
                        onChanged: ((value) =>
                            loginController.setPassword(value)),
                        validator: (value) {
                          return loginController.validatePassword(value);
                        },
                      ),
                      SizedBox(height: appHeight * 0.05),
                      ElevatedButton(
                        child: Text(appLocale?.login.toUpperCase() as String),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(appWidth * 0.6, 40),
                        ),
                        onPressed: (() {
                          if (_formKey.currentState!.validate()) {
                            loginController.loginUser();
                          }
                        }),
                      ),
                    ]),
                  ),
                ),
              ),
      ),
    );
  }
}
