import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/injection.dart';
import 'package:swipehr/src/presentation/blocs/document_bloc/document_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/pages/employee/view_application_page.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/chips/application_chip.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class SelectionResultsPage extends StatelessWidget {
  final List<Application> applications;

  const SelectionResultsPage({super.key, required this.applications});

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
      title: PageText(Lang.selectionResults),
      elevation: 0,
      backgroundColor: SwipeHrColors.pageBackground,
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.only(
        top: 12.0,
      ),
      child: ListView.separated(
        itemCount: applications.length,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.only(
            right: 16.0,
            left: 16.0,
          ),
          child: ApplicationChip(
            application: applications[index],
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BlocProvider(
                    create: (context) =>
                        sl<DocumentBloc>()..add(LoadDocument(applications[index].pdfPath)),
                    child: ViewApplicationPage(
                      isEmployeeView: false,
                      application: applications[index],
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
}
