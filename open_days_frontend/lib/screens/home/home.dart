import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import './home_controller.dart';
import '../../constants/constants.dart';
import '../event_details/event_details.dart';
import '../home_base/home_base_controller.dart';
import '../home_base/models/initial_data_model.dart';

class Home extends ConsumerStatefulWidget {
  final InitialDataModel? _initialData;
  final HomeBaseController _homeBaseController;

  const Home(
      {Key? key,
      required InitialDataModel? initialDataModel,
      required HomeBaseController homeBaseController})
      : _initialData = initialDataModel,
        _homeBaseController = homeBaseController,
        super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final homeController = ref.read(homeControllerProvider);
    final homeBaseController = ref.read(homeBaseControllerProvider);

    return Container(
      color: const Color.fromRGBO(220, 220, 220, 0.7),
      child: ListView.builder(
          itemCount: widget._initialData?.events?.events.length,
          itemBuilder: (context, index) {
            final event = widget._initialData?.events?.events[index];
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: ((context) => EventDetails(
                        widget._initialData?.events?.events[index],
                        widget._initialData?.user?.roleName,
                      )),
                ),
              ),
              child: Container(
                height: appHeight * 0.2,
                margin: EdgeInsets.all(appWidth * 0.01),
                child: Card(
                  elevation: 5,
                  shadowColor: const Color.fromRGBO(1, 30, 65, 1),
                  child: Row(children: [
                    Container(
                      margin: EdgeInsets.only(left: appWidth * 0.05),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event?.activityName as String,
                            style: TextStyle(
                              fontSize: appHeight * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            event?.dateTime as String,
                            style: TextStyle(
                              fontSize: appHeight * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            (event?.organizerFirstName as String) +
                                ' ' +
                                (event?.organizerFirstName as String),
                            style: TextStyle(
                              fontSize: appHeight * 0.025,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    widget._initialData?.user?.roleName == roleOrganizer
                        ? Row(children: [
                            IconButton(
                              icon: const Icon(
                                Icons.delete,
                              ),
                              onPressed: () {
                                homeController.deleteEvent(
                                    widget._initialData?.events?.events[index].id as int,
                                    homeBaseController);
                                setState(() {
                                  widget._initialData?.events?.events.removeWhere((element) =>
                                      element.id == widget._initialData?.events?.events[index].id);
                                });
                              },
                            ),
                            SizedBox(width: appWidth * 0.1),
                          ])
                        : const SizedBox.shrink(),
                    Container(
                      margin: EdgeInsets.only(right: appWidth * 0.04),
                      child: const Icon(Icons.arrow_forward_ios),
                    )
                  ]),
                ),
              ),
            );
          }),
    );
  }
}
