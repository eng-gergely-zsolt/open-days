import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/theme/theme.dart';
import 'package:open_days_frontend/utils/validator_utils.dart';

import '../../utils/user_data_utils.dart';
import './registration_controller.dart';
import '../../constants/constants.dart';
import '../../constants/page_routes.dart';

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
          () => Navigator.pushNamed(
            context,
            emailVerificationRoute,
            arguments: registrationController.getEmail(),
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
              color: const Color.fromRGBO(38, 70, 83, 1),
            ),
          ),
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          data: (institutions) {
            selectedCounty ??= registrationController.getFirstCounty(institutions);

            if (selectedInstitution == null ||
                !UserDataUtils.getInstitutions(selectedCounty, institutions)
                    .contains(selectedInstitution)) {
              selectedInstitution = UserDataUtils.getFirstInstitution(selectedCounty, institutions);
            }

            registrationController.setInstitution(selectedInstitution);

            return isLoading == true
                ? Center(
                    child: LoadingAnimationWidget.staggeredDotsWave(
                      size: appHeight * 0.1,
                      color: const Color.fromRGBO(38, 70, 83, 1),
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
                            TextFormField(
                                maxLength: 50,
                                decoration: InputDecoration(
                                  labelText: appLocale?.first_name,
                                  prefixIcon: Icon(
                                    Icons.person_add_outlined,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                ),
                                onChanged: ((value) {
                                  registrationController.setFirstName(value);
                                }),
                                initialValue: registrationController.getUser().firstName,
                                validator: (value) => registrationController.validateName(value)),
                            TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: appLocale?.last_name,
                                prefixIcon: Icon(
                                  Icons.person_add_alt_outlined,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onChanged: ((value) {
                                registrationController.setLastName(value);
                              }),
                              initialValue: registrationController.getUser().lastName,
                              validator: ((value) => registrationController.validateName(value)),
                            ),
                            TextFormField(
                              maxLength: 50,
                              decoration: InputDecoration(
                                labelText: appLocale?.username,
                                prefixIcon: Icon(
                                  Icons.person_outline,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onChanged: ((value) {
                                registrationController.setUsername(value);
                              }),
                              initialValue: registrationController.getUser().username,
                              validator: ((value) => registrationController.validateName(value)),
                            ),
                            TextFormField(
                              maxLength: 100,
                              decoration: InputDecoration(
                                labelText: appLocale?.email,
                                prefixIcon: Icon(
                                  Icons.alternate_email,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onChanged: ((value) {
                                registrationController.setEmail(value);
                              }),
                              initialValue: registrationController.getUser().email,
                              validator: ((value) => ValidatorUtils.validateEmail(value)),
                            ),
                            TextFormField(
                              maxLength: 30,
                              obscureText: true,
                              decoration: InputDecoration(
                                labelText: appLocale?.password,
                                prefixIcon: Icon(
                                  Icons.password,
                                  color: Theme.of(context).iconTheme.color,
                                ),
                              ),
                              onChanged: ((value) {
                                registrationController.setPassword(value);
                              }),
                              validator: ((value) =>
                                  registrationController.validatePassword(value)),
                              initialValue: registrationController.getUser().password,
                            ),
                            SizedBox(height: appHeight * 0.03),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: CustomTheme.lightTheme.dividerColor,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: appWidth * 0.02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedCounty,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  items: UserDataUtils.getCounties(institutions)
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
                            SizedBox(height: appHeight * 0.05),
                            Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: CustomTheme.lightTheme.dividerColor,
                                  ),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: appWidth * 0.02),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: selectedInstitution,
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: Theme.of(context).iconTheme.color,
                                  ),
                                  items: UserDataUtils.getInstitutions(selectedCounty, institutions)
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
                            SizedBox(height: appHeight * 0.05),
                            ElevatedButton(
                              onPressed: (() {
                                if (_formKey.currentState!.validate()) {
                                  registrationController.createUser();
                                }
                              }),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(appWidth * 0.6, 45),
                              ),
                              child: Text(appLocale?.sign_up.toUpperCase() as String),
                            ),
                            SizedBox(height: appHeight * 0.01),
                            TextButton(
                              child: Text(
                                appLocale?.sign_in_from_here as String,
                                style: TextStyle(color: Theme.of(context).primaryColor),
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pushNamed(context, 'login_route');
                              },
                            )
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
