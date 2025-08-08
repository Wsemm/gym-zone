import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';

import '../../common/constants/constants.dart';
import '../../common/navigation/app_routes.dart';
import '../../controllers/home_controller.dart';
import '../../controllers/new_visit_controller.dart';

class QrScanView extends StatefulWidget {
  final bool? fromOffers;
  const QrScanView({super.key,this.fromOffers = false});

  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  bool qrCodeDetected = false;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    } else if (Platform.isIOS) {
      controller!.resumeCamera();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        systemOverlayStyle: appBarSystemStyle,
        leading: const SizedBox(),
        leadingWidth: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(
                Icons.adaptive.arrow_back,
                color: Colors.white,
                size: 24.sp,
              ),
              onPressed: () {
                Get.back();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.flash_on_rounded,
                color: Colors.white,
                size: 24.sp,
              ),
              onPressed: () {
                // Get.find<NewVisitController>()
                //     .checkIn('5cb96e43-4675-4a22-9e64-9a993202feff')
                //     .then((newVisit) {
                //   Get.find<HomeController>().refreshView();
                //   Get.offNamed(AppRoutes.checkIn, arguments: newVisit);
                // });
                controller?.toggleFlash();
              },
            ),
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: [
                QRView(
                  key: qrKey,
                  onQRViewCreated: _onQRViewCreated,
                ),
                _buildScannerOverlay(),
                Positioned(
                  bottom: MediaQuery.of(context).size.height * 0.20,
                  child: FittedBox(
                    child: Text(
                      'Align the QR code within the frame'.tr,
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      if (qrCodeDetected) {
        return;
      }

      qrCodeDetected = true;


      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
      if (widget.fromOffers == true) {
       Future.delayed(Duration(seconds: 2),(){
         Get.back(result: "Done");
         Get.back(result: "Done");
       });
      } else {
        Get.find<NewVisitController>().checkIn(scanData.code!).then((newVisit) {
          Get.back();
          Get.find<HomeController>().refreshView();
          Get.offNamed(AppRoutes.checkIn, arguments: newVisit);
        });
      }
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  Widget _buildScannerOverlay() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Stack(
          children: <Widget>[
            Positioned(
              left: 0,
              top: 0,
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.25,
              child: Container(color: Colors.black45),
            ),
            Positioned(
              left: 0,
              bottom: 0,
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.25,
              child: Container(color: Colors.black45),
            ),
            Positioned(
              left: 0,
              top: constraints.maxHeight * 0.25,
              width: constraints.maxWidth * 0.15,
              height: constraints.maxHeight * 0.5,
              child: Container(color: Colors.black45),
            ),
            Positioned(
              right: 0,
              top: constraints.maxHeight * 0.25,
              width: constraints.maxWidth * 0.15,
              height: constraints.maxHeight * 0.5,
              child: Container(color: Colors.black45),
            ),
            Positioned(
              left: 0,
              top: constraints.maxHeight * 0.25,
              width: constraints.maxWidth,
              height: constraints.maxHeight * 0.5,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(width: 2.w, color: Colors.white),
                    bottom: BorderSide(width: 2.w, color: Colors.white),
                    left: BorderSide(width: 2.w, color: Colors.white),
                    right: BorderSide(width: 2.w, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
