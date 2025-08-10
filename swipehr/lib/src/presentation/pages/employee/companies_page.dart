import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/companies_bloc/companies_bloc.dart';
import 'package:swipehr/src/presentation/blocs/employee_vacancies_bloc/employee_vacancies_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/employee/company_vacancies_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/chips/company_chip.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class CompaniesPage extends StatelessWidget {
  const CompaniesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SwipeHrColors.pageBackground,
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      centerTitle: false,
      title: PageText(Lang.companies),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      child: BlocBuilder<CompaniesBloc, CompaniesState>(
        builder: (context, state) {
          switch (state) {
            case CompaniesLoaded state:
              {
                return RefreshIndicator(
                  color: SwipeHrColors.secondary,
                  onRefresh: () async {
                    BlocProvider.of<CompaniesBloc>(context).add(const CompaniesLoad());
                  },
                  child: ListView.separated(
                    itemCount: state.companies.length,
                    itemBuilder: (context, index) => Padding(
                      padding: const EdgeInsets.only(
                        right: 16.0,
                        left: 16.0,
                      ),
                      child: CompanyChip(
                        company: state.companies[index],
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => BlocProvider(
                                create: (context) => sl<EmployeeVacanciesBloc>()
                                  ..add(EmployeeVacanciesLoad(state.companies[index].id)),
                                child: CompanyVacanciesPage(
                                  companyName: state.companies[index].companyName,
                                  companyId: state.companies[index].id,
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
            case CompaniesLoading _:
              {
                return const Center(
                  child: CircularProgressIndicator(
                    color: SwipeHrColors.secondary,
                  ),
                );
              }
            case CompaniesError state:
              {
                return RefreshIndicator(
                  onRefresh: () async {
                    BlocProvider.of<CompaniesBloc>(context).add(const CompaniesLoad());
                  },
                  child: ListView(
                    children: [PageText(state.errorMessage)],
                  ),
                );
              }
          }
        },
      ),
    );
  }
}
