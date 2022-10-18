import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:open_days_frontend/constants/constants.dart';
import 'package:open_days_frontend/modules/home/home_controller.dart';

class Home extends ConsumerWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height -
        MediaQueryData.fromWindow(window).padding.top;

    var homeController = ref.read(homeControllerProvider);
    var user = ref.watch(homeController.getUserProvider());

    return Scaffold(
      body: user.when(
        loading: () => Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            size: appHeight * 0.1,
            color: const Color.fromRGBO(1, 30, 65, 1),
          ),
        ),
        error: (error, stackTrace) => const Center(),
        data: (user) {
          return user.operationResult == operationResultFailure
              ? const Center(
                  child: Text('FAILURE'),
                )
              : const Center(
                  child: Text('SUCCESS'),
                );
        },
      ),
    );
  }
}
