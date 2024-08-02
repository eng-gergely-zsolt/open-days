import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../theme/theme.dart';
import './statistic_controller.dart';
import '../error/base_error_screen.dart';
import '../../utils/helper_widget_utils.dart';

class Statistic extends ConsumerWidget {
  const Statistic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appLocale = AppLocalizations.of(context);
    final appWidth = MediaQuery.of(context).size.width;
    final appHeight = MediaQuery.of(context).size.height;

    final controller = ref.read(statisticControllerProvider);
    final isLoading = ref.watch(controller.getIsLoadinProvider());
    final initialData = ref.watch(controller.getInitialDataProvider());

    ref.watch(controller.getReloadFlagProvider());

    return initialData.when(
        error: (error, stackTrace) => const BaseErrorScreen(),
        loading: () => Center(
              child: LoadingAnimationWidget.staggeredDotsWave(
                size: appHeight * 0.1,
                color: CustomTheme.lightTheme.primaryColor,
              ),
            ),
        data: ((data) {
          return isLoading
              ? HelperWidgetUtils.getStaggeredDotsWaveAnimation(appHeight)
              : Scaffold(
                  floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
                  floatingActionButton: buildFloatingButton(
                    appWidth,
                    appHeight,
                    appLocale,
                    controller,
                  ),
                  body: Container(
                    padding: EdgeInsets.symmetric(horizontal: appWidth * 0.03),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(height: appHeight * 0.05),
                          Text(
                            appLocale?.participated_users_stats_title as String,
                            style: CustomTheme.lightTheme.textTheme.headline6,
                          ),
                          SizedBox(height: appHeight * 0.05),
                          SizedBox(
                            height: appHeight * 0.4,
                            child: ListView.builder(
                              itemCount: data.activities.length,
                              itemBuilder: ((context, i) {
                                return Container(
                                  padding: EdgeInsets.only(
                                      bottom:
                                          i < data.activities.length - 1 ? appHeight * 0.02 : 0),
                                  child: Row(
                                    children: [
                                      SizedBox(width: appWidth * 0.02),
                                      Text(
                                        (i + 1).toString() + '.',
                                        style: CustomTheme.lightTheme.textTheme.headline6,
                                      ),
                                      SizedBox(width: appWidth * 0.02),
                                      Expanded(
                                        child: Text(
                                          data.activities[i].name,
                                          style: CustomTheme.lightTheme.textTheme.bodyText1,
                                        ),
                                      ),
                                      Checkbox(
                                        value: controller
                                                .getActivityNames()
                                                .contains(data.activities[i].name)
                                            ? true
                                            : false,
                                        onChanged: (value) {
                                          controller.changeCheckBoxState(
                                              value, data.activities[i].name);
                                        },
                                      ),
                                      SizedBox(
                                        width: appWidth * 0.02,
                                      )
                                    ],
                                  ),
                                );
                              }),
                            ),
                          ),
                          controller.isPieChartRequired()
                              ? Column(
                                  children: [
                                    Container(
                                      height: 1,
                                      width: appWidth * 1,
                                      color: CustomTheme.lightTheme.dividerColor,
                                    ),
                                    SizedBox(height: appHeight * 0.05),
                                    Container(
                                      padding: EdgeInsets.only(bottom: appHeight * 0.15),
                                      child: PieChart(
                                        chartRadius: appWidth * 0.6,
                                        dataMap: controller.getPieChartDataMap(),
                                        colorList: controller.getPieChartColorList(),
                                        legendOptions: LegendOptions(
                                          legendPosition: LegendPosition.top,
                                          legendTextStyle: CustomTheme
                                              .lightTheme.textTheme.bodyText2 as TextStyle,
                                        ),
                                      ),
                                    )
                                  ],
                                )
                              : const SizedBox.shrink(),
                        ],
                      ),
                    ),
                  ),
                );
        }));
  }

  Widget buildFloatingButton(
    double appWidth,
    double appHeight,
    AppLocalizations? appLocale,
    StatisticController controller,
  ) {
    return Padding(
      padding: EdgeInsets.only(bottom: appHeight * 0.03),
      child: SizedBox(
        height: 45,
        width: appWidth * 0.6,
        child: controller.getActivityNames().length > 1
            ? FloatingActionButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  appLocale?.statistic_get_chart.toUpperCase() as String,
                  style: TextStyle(
                    fontSize: appHeight * 0.025,
                  ),
                ),
                onPressed: () {
                  controller.createStatistic();
                },
              )
            : FloatingActionButton(
                backgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Text(
                  appLocale?.statistic_get_chart.toUpperCase() as String,
                  style: TextStyle(
                    fontSize: appHeight * 0.025,
                  ),
                ),
                onPressed: () {},
              ),
      ),
    );
  }
}
