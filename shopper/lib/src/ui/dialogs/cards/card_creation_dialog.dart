import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/cards_tab/card_scanner_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/icon_selector.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class CardCreationDialog extends StatefulWidget {
  static const pageName = '/card_creation_dialog';
  final Function(String name, String icon, String data) creationFunction;

  const CardCreationDialog({
    super.key,
    required this.creationFunction,
  });

  @override
  State<CardCreationDialog> createState() => _CardCreationDialogState();
}

class _CardCreationDialogState extends State<CardCreationDialog> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<IconSelectorState> _iconState =
      GlobalKey<IconSelectorState>();
  final TextEditingController _cardNameController = TextEditingController();
  final TextEditingController _cardDataController = TextEditingController();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _cardNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 4),
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          resizeToAvoidBottomInset: false,
          body: Center(
            child: GestureDetector(
              onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
              child: Container(
                width: 300,
                height: 300,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextField(
                      controller: _cardNameController,
                      hint: Lang.cardName,
                      focusNode: _focusNode,
                    ),
                    const SizedBox(height: 12),
                    _buildCardField(
                      _cardDataController,
                      Lang.cardData,
                    ),
                    IconSelector(
                      key: _iconState,
                    ),
                    AppButton(
                      title: Lang.create,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_cardNameController.text.isEmpty ||
                            _cardDataController.text.isEmpty) {
                          FlushbarFactory.warningFlushBar(
                            message: Lang.inputCard,
                          ).show(context);
                          return;
                        }
                        widget.creationFunction(
                          _cardNameController.text,
                          _iconState.currentState?.icon ?? 'cart',
                          _cardDataController.text,
                        );
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name ==
                              CardCreationDialog.pageName,
                        );
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCardField(TextEditingController controller, String hint) {
    return TextField(
      textInputAction: TextInputAction.done,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CardScannerPage(
                  onDetected: (barcode) {
                    _cardDataController.text = barcode;
                  },
                ),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: ThemedIcon(
              assetName: 'assets/icons/creditcard.svg',
            ),
          ),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 15, vertical: 18),
        hintText: hint,
        hintStyle: AppFonts.hintLight,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: AppColors.accentLight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: AppColors.accentLight,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
