import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/icon_selector.dart';

class ListCreationDialog extends StatefulWidget {
  static const pageName = '/list_creation_dialog';
  final Function(String name, String icon) creationFunction;

  const ListCreationDialog({
    super.key,
    required this.creationFunction,
  });

  @override
  State<ListCreationDialog> createState() => _ListCreationDialogState();
}

class _ListCreationDialogState extends State<ListCreationDialog> {
  final FocusNode _focusNode = FocusNode();
  final GlobalKey<IconSelectorState> _iconState =
      GlobalKey<IconSelectorState>();
  final TextEditingController _listNameController = TextEditingController();

  @override
  void initState() {
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
                    ),
                    AppButton(
                      title: Lang.create,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_listNameController.text.isEmpty) {
                          FlushbarFactory.warningFlushBar(
                            message: Lang.inputList,
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
                              route.settings.name ==
                              ListCreationDialog.pageName,
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
