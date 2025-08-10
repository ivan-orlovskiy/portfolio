import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/employer_vacancies_bloc/employer_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button_secondary.dart';
import 'package:swipehr/src/presentation/widgets/inputs/input_field.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';
import 'package:uuid/uuid.dart';

class VacancyCreationPage extends StatefulWidget {
  const VacancyCreationPage({
    Key? key,
  }) : super(key: key);

  @override
  State<VacancyCreationPage> createState() => _VacancyCreationPageState();
}

class _VacancyCreationPageState extends State<VacancyCreationPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _salaryController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final List<List<TextEditingController>> _tagsControllers = [
    [TextEditingController(), TextEditingController()]
  ];

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
      title: PageText(Lang.createVacancy),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12.0,
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      InputField(
                        title: Lang.vacancyName,
                        width: MediaQuery.of(context).size.width - 32,
                        hintText: Lang.vacancyName,
                        controller: _nameController,
                        validator: (value) {
                          if (value == null) return 'Fill';
                          if (value.isEmpty) return 'Fill';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        title: Lang.salary,
                        width: MediaQuery.of(context).size.width - 32,
                        hintText: Lang.salary,
                        controller: _salaryController,
                        validator: (value) {
                          if (value == null) return 'Fill';
                          if (value.isEmpty) return 'Fill';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      InputField(
                        title: Lang.description,
                        width: MediaQuery.of(context).size.width - 32,
                        hintText: Lang.description,
                        controller: _descriptionController,
                        validator: (value) {
                          if (value == null) return 'Fill';
                          if (value.isEmpty) return 'Fill';
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      SmallText(Lang.tags),
                      const SizedBox(height: 10),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _tagsControllers.length,
                        itemBuilder: (context, index) =>
                            _buildControllerPair(_tagsControllers[index], index),
                        separatorBuilder: (context, index) => const SizedBox(height: 10),
                      ),
                      const SizedBox(height: 20),
                      ActionButtonSecondary(
                        text: Lang.addField,
                        width: MediaQuery.of(context).size.width - 32,
                        onPressed: () {
                          setState(() {
                            _tagsControllers
                                .add([TextEditingController(), TextEditingController()]);
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
        ActionButton(
          text: 'Создать', // TODO
          width: MediaQuery.of(context).size.width - 32,
          onPressed: () {
            final sp = sl<SharedPreferences>();
            final employerId = sp.getString('user_id') ?? '';
            final tagsMap = Map.fromEntries(
                _tagsControllers.map((e) => MapEntry(e[0].text, e[1].text))); // TODO
            BlocProvider.of<EmployerVacanciesBloc>(context).add(
              EmployerVacanciesCreateVacancy(
                Vacancy(
                  id: const Uuid().v4(),
                  name: _nameController.text,
                  employerId: employerId,
                  salary: _salaryController.text,
                  description: _descriptionController.text,
                  requiredTags: tagsMap,
                  photoPath: 'photoPath',
                ),
              ),
            );
            Navigator.pop(context);
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildControllerPair(List<TextEditingController> pair, int index) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: SwipeHrColors.secondary),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          InputField(
            width: MediaQuery.of(context).size.width - 32,
            hintText: Lang.fieldName,
            controller: pair[0],
            validator: (value) {
              if (value == null) return 'Fill';
              if (value.isEmpty) return 'Fill';
              return null;
            },
          ),
          const SizedBox(height: 10),
          InputField(
            width: MediaQuery.of(context).size.width - 32,
            hintText: Lang.fieldDescription,
            controller: pair[1],
            validator: (value) {
              if (value == null) return 'Fill';
              if (value.isEmpty) return 'Fill';
              return null;
            },
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: 150,
            child: ActionButtonSecondary(
              color: SwipeHrColors.trigger,
              text: Lang.deleteField,
              onPressed: () {
                setState(() {
                  _tagsControllers.removeAt(index);
                });
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
