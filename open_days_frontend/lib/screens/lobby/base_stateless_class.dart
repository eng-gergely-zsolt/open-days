import 'package:flutter/material.dart';

import './lobby.dart';

class BaseStatelessClass extends StatelessWidget {
  const BaseStatelessClass({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Lobby();
  }
}
