import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/application_bloc/application_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button_secondary.dart';
import 'package:swipehr/src/presentation/widgets/inputs/input_field.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';
import 'package:uuid/uuid.dart';

class VacancyApplyPage extends StatefulWidget {
  final Vacancy vacancy;
  const VacancyApplyPage({
    Key? key,
    required this.vacancy,
  }) : super(key: key);

  @override
  State<VacancyApplyPage> createState() => _VacancyApplyPageState();
}

class _VacancyApplyPageState extends State<VacancyApplyPage> {
  final Map<String, TextEditingController> controllers = {};
  File? pdfFile;

  @override
  void initState() {
    super.initState();
    for (final tag in widget.vacancy.requiredTags.keys) {
      controllers[tag] = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      appBar: _buildAppBar(context),
      body: _buildBody(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.only(top: 4),
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            child: Icon(
              size: 20,
              Ionicons.chevron_back,
              color: SwipeHrColors.text,
            ),
          ),
        ),
      ),
      centerTitle: false,
      title: PageText(widget.vacancy.name),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    for (final tag in widget.vacancy.requiredTags.entries)
                      Column(
                        children: [
                          InputField(
                            title: tag.key,
                            width: MediaQuery.of(context).size.width - 32,
                            hintText: tag.value,
                            controller: controllers[tag.key]!,
                            validator: (value) {
                              if (value == null) return 'Fill';
                              if (value.isEmpty) return 'Fill';
                              return null;
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: SmallText(Lang.attachCV),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ActionButtonSecondary(
                  text: pdfFile == null ? Lang.attachExplanation : 'Выбрать другой файл',
                  width: MediaQuery.of(context).size.width - 32,
                  onPressed: () async {
                    final result = await FilePicker.platform.pickFiles();

                    if (result != null) {
                      File pickedFile = File(result.files.single.path!);
                      setState(() {
                        pdfFile = pickedFile;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        ActionButton(
          text: Lang.send,
          width: MediaQuery.of(context).size.width - 32,
          onPressed: () {
            if (pdfFile == null) return;
            // TODO
            final sp = sl<SharedPreferences>();
            final employeeId = sp.getString('user_id') ?? '';
            final tagsMap = controllers.map((key, value) => MapEntry(key, value.text));
            BlocProvider.of<ApplicationBloc>(context).add(
              ApplicationApply(
                Application(
                  id: const Uuid().v4(),
                  employeeId: employeeId,
                  vacancyId: widget.vacancy.id,
                  tags: tagsMap,
                  pdfPath: 'pdfPath',
                ),
                pdfFile!,
              ),
            );
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
