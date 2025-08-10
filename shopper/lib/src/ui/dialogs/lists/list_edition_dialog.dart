import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/icon_selector.dart';

class ListEditionDialog extends StatefulWidget {
  static const pageName = '/list_edition_dialog';
  final String name;
  final String icon;
  final Function(String name, String icon) creationFunction;

  const ListEditionDialog({
    super.key,
    required this.name,
    required this.icon,
    required this.creationFunction,
  });

  @override
  State<ListEditionDialog> createState() => _ListEditionDialogState();
}

class _ListEditionDialogState extends State<ListEditionDialog> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<IconSelectorState> _iconState =
      GlobalKey<IconSelectorState>();
  final TextEditingController _listNameController = TextEditingController();

  @override
  void initState() {
    _listNameController.text = widget.name;
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _listNameController.dispose();
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
                height: 225,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.bgLight,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppTextField(
                      controller: _listNameController,
                      hint: Lang.listName,
                      isEnd: true,
                      focusNode: _focusNode,
                    ),
                    IconSelector(
                      key: _iconState,
                      initialIconName: widget.icon,
                    ),
                    AppButton(
                      title: Lang.edit,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_listNameController.text.isEmpty) {
                          FlushbarFactory.warningFlushBar(
                            message: Lang.inputList,
                          ).show(context);
                          return;
                        }
                        if (widget.name == _listNameController.text &&
                            widget.icon ==
                                (_iconState.currentState?.icon ?? 'cart')) {
                          FlushbarFactory.warningFlushBar(
                            message: Lang.sameList,
                          ).show(context);
                          return;
                        }
                        widget.creationFunction(
                          _listNameController.text,
                          _iconState.currentState?.icon ?? 'cart',
                        );
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == ListEditionDialog.pageName,
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
}
