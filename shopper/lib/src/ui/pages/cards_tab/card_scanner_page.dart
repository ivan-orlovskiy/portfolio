import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class CardScannerPage extends StatelessWidget {
  final Function(String barcode) onDetected;

  const CardScannerPage({
    super.key,
    required this.onDetected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        _buildTitle(context),
        _buildScanner(context),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ThemedIcon(
                    assetName: 'assets/icons/back.svg',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              Lang.cardScanner,
              style: AppFonts.pageTitleLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScanner(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.zero,
        child: MobileScanner(
          controller: MobileScannerController(detectionTimeoutMs: 500),
          placeholderBuilder: (_, __) => const Loader(),
          scanWindow: Rect.fromCenter(
            center: Offset(MediaQuery.of(context).size.width / 2,
                MediaQuery.of(context).size.height / 2),
            width: 300,
            height: 400,
          ),
          overlay: ColorFiltered(
            colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.8), BlendMode.srcOut),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Container(
                  decoration: const BoxDecoration(
                      color: Colors.black,
                      backgroundBlendMode: BlendMode.dstOut),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Container(
                    height: 300,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          onDetect: (barcodes) {
            onDetected(barcodes.barcodes.first.displayValue ?? '');
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
