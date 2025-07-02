import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:heapp/constants/routes.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class QrcodeScanning extends StatefulWidget {
  const QrcodeScanning({super.key});

  @override
  State<QrcodeScanning> createState() => _QrcodeScanningState();
}

class _QrcodeScanningState extends State<QrcodeScanning> {
  bool _isVerified = false;
  String? _qrData;

  @override
  void initState() {
    super.initState();
    _isVerified = false;
    _qrData = "";
  }

  @override
  Widget build(BuildContext context) {
    double scanSize = 200.0.w;

    return Scaffold(
      appBar: AppBar(
        title: Text("驗證 QR Code"),
        leading: IconButton(
            onPressed: () async {
              Navigator.of(context).pushNamedAndRemoveUntil(
                loginRoute,
                (_) => false,
              );
            },
            icon: const Icon(
              Icons.login,
            )),
        backgroundColor: Color(0xFF2E609C),
        // iconTheme: IconThemeData(
        //   color: Colors.white,
        // ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // scanning area
            ClipRect(
              child: SizedBox(
                width: scanSize,
                height: scanSize,
                child: MobileScanner(
                  controller: MobileScannerController(),
                  scanWindow: Rect.fromLTWH(0, 0, scanSize, scanSize),
                  onDetect: (capture) {
                    final barcode = capture.barcodes.first;
                    final qrText = barcode.rawValue;
                    if (!_isVerified &&
                        qrText != null &&
                        qrText.startsWith("AUTH-")) {
                      setState(() {
                        _isVerified = true;
                        _qrData = qrText;
                      });
                    }
                  },
                ),
              ),
            ),

            SizedBox(height: 24.h),

            ElevatedButton.icon(
              onPressed: _isVerified
                  ? () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                        registerRoute,
                        (_) => false,
                      );
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isVerified ? Color(0xFF2E609C) : Colors.grey,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: const Icon(Icons.check_circle, color: Colors.white),
              label: const Text(
                "驗證成功，前往註冊",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
