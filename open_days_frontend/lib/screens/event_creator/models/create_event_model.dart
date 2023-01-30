import 'package:open_days_frontend/models/event_model.dart';

class CreateEventModel {
  String authorizationToken;
  final event = EventModel();

  CreateEventModel({
    this.authorizationToken = '',
  });
}
