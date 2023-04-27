import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../theme/theme.dart';
import '../../../utils/helper_widget_utils.dart';
import '../../../utils/user_data_utils.dart';
import './institution_modification_controller.dart';
import '../models/institution_modification_payload.dart';

class InstitutionModification extends ConsumerWidget {
  final InstitutionModificationPayload payload;

  const InstitutionModification(this.payload, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(institutionModificationControllerProvider);

    final isLoading = ref.watch(controller.getLoadingProvider());
    final institutions = ref.watch(controller.getInstitutionsProvider());

    var selectedCounty = ref.watch(controller.getSelectedCountyProvider());
    var selectedInstitution = ref.watch(controller.getSelectedInstitutionProvider());

    controller.setPayload(payload);
    controller.setSelectedValuesInitially(payload.county, payload.institution);

    if (controller.getUpdateInstitutionResponse() != null) {
      if (controller.getUpdateInstitutionResponse()?.isOperationSuccessful == true) {
        Future.microtask(() {
          InstitutionModificationPayload result = InstitutionModificationPayload(
            id: payload.id,
            county: controller.getSelectedCounty(),
            institution: controller.getSelectedInstitution(),
          );

          Navigator.pop(context, result);
        });
      } else {
        final snackBar = SnackBar(
          content: Text(controller.getUpdateInstitutionResponse()?.error.errorMessage as String),
        );

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }

      controller.deleteUpdateInstitutionResponse();
    }

    return WillPopScope(
      onWillPop: (() {
        Navigator.pop(context, payload);
        return Future.value(true);
      }),
      child: Scaffold(
        appBar: AppBar(
          title: Text(appLocale?.profile_name as String),
        ),
        body: institutions.when(
          data: (institutions) {
            selectedCounty = controller.getSelectedCounty();
            selectedInstitution = controller.getSelectedInstitutionOnCountyChange();

            return isLoading
                ? HelperWidgetUtils.getStaggeredDotsWaveAnimation(appHeight)
                : Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
                      SizedBox(height: appHeight * 0.1),
                      Text(
                        appLocale?.profile_institution_modification_title as String,
                        style: CustomTheme.lightTheme.textTheme.headline5,
                      ),

                      // County
                      SizedBox(height: appHeight * 0.05),
                      DropdownButton<String>(
                        isExpanded: true,
                        value: selectedCounty,
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Theme.of(context).iconTheme.color,
                        ),
                        items:
                            UserDataUtils.getCounties(institutions).map<DropdownMenuItem<String>>(
                          (String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          },
                        ).toList(),
                        onChanged: (String? value) {
                          controller.setSelectedCountyProvider(value);
                        },
                      ),

                      // Institution
                      SizedBox(height: appHeight * 0.05),
                      DropdownButton<String>(
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
                          controller.setSelectedInstitutionProvider(value);
                        },
                      ),

                      // Confirm button
                      SizedBox(height: appHeight * 0.05),
                      controller.getConfirmAllowed()
                          ? ElevatedButton(
                              child: Text(
                                appLocale?.profile_confirm.toUpperCase() as String,
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(appWidth * 0.6, 45),
                              ),
                              onPressed: () {
                                controller.updateInstitution();
                              },
                            )
                          : ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                appLocale?.profile_confirm.toUpperCase() as String,
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(appWidth * 0.6, 45),
                                backgroundColor: CustomTheme.lightTheme.hintColor,
                              ),
                            ),
                    ]),
                  );
          },
          error: (error, stackTrace) => Center(
            child: Text(error.toString()),
          ),
          loading: () => Center(
            child: HelperWidgetUtils.getStaggeredDotsWaveAnimation(appHeight),
          ),
        ),
      ),
    );
  }
}
