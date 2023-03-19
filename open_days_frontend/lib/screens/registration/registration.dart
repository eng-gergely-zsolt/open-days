import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../login/login.dart';
import './registration_controller.dart';
import '../../constants/constants.dart';

class Registration extends ConsumerStatefulWidget {
  const Registration({Key? key}) : super(key: key);

  @override
  _RegistrationState createState() => _RegistrationState();
}

class _RegistrationState extends ConsumerState<Registration> {
  static final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    ref.invalidate(registrationControllerProvider);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final registrationController = ref.read(registrationControllerProvider);
    final isLoading = ref.watch(registrationController.getIsLoadingProvider());
    final institutions = ref.watch(registrationController.getInstitutionProvider());

    var selectedCounty = ref.watch(registrationController.getSelectedCountyProvider());
    var selectedInstitution = ref.watch(registrationController.getSelectedInstitutionProvider());

    if (registrationController.getRegistrationResponse() != null) {
      if (registrationController.getRegistrationResponse()?.operationResult ==
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

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }
    }

    registrationController.deleteRegistrationResponse();

    return GestureDetector(
      onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocale?.sign_up as String),
        ),
        body: institutions.when(
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
            selectedCounty ??= registrationController.getFirstCounty(institutions);

            if (selectedInstitution == null ||
                !registrationController
                    .getInstitutions(selectedCounty, institutions)
                    .contains(selectedInstitution)) {
              selectedInstitution =
                  registrationController.getFirstInstitution(selectedCounty, institutions);
            }

            registrationController.setInstitution(selectedInstitution);

            return isLoading == true
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
                                  prefixIcon: const Icon(Icons.person_add_alt_outlined),
                                ),
                                initialValue: registrationController.getUser().firstName,
                                onChanged: ((value) {
                                  registrationController.setFirstName(value);
                                }),
                                validator: (value) => registrationController.validateName(value)),
                            TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: appLocale?.last_name,
                                prefixIcon: const Icon(Icons.person_add_alt_outlined),
                              ),
                              initialValue: registrationController.getUser().lastName,
                              onChanged: ((value) {
                                registrationController.setLastName(value);
                              }),
                              validator: ((value) => registrationController.validateName(value)),
                            ),
                            TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: appLocale?.username,
                                prefixIcon: const Icon(Icons.person_outline),
                              ),
                              initialValue: registrationController.getUser().username,
                              onChanged: ((value) {
                                registrationController.setUsername(value);
                              }),
                              validator: ((value) => registrationController.validateName(value)),
                            ),
                            TextFormField(
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: appLocale?.email,
                                prefixIcon: const Icon(Icons.alternate_email),
                              ),
                              initialValue: registrationController.getUser().email,
                              onChanged: ((value) {
                                registrationController.setEmail(value);
                              }),
                              validator: ((value) => registrationController.validateEmail(value)),
                            ),
                            TextFormField(
                              maxLength: 30,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: appLocale?.password,
                                prefixIcon: const Icon(Icons.password),
                              ),
                              initialValue: registrationController.getUser().password,
                              onChanged: ((value) {
                                registrationController.setPassword(value);
                              }),
                              validator: ((value) =>
                                  registrationController.validatePassword(value)),
                            ),
                            SizedBox(height: appHeight * 0.03),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: appWidth * 0.02),
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
                                  value: selectedCounty,
                                  icon: const Icon(Icons.arrow_downward),
                                  items: registrationController
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
                                        .read(registrationController
                                            .getSelectedCountyProvider()
                                            .notifier)
                                        .state = value;
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: appHeight * 0.03),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: appWidth * 0.02),
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
                                  value: selectedInstitution,
                                  icon: const Icon(Icons.arrow_downward),
                                  items: registrationController
                                      .getInstitutions(selectedCounty, institutions)
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
                                        .read(registrationController
                                            .getSelectedInstitutionProvider()
                                            .notifier)
                                        .state = value;
                                    registrationController.setInstitution(value);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: appHeight * 0.03),
                            ElevatedButton(
                              onPressed: (() {
                                if (_formKey.currentState!.validate()) {
                                  registrationController.createUser();
                                }
                              }),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(appWidth * 0.6, 40),
                              ),
                              child: Text(appLocale?.sign_up.toUpperCase() as String),
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
