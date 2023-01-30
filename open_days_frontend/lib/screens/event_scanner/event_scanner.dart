import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../utils/utils.dart';
import './event_scanner_controller.dart';
import '../../models/base_response_model.dart';
import '../home_base/home_base_controller.dart';

class EventScanner extends ConsumerStatefulWidget {
  const EventScanner({Key? key}) : super(key: key);

  @override
  _EventScannerState createState() => _EventScannerState();
}

class _EventScannerState extends ConsumerState<EventScanner> {
  final qrKey = GlobalKey(debugLabel: 'QR');

  EventScannerController? _eventScannerController;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    ref.invalidate(eventScannerControllerProvider);
    _eventScannerController?.disposeQRViewController();
    super.dispose();
  }

  @override
  void reassemble() async {
    super.reassemble();

    if (Platform.isAndroid) {
      await _eventScannerController?.getQRViewController()?.pauseCamera();
    }

    _eventScannerController?.getQRViewController()?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final appLocale = AppLocalizations.of(context);

    reassemble();

    _eventScannerController = ref.read(eventScannerControllerProvider);

    final eventParticipationProvider =
        ref.watch(_eventScannerController!.getEventParticipationProvider());

    final homeBaseController = ref.read(homeBaseControllerProvider);
    final isApplyingSuccessful = ref.watch(_eventScannerController!.getIsApplyingSuccessful());

    if (isApplyingSuccessful == true) {
      var snackBar = SnackBar(
        content: Text(
          Utils.getString(appLocale?.event_details_qr_code),
        ),
      );

      Future.microtask(() => ScaffoldMessenger.of(context).showSnackBar(snackBar));

      Future.microtask(() => homeBaseController.setNavigationBarIndexProvider(0));
    }

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          buildQrView(context),
          Positioned(
            bottom: 10,
            child: buildResult(eventParticipationProvider),
          )
        ],
      ),
    );
  }

  Widget buildResult(AsyncValue<BaseResponseModel> eventParticipationProvider) {
    final appHeight = MediaQuery.of(context).size.height;

    return eventParticipationProvider.when(
      error: ((error, stackTrace) => const SizedBox.shrink()),
      loading: () => Center(
        child: LoadingAnimationWidget.staggeredDotsWave(
          size: appHeight * 0.1,
          color: const Color.fromRGBO(1, 30, 65, 1),
        ),
      ),
      data: (data) {
        return const SizedBox.shrink();
      },
    );
  }

  Widget buildQrView(BuildContext context) => QRView(
        key: qrKey,
        onQRViewCreated: onQRViewCreated,
        overlay: QrScannerOverlayShape(
          borderWidth: 10,
          borderLength: 20,
          borderColor: Colors.orange[900] as Color,
          cutOutSize: MediaQuery.of(context).size.width * 0.8,
        ),
      );

  void onQRViewCreated(QRViewController qrViewController) {
    _eventScannerController?.setQRViewController(qrViewController);

    _eventScannerController?.getQRViewController()?.scannedDataStream.listen((barcode) {
      _eventScannerController?.setBarcode(barcode);
      _eventScannerController?.participateInEvent();
      _eventScannerController?.getQRViewController()?.dispose();
    });
  }
}
