import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopper/src/blocs/cards_tab_bloc/cards_tab_bloc.dart';
import 'package:shopper/src/common/extensions/icon_extension.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/models/card_model.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/dialogs/cards/card_creation_dialog.dart';
import 'package:shopper/src/ui/dialogs/cards/card_edition_dialog.dart';
import 'package:shopper/src/ui/dialogs/common/confirmation_dialog.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/cards_tab/card_view_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/tutorials/tutorials.dart';
import 'package:shopper/src/ui/widgets/animated_fab_builder.dart';
import 'package:shopper/src/ui/widgets/critical_error.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';
import 'package:uuid/uuid.dart';

class CardsTab extends StatefulWidget {
  const CardsTab({super.key});

  @override
  State<CardsTab> createState() => _CardsTabState();
}

class _CardsTabState extends State<CardsTab> {
  final Duration listDuration = const Duration(milliseconds: 200);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<CardModel> _cards = [];
  final Map<String, GlobalKey<_CardSlidableItemState>> _cardsStates = {};
  final ScrollController _hideButtonController = ScrollController();
  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(true);
  bool _initialized = false;

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
    Tutorials.runTutorialOnce(context, TutorialType.cards);
    if (!_initialized) {
      BlocProvider.of<CardsTabBloc>(context).add(
        CardsTabLoadCards(
          sl<AuthenticationService>().userId,
          (ids) {
            for (final id in ids) {
              _removeElementById(id);
            }
          },
          (cards) {
            for (final card in cards) {
              _insertElement(card);
            }
          },
        ),
      );
    }
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgLight,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            _buildTitle(),
            const SizedBox(height: 10),
            _buildCards(),
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
            GestureDetector(
              onTap: () async {
                final isConnected = await _checkConnection();
                if (!isConnected) return;

                if (!mounted) {
                  return;
                }
                final closeListener = ValueNotifier<bool>(false);
                final showLoader = ValueNotifier<bool>(false);
                var error = '';
                await showDialog(
                  routeSettings:
                      const RouteSettings(name: CardCreationDialog.pageName),
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => CardCreationDialog(
                    creationFunction: (name, icon, data) {
                      showLoader.value = true;
                      final newCardId = sl<Uuid>().v4();
                      final newCard = CardModel(
                        id: newCardId,
                        userId: sl<AuthenticationService>().userId,
                        name: name,
                        icon: icon,
                        data: data,
                      );

                      BlocProvider.of<CardsTabBloc>(context).add(
                        CardsTabAddCard(
                          newCard,
                          (card) {
                            closeListener.value = true;
                            _insertElement(card);
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
                child: ThemedIcon(assetName: 'assets/icons/creditcard_add.svg'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            Lang.cards,
            style: AppFonts.pageTitleLight,
          ),
        ],
      ),
    );
  }

  Widget _buildCards() {
    return BlocBuilder<CardsTabBloc, CardsTabState>(
      buildWhen: (previous, current) =>
          (current is CardsTabLoaded || current is CardsTabError) &&
          !_initialized,
      builder: (context, state) {
        if (state is CardsTabLoaded) {
          if (!_initialized) {
            _addAll(state.cards);
            _initialized = true;
          }
          return Expanded(
            child: SlidableAutoCloseBehavior(
              child: AnimatedList(
                controller: _hideButtonController,
                key: _listKey,
                initialItemCount: _cards.length,
                itemBuilder: (context, index, animation) =>
                    _buildItem(index, _cards.elementAt(index), animation),
              ),
            ),
          );
        } else if (state is CardsTabError) {
          return Expanded(
            child: CriticalError(errorMessage: state.message),
          );
        }
        return const Expanded(child: Loader());
      },
    );
  }

  Widget _buildItem(int index, CardModel card, Animation<double> animation) {
    final key = GlobalKey<_CardSlidableItemState>();
    _cardsStates[card.id] = key;
    return SlideTransition(
      position: animation
          .drive(Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _CardSlidableItem(
              card: card,
              key: key,
              onDeleted: () async {
                final confirmed = await showDialog(
                  useSafeArea: false,
                  barrierDismissible: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => ConfirmationDialog(message: Lang.deleteCard),
                );
                if (confirmed == null || !confirmed) {
                  return;
                }

                if (!mounted) return;
                final closeListener = ValueNotifier<bool>(false);
                var error = '';

                BlocProvider.of<CardsTabBloc>(context).add(
                  CardsTabRemoveCard(
                    card.id,
                    (listId) {
                      closeListener.value = true;
                      _removeElementById(listId);
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
              onEdited: () async {
                final closeListener = ValueNotifier<bool>(false);
                final showLoader = ValueNotifier<bool>(false);
                final currentCard = _cardsStates[card.id]?.currentState?._card;
                if (currentCard == null) return;
                var error = '';
                await showDialog(
                  useSafeArea: false,
                  routeSettings:
                      const RouteSettings(name: CardEditionDialog.pageName),
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => CardEditionDialog(
                    name: currentCard.name,
                    icon: currentCard.icon,
                    data: currentCard.data,
                    creationFunction: (name, icon, data) {
                      showLoader.value = true;
                      final newCard = CardModel(
                        id: card.id,
                        userId: sl<AuthenticationService>().userId,
                        name: name,
                        icon: icon,
                        data: data,
                      );

                      BlocProvider.of<CardsTabBloc>(context).add(
                        CardsTabUpdateCard(
                          newCard,
                          (card) {
                            closeListener.value = true;
                            final index = _cards
                                .indexWhere((element) => element.id == card.id);
                            _cards[index] = newCard;
                            _cardsStates[card.id]
                                ?.currentState
                                ?.changeData(card);
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
            ),
          ),
        ),
      ),
    );
  }

  int _getItemIndex(CardModel newItem) {
    final listCopy = _cards.toList();
    listCopy.add(newItem);
    listCopy
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return listCopy.indexOf(newItem);
  }

  void _addAll(List<CardModel> items) async {
    for (int i = 0; i < items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      _insertElement(items[i]);
    }
  }

  void _removeElementById(String itemId) {
    final index = _cards.indexWhere((element) => element.id == itemId);
    if (index == -1) return;
    final removedItem = _cards.removeAt(index);

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(index, removedItem, animation),
      duration: listDuration,
    );
  }

  void _insertElement(CardModel newItem) {
    if (_cards.where((element) => element.id == newItem.id).isNotEmpty) return;
    final index = _getItemIndex(newItem);
    _cards.insert(
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

  Future<bool> _checkConnection() async {
    final isConnected = await sl<ConnectionService>().isConnected;
    if (!isConnected) {
      _showErrorFlushBar(Lang.notConnected);
      return false;
    }
    return true;
  }
}

class _CardSlidableItem extends StatefulWidget {
  final CardModel card;
  final VoidCallback onDeleted;
  final Future Function() onEdited;

  const _CardSlidableItem({
    super.key,
    required this.card,
    required this.onDeleted,
    required this.onEdited,
  });

  @override
  State<_CardSlidableItem> createState() => _CardSlidableItemState();
}

class _CardSlidableItemState extends State<_CardSlidableItem> {
  late CardModel _card;

  @override
  void initState() {
    _card = widget.card;
    super.initState();
  }

  void changeData(CardModel newCard) {
    setState(() {
      _card = newCard;
    });
  }

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
                child: ThemedIcon(
                  assetName: 'assets/icons/trash.svg',
                ),
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
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CardViewPage(card: _card),
              ),
            );
          },
          onLongPress: () async {
            await widget.onEdited();
          },
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
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: ThemedIcon(
                        key: UniqueKey(),
                        assetName: _card.icon.iconPath,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        key: UniqueKey(),
                        _card.name,
                        style: AppFonts.panelTitleLight,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
