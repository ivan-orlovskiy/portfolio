import 'package:flutter/material.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/lists_tab/shopping_list_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/app_text_field.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';

class ListItemCreationDialog extends StatefulWidget {
  final Function(String name, String volume) creationFunction;

  const ListItemCreationDialog({
    super.key,
    required this.creationFunction,
  });

  @override
  State<ListItemCreationDialog> createState() => _ListItemCreationDialogState();
}

class _ListItemCreationDialogState extends State<ListItemCreationDialog> {
  final TextEditingController _listItemNameController = TextEditingController();
  final TextEditingController _listItemVolumeController =
      TextEditingController();
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    _focusNode.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _listItemNameController.dispose();
    _listItemVolumeController.dispose();
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
                      focusNode: _focusNode,
                      controller: _listItemNameController,
                      hint: Lang.name,
                    ),
                    AppTextField(
                      controller: _listItemVolumeController,
                      hint: Lang.volume,
                      isEnd: true,
                    ),
                    AppButton(
                      title: Lang.create,
                      onPressed: () {
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (_listItemNameController.text.isEmpty) {
                          FlushbarFactory.warningFlushBar(
                            message: Lang.inputItem,
                          ).show(context);
                          return;
                        }
                        widget.creationFunction(
                          _listItemNameController.text,
                          _listItemVolumeController.text,
                        );
                        Navigator.popUntil(
                          context,
                          (route) =>
                              route.settings.name == ShoppingListPage.pageName,
                        );
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
