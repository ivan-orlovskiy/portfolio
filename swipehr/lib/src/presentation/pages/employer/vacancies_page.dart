import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/employer_vacancies_bloc/employer_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/blocs/vacancy_applications/vacancy_applications_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/employer/vacancy_creation_page.dart';
import 'package:swipehr/src/presentation/pages/employer/vacancy_view_editable_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/chips/vacancy_editable_chip.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class VacanciesPage extends StatelessWidget {
  const VacanciesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: _buildFab(context),
    );
  }

  Widget _buildFab(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: BlocProvider.of<EmployerVacanciesBloc>(context),
              child: const VacancyCreationPage(),
            ),
          ),
        );
      },
      child: const CircleAvatar(
        radius: 25,
        backgroundColor: SwipeHrColors.secondary,
        child: Icon(
          Ionicons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: PageText(Lang.vacancies),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      child: BlocBuilder<EmployerVacanciesBloc, EmployerVacanciesState>(
        builder: (context, state) {
          switch (state) {
            case EmployerVacanciesLoaded state:
              {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<EmployerVacanciesBloc>(context)
                        .add(const EmployerVacanciesLoad());
                  },
                  child: ListView.separated(
                    itemCount: state.vacancies.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                        right: 16.0,
                        left: 16.0,
                      ),
                      child: VacancyEditableChip(
                        vacancy: state.vacancies[index],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: BlocProvider.of<EmployerVacanciesBloc>(context),
                                  ),
                                  BlocProvider(
                                    create: (context) => sl<VacancyApplicationsBloc>()
                                      ..add(VacancyApplicationsLoad(
                                        state.vacancies[index].id,
                                      )),
                                  ),
                                ],
                                child: VacancyViewEditablePage(
                                  vacancy: state.vacancies[index],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    padding: const EdgeInsets.only(bottom: 10, top: 10),
                  ),
                );
              }
            case EmployerVacanciesLoading _:
              {
                return const Center(
                  child: CircularProgressIndicator(
                    color: SwipeHrColors.secondary,
                  ),
                );
              }
            case EmployerVacanciesError state:
              {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<EmployerVacanciesBloc>(context)
                        .add(const EmployerVacanciesLoad());
                  },
                  child: ListView(
                    children: [PageText(state.message)],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
