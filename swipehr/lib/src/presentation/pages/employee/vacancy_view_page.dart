import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/domain/entities/vacancy.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/application_bloc/application_bloc.dart';
import 'package:swipehr/src/presentation/blocs/document_bloc/document_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/employee/vacancy_apply_page.dart';
import 'package:swipehr/src/presentation/pages/employee/view_application_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/theme/swipehr_fonts.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button_secondary.dart';
import 'package:swipehr/src/presentation/widgets/chips/info_chip.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';
import 'package:swipehr/src/presentation/widgets/text/small_text.dart';

class VacancyViewPage extends StatelessWidget {
  final Vacancy vacancy;
  const VacancyViewPage({
    Key? key,
    required this.vacancy,
  }) : super(key: key);

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
      title: PageText(vacancy.name),
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
            child: RefreshIndicator(
              onRefresh: () async => BlocProvider.of<ApplicationBloc>(context).add(ApplicationLoad(
                vacancy.id,
              )),
              child: ListView(
                children: [
                  InfoChip(title: Lang.vacancyName, info: vacancy.name),
                  const SizedBox(height: 20),
                  InfoChip(title: Lang.salary, info: vacancy.salary),
                  const SizedBox(height: 20),
                  InfoChip(title: Lang.description, info: vacancy.description),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SmallText(Lang.tags),
                        const SizedBox(height: 10),
                        Wrap(
                          runSpacing: 10,
                          spacing: 10,
                          children: [
                            for (final tag in vacancy.requiredTags.keys)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      tag,
                                      style: SwipeHrFonts.listChip,
                                    ),
                                  ],
                                ),
                              )
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<ApplicationBloc, ApplicationState>(
                    builder: (context, state) {
                      if (state is ApplicationLoaded) {
                        if (state.application == null) {
                          return const SizedBox();
                        }
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SmallText(Lang.myApplication),
                                ],
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  ActionButton(
                                    text: Lang.viewMyApplication,
                                    width: MediaQuery.of(context).size.width / 2 - 25,
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) => BlocProvider(
                                            create: (context) => sl<DocumentBloc>()
                                              ..add(LoadDocument(state.application!.pdfPath)),
                                            child: ViewApplicationPage(
                                              application: state.application!,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  ActionButtonSecondary(
                                    text: Lang.delete,
                                    width: MediaQuery.of(context).size.width / 2 - 25,
                                    onPressed: () {
                                      BlocProvider.of<ApplicationBloc>(context).add(
                                        ApplicationDelete(state.application!.id),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }
                      return const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: SwipeHrColors.secondary,
                          )
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
        BlocBuilder<ApplicationBloc, ApplicationState>(
          builder: (context, state) {
            if (state is ApplicationLoaded && state.application == null) {
              return ActionButton(
                text: Lang.createApplication,
                width: MediaQuery.of(context).size.width - 32,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => BlocProvider.value(
                        value: BlocProvider.of<ApplicationBloc>(context),
                        child: VacancyApplyPage(
                          vacancy: vacancy,
                        ),
                      ),
                    ),
                  );
                },
              );
            }
            return ActionButtonSecondary(
              color: SwipeHrColors.notActive,
              text: Lang.send,
              width: MediaQuery.of(context).size.width - 32,
              onPressed: () {},
            );
          },
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
