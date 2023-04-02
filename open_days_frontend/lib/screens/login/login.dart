import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import './login_controller.dart';
import '../../constants/constants.dart';
import '../../constants/page_routes.dart';

class Login extends ConsumerWidget {
  const Login({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final loginController = ref.read(loginControllerProvider);
    final isLoading = ref.watch(loginController.getIsLoadinProvider());

    if (loginController.getLoginResponse() != null) {
      if (loginController.getLoginResponse()?.operationResult == operationResultSuccess) {
        Future.microtask(() {
          Navigator.pop(context);
          Navigator.pushNamed(context, homeBaseRoute);
        });
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong. Please try again!'),
        );

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }
    }

    loginController.deleteResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            appLocale?.sign_in as String,
          ),
        ),
        body: isLoading == true
            ? Center(
                child: LoadingAnimationWidget.staggeredDotsWave(
                  size: appHeight * 0.1,
                  color: const Color.fromRGBO(38, 70, 83, 1),
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
                          prefixIcon: Icon(
                            Icons.person,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        validator: (value) {
                          return loginController.validateUsername(value);
                        },
                        onChanged: ((value) => loginController.setUsername(value)),
                      ),
                      TextFormField(
                        maxLength: 50,
                        obscureText: true,
                        initialValue: loginController.getPassword(),
                        decoration: InputDecoration(
                          labelText: appLocale?.password,
                          prefixIcon: Icon(
                            Icons.password,
                            color: Theme.of(context).iconTheme.color,
                          ),
                        ),
                        validator: (value) {
                          return loginController.validatePassword(value);
                        },
                        onChanged: ((value) => loginController.setPassword(value)),
                      ),
                      SizedBox(height: appHeight * 0.05),
                      ElevatedButton(
                        child: Text(appLocale?.sign_in.toUpperCase() as String),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(appWidth * 0.6, 45),
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
