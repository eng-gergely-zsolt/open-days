import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/modules/login/login.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:open_days_frontend/modules/registration/registration_controller.dart';

class Registration extends ConsumerWidget {
  const Registration({Key? key}) : super(key: key);
  static final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var appLocale = AppLocalizations.of(context);

    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top;

    var _registrationController = ref.read(registrationControllerProvider);

    var _institutions =
        ref.watch(_registrationController.getInstitutionProvider());

    var _selectedCounty =
        ref.watch(_registrationController.getSelectedCountyProvider());

    var _selectedInstitution =
        ref.watch(_registrationController.getSelectedInstitutionProvider());

    var _isLoading = ref.watch(_registrationController.getIsLoadingProvider());

    if (_registrationController.getRegistrationResponse() != null) {
      if (_registrationController.getRegistrationResponse()?.operationResult ==
          operationResultSuccess) {
        Future.microtask(
          () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Login()),
          ),
        );
      } else {
        const snackBar = SnackBar(
          content: Text('Something went wrong. Please try again!'),
        );

        Future.microtask(
            () => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }
    }

    _registrationController.deleteRegistrationResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocale?.sign_up as String),
        ),
        body: _institutions.when(
          loading: () => Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: appHeight * 0.1,
              color: const Color.fromRGBO(1, 30, 65, 1),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          data: (institutions) {
            _selectedCounty ??=
                _registrationController.getFirstCounty(institutions);

            if (_selectedInstitution == null ||
                !_registrationController
                    .getInstitutions(_selectedCounty, institutions)
                    .contains(_selectedInstitution)) {
              _selectedInstitution = _registrationController
                  .getFirstInstitution(_selectedCounty, institutions);
            }

            _registrationController.setInstitution(_selectedInstitution);

            return _isLoading == true
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      size: appHeight * 0.1,
                      color: const Color.fromRGBO(1, 30, 65, 1),
                    ),
                  )
                : Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                    child: SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: appHeight * 0.05),
                            TextFormField(
                                maxLength: 50,
                                decoration: InputDecoration(
                                  labelText: appLocale?.first_name,
                                  prefixIcon:
                                      const Icon(Icons.person_add_alt_outlined),
                                ),
                                initialValue:
                                    _registrationController.getUser().firstName,
                                onChanged: ((value) {
                                  _registrationController.setFirstName(value);
                                }),
                                validator: (value) {
                                  _registrationController.validateName(value);
                                }),
                            TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: appLocale?.last_name,
                                prefixIcon:
                                    const Icon(Icons.person_add_alt_outlined),
                              ),
                              initialValue:
                                  _registrationController.getUser().lastName,
                              onChanged: ((value) {
                                _registrationController.setLastName(value);
                              }),
                              validator: ((value) =>
                                  _registrationController.validateName(value)),
                            ),
                            TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: appLocale?.username,
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              initialValue:
                                  _registrationController.getUser().username,
                              onChanged: ((value) {
                                _registrationController.setUsername(value);
                              }),
                              validator: ((value) =>
                                  _registrationController.validateName(value)),
                            ),
                            TextFormField(
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: appLocale?.email,
                                prefixIcon: const Icon(Icons.alternate_email),
                              ),
                              initialValue:
                                  _registrationController.getUser().email,
                              onChanged: ((value) {
                                _registrationController.setEmail(value);
                              }),
                              validator: ((value) =>
                                  _registrationController.validateEmail(value)),
                            ),
                            TextFormField(
                              maxLength: 30,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: appLocale?.password,
                                prefixIcon: const Icon(Icons.password),
                              ),
                              initialValue:
                                  _registrationController.getUser().password,
                              onChanged: ((value) {
                                _registrationController.setPassword(value);
                              }),
                              validator: ((value) => _registrationController
                                  .validatePassword(value)),
                            ),
                            SizedBox(height: appHeight * 0.03),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: appWidth * 0.02),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedCounty,
                                  icon: const Icon(Icons.arrow_downward),
                                  items: _registrationController
                                      .getCounties(institutions)
                                      .map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? value) {
                                    ref
                                        .read(_registrationController
                                            .getSelectedCountyProvider()
                                            .notifier)
                                        .state = value;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: appHeight * 0.03),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: appWidth * 0.02),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 2,
                                  color: Colors.grey,
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: _selectedInstitution,
                                  icon: const Icon(Icons.arrow_downward),
                                  items: _registrationController
                                      .getInstitutions(
                                          _selectedCounty, institutions)
                                      .map<DropdownMenuItem<String>>(
                                    (String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? value) {
                                    ref
                                        .read(_registrationController
                                            .getSelectedInstitutionProvider()
                                            .notifier)
                                        .state = value;
                                    _registrationController
                                        .setInstitution(value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: appHeight * 0.03),
                            ElevatedButton(
                              onPressed: (() {
                                if (_formKey.currentState!.validate()) {
                                  _registrationController.createUser();
                                }
                              }),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(appWidth * 0.6, 40),
                              ),
                              child: Text(appLocale?.sign_up as String),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
