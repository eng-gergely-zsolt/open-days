import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/modules/registration/models/user.dart';
import 'package:open_days_frontend/modules/registration/registration_controller.dart';
import 'package:open_days_frontend/modules/lobby/lobby.dart';

class ErrorPage extends ConsumerWidget {
  final User user;
  const ErrorPage({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.invalidate(createUserProvider(user));
    final response = ref.watch(createUserProvider(user));

    return response.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (error, stackTrace) => Center(
        child: Text(error.toString()),
      ),
      data: (response) {
        if (response.operationResult == 'SUCCESS') {
          Future.microtask(
            () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Lobby()),
            ),
          );
        }

        return Scaffold(
          body: Center(child: Text(response.message)),
        );
      },
    );
  }
}
