import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_days_frontend/modules/home_base/models/initial_data_model.dart';

class Home extends ConsumerWidget {
  final InitialDataModel? _initialData;

  const Home({Key? key, required InitialDataModel? initialDataModel})
      : _initialData = initialDataModel,
        super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _appWidth = MediaQuery.of(context).size.width;
    final _appHeight = MediaQuery.of(context).size.height;

    return Container(
      color: const Color.fromRGBO(220, 220, 220, 0.7),
      child: ListView.builder(
          itemCount: _initialData?.events?.events.length,
          itemBuilder: (context, index) {
            final event = _initialData?.events?.events[index];
            return Container(
              height: _appHeight * 0.2,
              margin: EdgeInsets.all(_appWidth * 0.01),
              child: Card(
                elevation: 5,
                shadowColor: const Color.fromRGBO(1, 30, 65, 1),
                child: Row(children: [
                  Container(
                    margin: EdgeInsets.only(left: _appWidth * 0.05),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event?.activityName as String,
                          style: TextStyle(
                            fontSize: _appHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          event?.dateTime as String,
                          style: TextStyle(
                            fontSize: _appHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          (event?.organizerFirstName as String) +
                              ' ' +
                              (event?.organizerFirstName as String),
                          style: TextStyle(
                            fontSize: _appHeight * 0.025,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Container(
                    margin: EdgeInsets.only(right: _appWidth * 0.04),
                    child: const Icon(Icons.arrow_forward_ios),
                  )
                ]),
              ),
            );
          }),
    );
  }
}
