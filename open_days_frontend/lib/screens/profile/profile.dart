import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import '../error/base_error.dart';
import './profile_controller.dart';
import '../../constants/page_routes.dart';
import '../../utils/helper_widget_utils.dart';
import '../home_base/home_base_controller.dart';
import './models/name_modification_payload.dart';
import '../../models/responses/user_response.dart';
import './models/username_modification_payload.dart';
import './models/institution_modification_payload.dart';

class Profile extends ConsumerWidget {
  final UserResponse _user;
  final HomeBaseController _homeBaseController;
  static const _localPlaceholderImage = 'lib/assets/images/user_image_placeholder.jpg';

  const Profile(this._user, this._homeBaseController, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(profileControllerProvider);

    ref.watch(controller.getForcedReload());
    final imagePath = ref.watch(controller.getImagePathProvider());
    final isClosingPageRequired = ref.watch(controller.getIsClosingPageRequired());
    final isOperationInProgress = ref.watch(controller.getIsOperationInProgress());
    final imageLink = ref.watch(controller.createImagPathProvider(_user.imagePath));

    if (isClosingPageRequired == true) {
      Future.microtask((() {
        controller.invalidateProfileControllerProvider();

        Navigator.pop(context);
        Navigator.pushNamed(context, lobbyRoute);
      }));
    }

    if (controller.getUpdateImagePathResponse() != null) {
      if (controller.getUpdateImagePathResponse()?.isOperationSuccessful == false) {
        final snackBar = SnackBar(
          content: Text(controller.getUpdateImagePathResponse()?.error.errorMessage as String),
        );

        Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));
      }

      controller.deleteUpdateImagePathResponse();
    }

    return isOperationInProgress
        ? Center(
            child: LoadingAnimationWidget.staggeredDotsWave(
              size: appHeight * 0.1,
              color: const Color.fromRGBO(38, 70, 83, 1),
            ),
          )
        : imageLink.when(
            data: ((activities) {
              return SizedBox(
                width: appWidth * 1,
                height: appHeight * 0.83,
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Column(
                      children: [
                        Container(
                          height: appHeight * 0.2,
                          color: CustomTheme.lightTheme.primaryColor,
                        ),
                        Container(
                          width: double.infinity,
                          height: appHeight * 0.62,
                          margin: EdgeInsets.symmetric(horizontal: appWidth * 0.05),
                          child: SingleChildScrollView(
                            child:
                                getDataColumn(appWidth, appHeight, context, appLocale, controller),
                          ),
                        ),
                      ],
                    ),
                    Positioned(
                      top: appHeight * 0.05,
                      child: GestureDetector(
                        onTap: () async {
                          await controller.selectImage(_user.id, _user.imagePath);
                          if (controller.getImagePathInDB() != "") {
                            _user.imagePath = controller.getImagePathInDB();
                            _homeBaseController.setImagePath(controller.getImagePathInDB());
                          }
                        },
                        child: ClipOval(
                          child: imagePath == ''
                              ? FadeInImage.assetNetwork(
                                  fit: BoxFit.cover,
                                  width: appHeight * 0.2,
                                  height: appHeight * 0.2,
                                  placeholder: _localPlaceholderImage,
                                  image: controller.getImageUrl(),
                                )
                              : Image.file(
                                  File(imagePath),
                                  fit: BoxFit.fill,
                                  width: appHeight * 0.2,
                                  height: appHeight * 0.2,
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            error: (error, stackTrace) => const BaseError(),
            loading: () => HelperWidgetUtils.getStaggeredDotsWaveAnimation(appHeight),
          );
  }

  Widget getDataColumn(
    double appWidth,
    double appHeight,
    BuildContext context,
    AppLocalizations? appLocale,
    ProfileController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Name
        SizedBox(height: appHeight * 0.05),
        Text(
          appLocale?.profile_name as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        Row(
          children: [
            Text(
              _user.firstName + ' ' + _user.lastName,
              style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                NameModificationPayload payload = NameModificationPayload(
                  id: _user.id,
                  lastName: _user.lastName,
                  firstName: _user.firstName,
                );

                NameModificationPayload result = await Navigator.pushNamed(
                  context,
                  nameModificationRoute,
                  arguments: payload,
                ) as NameModificationPayload;

                _user.lastName = result.lastName;
                _user.firstName = result.firstName;
                _homeBaseController.setLastName(result.lastName);
                _homeBaseController.setFirstName(result.firstName);
                controller.setForcedReload();
              },
            )
          ],
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: CustomTheme.lightTheme.dividerColor,
        ),

        // Username
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.profile_username as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        Row(
          children: [
            Text(
              _user.username,
              style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                UsernameModificationPayload payload = UsernameModificationPayload(
                  id: _user.id,
                  username: _user.username,
                );

                UsernameModificationPayload result = await Navigator.pushNamed(
                  context,
                  usernameModificationRoute,
                  arguments: payload,
                ) as UsernameModificationPayload;

                _user.username = result.username;
                _homeBaseController.setUsername(result.username);
                controller.setForcedReload();
              },
            )
          ],
        ),
        Container(
          height: 1,
          width: double.infinity,
          color: CustomTheme.lightTheme.dividerColor,
        ),

        // County
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.profile_county as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        Text(
          _user.county,
          style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
            fontSize: 18,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        Container(
          height: 1,
          width: double.infinity,
          color: CustomTheme.lightTheme.dividerColor,
        ),

        // Institution
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.profile_institution as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        Row(
          children: [
            Text(
              _user.institution,
              style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
                fontSize: 18,
              ),
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () async {
                InstitutionModificationPayload payload = InstitutionModificationPayload(
                  id: _user.id,
                  county: _user.county,
                  institution: _user.institution,
                );

                InstitutionModificationPayload result = await Navigator.pushNamed(
                  context,
                  institutionModificationRoute,
                  arguments: payload,
                ) as InstitutionModificationPayload;

                _user.county = result.county;
                _user.institution = result.institution;
                _homeBaseController.setCounty(result.county);
                _homeBaseController.setInstitution(result.institution);

                controller.setForcedReload();
              },
            )
          ],
        ),
        SizedBox(height: appHeight * 0.01),
        Container(
          height: 1,
          width: double.infinity,
          color: CustomTheme.lightTheme.dividerColor,
        ),

        // Institution
        SizedBox(height: appHeight * 0.03),
        Text(
          appLocale?.profile_email as String,
          style: CustomTheme.lightTheme.textTheme.bodyText2?.copyWith(
            fontWeight: FontWeight.w600,
            color: CustomTheme.lightTheme.hintColor,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        Text(
          _user.email,
          style: CustomTheme.lightTheme.textTheme.bodyText1?.copyWith(
            fontSize: 18,
          ),
        ),
        SizedBox(height: appHeight * 0.01),
        Container(
          height: 1,
          width: double.infinity,
          color: CustomTheme.lightTheme.dividerColor,
        ),

        // Log out button
        SizedBox(height: appHeight * 0.03),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              child: Text(
                appLocale?.profile_sign_out.toUpperCase() as String,
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(appWidth * 0.6, 45),
              ),
              onPressed: () {
                controller.logOut();
              },
            ),
          ],
        ),
        SizedBox(height: appHeight * 0.01),
      ],
    );
  }
}
