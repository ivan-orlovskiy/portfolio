import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopper/src/blocs/list_participants_bloc/list_participants_bloc.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/models/shopping_list_user_model.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/ui/dialogs/common/confirmation_dialog.dart';
import 'package:shopper/src/ui/dialogs/participants/participant_addition_dialog.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/tutorials/tutorials.dart';
import 'package:shopper/src/ui/widgets/animated_fab_builder.dart';
import 'package:shopper/src/ui/widgets/critical_error.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';

class ParticipantsPage extends StatefulWidget {
  final String shoppingListOwnerNickname;
  final String shoppingListId;

  const ParticipantsPage({
    Key? key,
    required this.shoppingListOwnerNickname,
    required this.shoppingListId,
  }) : super(key: key);

  @override
  State<ParticipantsPage> createState() => _ParticipantsPageState();
}

class _ParticipantsPageState extends State<ParticipantsPage> {
  final Duration listDuration = const Duration(milliseconds: 200);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ShoppingListUserModel> _users = [];
  final Map<String, GlobalKey<_ParticipantSlidableItemState>> _usersStates = {};
  final ScrollController _hideButtonController = ScrollController();
  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(true);

  @override
  void initState() {
    super.initState();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isFabVisible.value == true) {
          _isFabVisible.value = false;
        }
      } else {
        if (_hideButtonController.position.userScrollDirection ==
            ScrollDirection.forward) {
          if (_isFabVisible.value == false) {
            _isFabVisible.value = true;
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _hideButtonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Tutorials.runTutorialOnce(context, TutorialType.participants);
    BlocProvider.of<ListParticipantsBloc>(context).initializeRealtimeListeners(
      listId: widget.shoppingListId,
      onInsert: (payloadMap) =>
          _insertElement(ShoppingListUserModel.fromMap(payloadMap)),
      onDelete: (payloadMap) => _removeElementById(payloadMap['id']),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            _buildTitle(context),
            const SizedBox(height: 10),
            _buildParticipants(),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildFab(context),
        ),
      ],
    );
  }

  Widget _buildFab(BuildContext context) {
    return AnimatedFabBuilder(
      valueNotifier: _isFabVisible,
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ScaffoldMessenger(
              child: GestureDetector(
                onTap: () async {
                  final closeListener = ValueNotifier<bool>(false);
                  final showLoader = ValueNotifier<bool>(false);
                  var error = '';
                  await showDialog(
                    useSafeArea: false,
                    routeSettings: const RouteSettings(
                        name: ParticipantAdditionDialog.pageName),
                    barrierColor: AppColors.bgDialog.withOpacity(0.7),
                    context: context,
                    builder: (_) => ParticipantAdditionDialog(
                      creationFunction: (userNickname) {
                        showLoader.value = true;
                        BlocProvider.of<ListParticipantsBloc>(context).add(
                          ListParticipantsAddUser(
                            userNickname,
                            widget.shoppingListId,
                            (userRecord) {
                              closeListener.value = true;
                              _insertElement(userRecord);
                            },
                            (errorMessage) {
                              error = errorMessage;
                              closeListener.value = true;
                            },
                          ),
                        );
                      },
                    ),
                  );
                  if (!mounted) {
                    return;
                  }
                  if (!showLoader.value) {
                    return;
                  }
                  await showDialog(
                    barrierDismissible: false,
                    useSafeArea: false,
                    barrierColor: AppColors.bgDialog.withOpacity(0.7),
                    context: context,
                    builder: (_) => ValueListenableBuilder(
                      valueListenable: closeListener,
                      builder: (localContext, value, child) {
                        if (value) {
                          Navigator.pop(context);
                        }
                        return const PopScope(
                          canPop: false,
                          child: Loader(),
                        );
                      },
                    ),
                  );
                  if (error.isNotEmpty) {
                    _showErrorFlushBar(error);
                  }
                },
                child: const CircleAvatar(
                  backgroundColor: AppColors.accentLight,
                  radius: 27.5,
                  child: ThemedIcon(assetName: 'assets/icons/plus.svg'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: const CircleAvatar(
                  backgroundColor: Colors.transparent,
                  child: ThemedIcon(
                    assetName: 'assets/icons/back.svg',
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              Lang.participants,
              style: AppFonts.pageTitleLight,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildParticipants() {
    return BlocBuilder<ListParticipantsBloc, ListParticipantsState>(
      buildWhen: (_, current) =>
          current is ListParticipantsLoaded || current is ListParticipantsError,
      builder: (context, state) {
        if (state is ListParticipantsLoaded) {
          if (_users.isEmpty) {
            _addAll(state.users);
          }
          return Expanded(
            child: SlidableAutoCloseBehavior(
              child: AnimatedList(
                controller: _hideButtonController,
                key: _listKey,
                initialItemCount: _users.length,
                itemBuilder: (context, index, animation) =>
                    _buildItem(index, _users.elementAt(index), animation),
              ),
            ),
          );
        } else if (state is ListParticipantsError) {
          return Expanded(
            child: CriticalError(errorMessage: state.message),
          );
        }
        return const Expanded(child: Loader());
      },
    );
  }

  Widget _buildItem(
      int index, ShoppingListUserModel user, Animation<double> animation) {
    final key = GlobalKey<_ParticipantSlidableItemState>();
    _usersStates[user.id] = key;
    return SlideTransition(
      position: animation
          .drive(Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ParticipantSlidableItem(
              key: key,
              onDeleted: () async {
                if (sl<AuthenticationService>().userNickname !=
                    widget.shoppingListOwnerNickname) {
                  FlushbarFactory.warningFlushBar(
                          message: Lang.onlyListOwnerCanDelete)
                      .show(context);
                  return;
                }
                if (sl<AuthenticationService>().userNickname ==
                    user.userNickname) {
                  FlushbarFactory.warningFlushBar(
                          message: Lang.youCannotDeleteYourself)
                      .show(context);
                  return;
                }

                final confirmed = await showDialog(
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      ConfirmationDialog(message: Lang.removeUserFromList),
                );
                if (confirmed == null || !confirmed) {
                  return;
                }

                if (!mounted) return;
                final closeListener = ValueNotifier<bool>(false);
                var error = '';
                BlocProvider.of<ListParticipantsBloc>(context).add(
                  ListParticipantsRemoveUser(
                    user.id,
                    (userRecordId) {
                      closeListener.value = true;
                      _removeElementById(userRecordId);
                    },
                    (errorMessage) {
                      error = errorMessage;
                      closeListener.value = true;
                    },
                  ),
                );
                await showDialog(
                  barrierDismissible: false,
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => ValueListenableBuilder(
                    valueListenable: closeListener,
                    builder: (localContext, value, child) {
                      if (value) {
                        Navigator.pop(context);
                      }
                      return const PopScope(
                        canPop: false,
                        child: Loader(),
                      );
                    },
                  ),
                );
                if (error.isNotEmpty) {
                  _showErrorFlushBar(error);
                }
              },
              isOwner: user.userNickname == widget.shoppingListOwnerNickname,
              shoppingListUser: user,
            ),
          ),
        ),
      ),
    );
  }

  int _getItemIndex(ShoppingListUserModel newItem) {
    final listCopy = _users.toList();
    listCopy.add(newItem);
    listCopy.sort((a, b) =>
        a.userNickname.toLowerCase().compareTo(b.userNickname.toLowerCase()));
    return listCopy.indexOf(newItem);
  }

  void _addAll(List<ShoppingListUserModel> items) async {
    for (int i = 0; i < items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      _insertElement(items[i]);
    }
  }

  void _removeElementById(String itemId) {
    final index = _users.indexWhere((element) => element.id == itemId);
    if (index == -1) return;
    final removedItem = _users.removeAt(index);

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(index, removedItem, animation),
      duration: listDuration,
    );
  }

  void _insertElement(ShoppingListUserModel newItem) {
    if (_users.where((element) => element.id == newItem.id).isNotEmpty) return;
    final index = _getItemIndex(newItem);
    _users.insert(
      index,
      newItem,
    );
    _listKey.currentState!.insertItem(
      index,
      duration: listDuration,
    );
  }

  void _showErrorFlushBar(String errorMessage) {
    FlushbarFactory.warningFlushBar(message: errorMessage).show(context);
  }
}

class _ParticipantSlidableItem extends StatefulWidget {
  final ShoppingListUserModel shoppingListUser;
  final bool isOwner;
  final VoidCallback onDeleted;

  const _ParticipantSlidableItem({
    super.key,
    required this.shoppingListUser,
    required this.isOwner,
    required this.onDeleted,
  });

  @override
  State<_ParticipantSlidableItem> createState() =>
      _ParticipantSlidableItemState();
}

class _ParticipantSlidableItemState extends State<_ParticipantSlidableItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        endActionPane: ActionPane(
          extentRatio: 0.16,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              content: const ColorFiltered(
                colorFilter: ColorFilter.mode(
                  AppColors.accentLight,
                  BlendMode.srcIn,
                ),
                child: ThemedIcon(assetName: 'assets/icons/trash.svg'),
              ),
              onPressed: (_) {
                widget.onDeleted();
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: Container(
          height: 55,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: AppColors.panelLight,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.isOwner)
                    const Row(
                      children: [
                        ThemedIcon(assetName: 'assets/icons/crown.svg'),
                        SizedBox(width: 12),
                      ],
                    ),
                  Text(
                    widget.shoppingListUser.userNickname,
                    style: AppFonts.panelTitleLight,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
