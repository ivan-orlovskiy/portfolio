import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/application_bloc/application_bloc.dart';
import 'package:swipehr/src/presentation/blocs/employee_vacancies_bloc/employee_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/pages/employee/vacancy_view_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/chips/vacancy_chip.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class CompanyVacanciesPage extends StatelessWidget {
  final String companyName;
  final String companyId;
  const CompanyVacanciesPage({
    Key? key,
    required this.companyName,
    required this.companyId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      appBar: _buildAppBar(context),
      body: _buildBody(),
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
      title: PageText(companyName),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      child: BlocBuilder<EmployeeVacanciesBloc, EmployeeVacanciesState>(
        builder: (context, state) {
          switch (state) {
            case EmployeeVacanciesLoaded state:
              {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<EmployeeVacanciesBloc>(context)
                        .add(EmployeeVacanciesLoad(companyId));
                  },
                  child: ListView.separated(
                    itemCount: state.vacancies.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                        right: 16.0,
                        left: 16.0,
                      ),
                      child: VacancyChip(
                        vacancy: state.vacancies[index],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => sl<ApplicationBloc>()
                                  ..add(ApplicationLoad(state.vacancies[index].id)),
                                child: VacancyViewPage(vacancy: state.vacancies[index]),
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
            case EmployeeVacanciesLoading _:
              {
                return const Center(
                  child: CircularProgressIndicator(
                    color: SwipeHrColors.secondary,
                  ),
                );
              }
            case EmployeeVacanciesError state:
              {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<EmployeeVacanciesBloc>(context)
                        .add(EmployeeVacanciesLoad(companyId));
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
