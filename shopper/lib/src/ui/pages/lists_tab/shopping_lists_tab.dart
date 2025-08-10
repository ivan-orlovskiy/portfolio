import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopper/src/blocs/shopping_list_page_bloc/shopping_list_page_bloc.dart';
import 'package:shopper/src/blocs/shopping_list_tab_bloc/shopping_list_tab_bloc.dart';
import 'package:shopper/src/common/extensions/icon_extension.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/models/shopping_list_model.dart';
import 'package:shopper/src/services/auth/authentication_service.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/dialogs/common/confirmation_dialog.dart';
import 'package:shopper/src/ui/dialogs/lists/list_creation_dialog.dart';
import 'package:shopper/src/ui/dialogs/lists/list_edition_dialog.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/lists_tab/shopping_list_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/tutorials/tutorials.dart';
import 'package:shopper/src/ui/widgets/animated_fab_builder.dart';
import 'package:shopper/src/ui/widgets/critical_error.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';
import 'package:uuid/uuid.dart';

class ShoppingListsTab extends StatefulWidget {
  const ShoppingListsTab({super.key});

  @override
  State<ShoppingListsTab> createState() => _ShoppingListsTabState();
}

class _ShoppingListsTabState extends State<ShoppingListsTab> {
  final Duration listDuration = const Duration(milliseconds: 200);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ShoppingListModel> _lists = [];
  final Map<String, GlobalKey<_ListSlidableItemState>> _listsStates = {};
  final ScrollController _hideButtonController = ScrollController();
  final ValueNotifier<bool> _isFabVisible = ValueNotifier<bool>(true);
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection == ScrollDirection.reverse) {
        if (_isFabVisible.value == true) {
          _isFabVisible.value = false;
        }
      } else {
        if (_hideButtonController.position.userScrollDirection == ScrollDirection.forward) {
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
    Tutorials.runTutorialOnce(context, TutorialType.lists);
    if (!_initialized) {
      BlocProvider.of<ShoppingListTabBloc>(context)
          .add(ShoppingListTabLoadLists(sl<AuthenticationService>().userId));
      BlocProvider.of<ShoppingListTabBloc>(context).initializeRealtimeListeners(
        onInsert: (payloadMap) => _insertElement(ShoppingListModel.fromMap(payloadMap)),
        onDelete: (payloadMap) => _removeElementById(payloadMap['shopping_list_id']),
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
            _buildLists(),
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
                  routeSettings: const RouteSettings(name: ListCreationDialog.pageName),
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => ListCreationDialog(
                    creationFunction: (name, icon) {
                      showLoader.value = true;
                      final newListId = sl<Uuid>().v4();
                      final newList = ShoppingListModel(
                        id: newListId,
                        name: name,
                        icon: icon,
                        ownerId: sl<AuthenticationService>().userId,
                        ownerNickname: sl<AuthenticationService>().userNickname,
                      );

                      BlocProvider.of<ShoppingListTabBloc>(context).add(
                        ShoppingListTabAddList(
                          newList,
                          (list) {
                            closeListener.value = true;
                            _insertElement(list);
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
            Lang.lists,
            style: AppFonts.pageTitleLight,
          ),
        ],
      ),
    );
  }

  Widget _buildLists() {
    return BlocBuilder<ShoppingListTabBloc, ShoppingListTabState>(
      buildWhen: (previous, current) =>
          (current is ShoppingListTabLoaded || current is ShoppingListTabError) && !_initialized,
      builder: (context, state) {
        if (state is ShoppingListTabLoaded) {
          if (!_initialized) {
            _addAll(state.lists);
            _initialized = true;
          }
          return Expanded(
            child: SlidableAutoCloseBehavior(
              child: AnimatedList(
                controller: _hideButtonController,
                key: _listKey,
                initialItemCount: _lists.length,
                itemBuilder: (context, index, animation) =>
                    _buildItem(index, _lists.elementAt(index), animation),
              ),
            ),
          );
        } else if (state is ShoppingListTabError) {
          return Expanded(
            child: CriticalError(errorMessage: state.message),
          );
        }
        return const Expanded(child: Loader());
      },
    );
  }

  Widget _buildItem(int index, ShoppingListModel list, Animation<double> animation) {
    final key = GlobalKey<_ListSlidableItemState>();
    _listsStates[list.id] = key;
    return SlideTransition(
      position: animation.drive(Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ListSlidableItem(
              key: key,
              onDeleted: () async {
                final isOwnList = sl<AuthenticationService>().userNickname == list.ownerNickname;

                final confirmed = await showDialog(
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  barrierDismissible: false,
                  builder: (_) =>
                      ConfirmationDialog(message: isOwnList ? Lang.deleteList : Lang.quitFromList),
                );
                if (confirmed == null || !confirmed) {
                  return;
                }

                if (!mounted) return;
                final closeListener = ValueNotifier<bool>(false);
                var error = '';
                if (isOwnList) {
                  BlocProvider.of<ShoppingListTabBloc>(context).add(
                    ShoppingListTabRemoveList(
                      list.id,
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
                } else {
                  BlocProvider.of<ShoppingListTabBloc>(context).add(
                    ShoppingListTabQuitFromList(
                      list.id,
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
              onEdited: () async {
                if (sl<AuthenticationService>().userNickname != list.ownerNickname) {
                  FlushbarFactory.warningFlushBar(message: Lang.onlyListOwnerCanEditAttributes)
                      .show(context);
                  return;
                }
                final closeListener = ValueNotifier<bool>(false);
                final showLoader = ValueNotifier<bool>(false);
                final currentList = _listsStates[list.id]?.currentState?._list;
                if (currentList == null) return;
                var error = '';
                await showDialog(
                  useSafeArea: false,
                  routeSettings: const RouteSettings(name: ListEditionDialog.pageName),
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => ListEditionDialog(
                    name: currentList.name,
                    icon: currentList.icon,
                    creationFunction: (name, icon) {
                      showLoader.value = true;
                      final newList = ShoppingListModel(
                        id: list.id,
                        name: name,
                        icon: icon,
                        ownerId: list.ownerId,
                        ownerNickname: list.ownerNickname,
                      );

                      BlocProvider.of<ShoppingListTabBloc>(context).add(
                        ShoppingListTabUpdateList(
                          newList,
                          (list) {
                            closeListener.value = true;
                            final index = _lists.indexWhere((element) => element.id == list.id);
                            _lists[index] = newList;
                            _listsStates[list.id]?.currentState?.changeData(list);
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
              shoppingList: list,
              isOwnList: list.ownerNickname == sl<AuthenticationService>().userNickname,
            ),
          ),
        ),
      ),
    );
  }

  int _getItemIndex(ShoppingListModel newItem) {
    final listCopy = _lists.toList();
    listCopy.add(newItem);
    listCopy.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return listCopy.indexOf(newItem);
  }

  void _addAll(List<ShoppingListModel> items) async {
    for (int i = 0; i < items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      _insertElement(items[i]);
    }
  }

  void _removeElementById(String itemId) {
    final index = _lists.indexWhere((element) => element.id == itemId);
    if (index == -1) return;
    final removedItem = _lists.removeAt(index);

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(index, removedItem, animation),
      duration: listDuration,
    );
  }

  void _insertElement(ShoppingListModel newItem) {
    if (_lists.where((element) => element.id == newItem.id).isNotEmpty) return;
    final index = _getItemIndex(newItem);
    _lists.insert(
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

class _ListSlidableItem extends StatefulWidget {
  final ShoppingListModel shoppingList;
  final VoidCallback onDeleted;
  final Future Function() onEdited;
  final bool isOwnList;

  const _ListSlidableItem({
    super.key,
    required this.shoppingList,
    required this.onDeleted,
    required this.onEdited,
    required this.isOwnList,
  });

  @override
  State<_ListSlidableItem> createState() => _ListSlidableItemState();
}

class _ListSlidableItemState extends State<_ListSlidableItem> {
  late ShoppingListModel _list;

  @override
  void initState() {
    _list = widget.shoppingList;
    super.initState();
  }

  void changeData(ShoppingListModel newList) {
    setState(() {
      _list = newList;
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
              content: ColorFiltered(
                colorFilter: const ColorFilter.mode(AppColors.accentLight, BlendMode.srcIn),
                child: ThemedIcon(
                  assetName:
                      widget.isOwnList ? 'assets/icons/trash.svg' : 'assets/icons/logout.svg',
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
                settings: const RouteSettings(name: ShoppingListPage.pageName),
                builder: (context) => BlocProvider(
                  create: (context) => sl<ShoppingListPageBloc>()
                    ..add(
                      ShoppingListPageLoadItems(
                        widget.shoppingList.id,
                      ),
                    ),
                  child: ShoppingListPage(
                    shoppingList: widget.shoppingList,
                  ),
                ),
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
                        assetName: _list.icon.iconPath,
                      ),
                    ),
                    const SizedBox(width: 12),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 150),
                      child: Text(
                        key: UniqueKey(),
                        _list.name,
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
