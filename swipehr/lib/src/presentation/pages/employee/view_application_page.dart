import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:ionicons/ionicons.dart';
import 'package:swipehr/src/domain/entities/application.dart';
import 'package:swipehr/src/presentation/blocs/document_bloc/document_bloc.dart';
import 'package:swipehr/src/presentation/locale/lang.dart';
import 'package:swipehr/src/presentation/theme/swipehr_colors.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button.dart';
import 'package:swipehr/src/presentation/widgets/buttons/action_button_secondary.dart';
import 'package:swipehr/src/presentation/widgets/chips/info_chip.dart';
import 'package:swipehr/src/presentation/widgets/text/page_text.dart';

class ViewApplicationPage extends StatelessWidget {
  final bool isEmployeeView;
  final Application application;

  const ViewApplicationPage({
    Key? key,
    this.isEmployeeView = true,
    required this.application,
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
      title: PageText(isEmployeeView ? Lang.myApplication : '#${application.id.hashCode}'),
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
                for (final answer in application.tags.entries)
                  InfoChip(title: answer.key, info: answer.value),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: BlocBuilder<DocumentBloc, DocumentState>(
                    builder: (context, state) {
                      if (state is DocumentLoaded) {
                        return ActionButton(
                          text: 'Посмотреть pdf',
                          width: MediaQuery.of(context).size.width - 32,
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return SafeArea(
                                    child: Scaffold(
                                      appBar: AppBar(
                                        foregroundColor: SwipeHrColors.text,
                                        backgroundColor: SwipeHrColors.pageBackground,
                                        elevation: 0,
                                      ),
                                      body: PDFView(
                                        pdfData: state.data,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ActionButtonSecondary(
                            color: SwipeHrColors.notActive,
                            text: 'Посмотреть pdf',
                            width: MediaQuery.of(context).size.width - 32,
                            onPressed: () {},
                          ),
                          const CircularProgressIndicator(
                            color: SwipeHrColors.secondary,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
