import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../theme/theme.dart';
import './home_controller.dart';
import '../../constants/constants.dart';
import '../event_details/event_details.dart';
import '../home_base/home_base_controller.dart';
import '../home_base/models/initial_data_model.dart';
import '../event_modification/event_modification.dart';

class Home extends ConsumerStatefulWidget {
  final InitialDataModel? _initialData;

  const Home(
      {Key? key,
      required InitialDataModel? initialDataModel,
      required HomeBaseController homeBaseController})
      : _initialData = initialDataModel,
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
      color: CustomTheme.lightTheme.scaffoldBackgroundColor,
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
                width: appWidth * 0.8,
                height: appHeight * 0.2,
                margin: EdgeInsets.all(appWidth * 0.02),
                child: Card(
                  elevation: 5,
                  color: Colors.white,
                  shadowColor: CustomTheme.lightTheme.primaryColor,
                  child: Row(children: [
                    Container(
                      height: double.infinity,
                      width: 10,
                      color: index % 3 == 0
                          ? const Color.fromRGBO(231, 111, 81, 1)
                          : index % 3 == 1
                              ? const Color.fromRGBO(42, 157, 143, 1)
                              : const Color.fromRGBO(233, 196, 106, 1),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: appWidth * 0.1),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: appWidth * 0.60,
                            child: Text(
                              event?.activityName as String,
                              style: Theme.of(context).textTheme.headline5?.copyWith(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            event?.dateTime as String,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Theme.of(context).iconTheme.color),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    const Spacer(),
                    widget._initialData?.user?.roleName == roleOrganizer
                        ? Container(
                            margin: EdgeInsets.only(right: appWidth * 0.05),
                            child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.edit,
                                ),
                                onPressed: () {
                                  homeBaseController.invalidateInitialDataProviderNow();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventModification(
                                          widget._initialData?.events?.events[index]),
                                    ),
                                  );
                                },
                              ),
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
                                        element.id ==
                                        widget._initialData?.events?.events[index].id);
                                  });
                                },
                              ),
                            ]),
                          )
                        : Container(
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
