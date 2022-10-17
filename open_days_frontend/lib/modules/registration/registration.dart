import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/models/response_model.dart';
import 'package:open_days_frontend/modules/registration/registration_controller.dart';
import 'package:open_days_frontend/modules/registration/models/institution.dart';
import 'package:open_days_frontend/modules/error_page.dart';

final selectedCountyProvider = StateProvider<String?>((ref) => null);
final selectedInstitutionProvider = StateProvider<String?>((ref) => null);

class Registration extends ConsumerWidget {
  const Registration({Key? key}) : super(key: key);
  static final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top;

    AsyncValue<List<Institution>> institutions = ref.watch(institutionProvider);
    String? selectedCounty = ref.watch(selectedCountyProvider);
    String? selectedInstitution = ref.watch(selectedInstitutionProvider);

    ResponseModel? response =
        ref.read(registrationControllerProvider).getResponse();

    return institutions.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      data: (institutions) {
        selectedCounty ??= getFirstCounty(ref, institutions);

        if (selectedInstitution == null ||
            !getInstitutions(ref, selectedCounty, institutions)
                .contains(selectedInstitution)) {
          selectedInstitution =
              getFirstInstitution(ref, selectedCounty, institutions);
        }

        ref
            .read(registrationControllerProvider)
            .setInstitution(selectedInstitution);

        return GestureDetector(
          onTap: (() => FocusScope.of(context).requestFocus(FocusNode())),
          child: Scaffold(
            appBar: AppBar(
              title: const Text('Registration'),
            ),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    children: [
                      SizedBox(height: appHeight * 0.05),
                      TextFormField(
                          maxLength: 50,
                          decoration: const InputDecoration(
                            labelText: 'Fist name',
                            prefixIcon: Icon(Icons.person_add_alt_outlined),
                          ),
                          onChanged: ((value) {
                            ref
                                .read(registrationControllerProvider)
                                .setFirstName(value);
                          }),
                          validator: (value) {
                            return null;
                            ref
                                .read(registrationControllerProvider)
                                .validateName(value);
                          }),
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Last name',
                          prefixIcon: Icon(Icons.person_add_alt_outlined),
                        ),
                        onChanged: ((value) {
                          ref
                              .read(registrationControllerProvider)
                              .setLastName(value);
                        }),
                        validator: ((value) => ref
                            .read(registrationControllerProvider)
                            .validateName(value)),
                      ),
                      TextFormField(
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Username',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        onChanged: ((value) {
                          ref
                              .read(registrationControllerProvider)
                              .setUsername(value);
                        }),
                        validator: ((value) => ref
                            .read(registrationControllerProvider)
                            .validateName(value)),
                      ),
                      TextFormField(
                        maxLength: 100,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.alternate_email),
                        ),
                        onChanged: ((value) {
                          ref
                              .read(registrationControllerProvider)
                              .setEmail(value);
                        }),
                        validator: ((value) => ref
                            .read(registrationControllerProvider)
                            .validateEmail(value)),
                      ),
                      TextFormField(
                        maxLength: 30,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Password',
                          prefixIcon: Icon(Icons.password),
                        ),
                        onChanged: ((value) {
                          ref
                              .read(registrationControllerProvider)
                              .setPassword(value);
                        }),
                        validator: ((value) => ref
                            .read(registrationControllerProvider)
                            .validatePassword(value)),
                      ),
                      SizedBox(height: appHeight * 0.03),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: appWidth * 0.02),
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
                            items: getCounties(ref, institutions)
                                .map<DropdownMenuItem<String>>(
                              (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              },
                            ).toList(),
                            onChanged: (String? value) {
                              ref.read(selectedCountyProvider.notifier).state =
                                  value;
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: appHeight * 0.03),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: appWidth * 0.02),
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
                            items: getInstitutions(
                                    ref, selectedCounty, institutions)
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
                                  .read(selectedInstitutionProvider.notifier)
                                  .state = value;
                              ref
                                  .read(registrationControllerProvider)
                                  .setInstitution(value);
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: appHeight * 0.03),
                      ElevatedButton(
                        onPressed: (() {
                          if (formKey.currentState!.validate()) {
                            ref.refresh(createUserProvider(ref
                                .read(registrationControllerProvider)
                                .getUser()));
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ErrorPage(
                                    user: ref
                                        .read(registrationControllerProvider)
                                        .getUser()),
                              ),
                            );
                          }
                        }),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(appWidth * 0.6, 40),
                        ),
                        child: const Text('Register'),
                      ),
                    ],
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

List<String> getCounties(WidgetRef ref, List<Institution> institutions) {
  return ref.read(registrationControllerProvider).getCounties(institutions);
}

String getFirstCounty(WidgetRef ref, List<Institution> institutions) {
  return ref.read(registrationControllerProvider).getFirstCounty(institutions);
}

List<String> getInstitutions(
    WidgetRef ref, String? selectedCounty, List<Institution> institutions) {
  return ref
      .read(registrationControllerProvider)
      .getInstituions(selectedCounty, institutions);
}

String getFirstInstitution(
    WidgetRef ref, String? selectedCounty, List<Institution> institutions) {
  return ref
      .read(registrationControllerProvider)
      .getFirstInstitution(selectedCounty, institutions);
}
