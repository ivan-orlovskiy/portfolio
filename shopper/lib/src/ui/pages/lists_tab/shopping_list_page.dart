import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopper/src/blocs/list_participants_bloc/list_participants_bloc.dart';
import 'package:shopper/src/blocs/shopping_list_page_bloc/shopping_list_page_bloc.dart';
import 'package:shopper/src/injection.dart';
import 'package:shopper/src/models/shopping_list_item_model.dart';
import 'package:shopper/src/models/shopping_list_model.dart';
import 'package:shopper/src/services/common/connection_service.dart';
import 'package:shopper/src/ui/dialogs/common/confirmation_dialog.dart';
import 'package:shopper/src/ui/dialogs/list_items/audio_dialog.dart';
import 'package:shopper/src/ui/dialogs/list_items/list_item_creation_dialog.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/pages/lists_tab/participants_page.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/tutorials/tutorials.dart';
import 'package:shopper/src/ui/widgets/animated_fab_builder.dart';
import 'package:shopper/src/ui/widgets/critical_error.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/loader.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';
import 'package:uuid/uuid.dart';

class ShoppingListPage extends StatefulWidget {
  static const pageName = '/list_page';

  final ShoppingListModel shoppingList;

  const ShoppingListPage({
    Key? key,
    required this.shoppingList,
  }) : super(key: key);

  @override
  State<ShoppingListPage> createState() => _ShoppingListPageState();
}

class _ShoppingListPageState extends State<ShoppingListPage> {
  final Duration itemDuration = const Duration(milliseconds: 200);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<ShoppingListItemModel> _items = [];
  final Map<String, GlobalKey<_ListItemSlidableItemState>> _listItemStates = {};
  List<ShoppingListItemModel> _backupItems = [];
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
    Tutorials.runTutorialOnce(context, TutorialType.listItems);
    BlocProvider.of<ShoppingListPageBloc>(context).initializeRealtimeListeners(
      filterListId: widget.shoppingList.id,
      onInsert: (payloadMap) =>
          _insertElement(ShoppingListItemModel.fromMap(payloadMap)),
      onUpdate: (payloadMap) {
        final item = ShoppingListItemModel.fromMap(payloadMap);
        if (_items.contains(item)) {
          return;
        }
        _listItemStates[payloadMap['id'] as String]?.currentState?.markItem();
        final index =
            _items.indexWhere((element) => element.id == payloadMap['id']);
        _items[index].isDone = !_items[index].isDone;
      },
      onDelete: (payloadMap) => _removeElementById(payloadMap['id']),
    );
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.bgLight,
      body: SafeArea(child: _buildBody(context)),
    );
  }

  Widget _buildFab() {
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
                if (!mounted) return;

                if (_items.isEmpty) {
                  _showErrorFlushBar(Lang.noItemsToDelete);
                  return;
                }
                final confirmed = await showDialog(
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  barrierDismissible: false,
                  builder: (_) => ConfirmationDialog(message: Lang.deleteAll),
                );
                if (confirmed == null || !confirmed) {
                  return;
                }

                if (!mounted) return;
                BlocProvider.of<ShoppingListPageBloc>(context).add(
                  ShoppingListPageRemoveAllItems(
                    widget.shoppingList.id,
                    (errorMessage) {
                      _addAll(_backupItems);
                      _showErrorFlushBar(errorMessage);
                    },
                  ),
                );
                _backupItems = _items.toList();
                _removeAll();
              },
              child: const CircleAvatar(
                backgroundColor: AppColors.accentLight,
                radius: 27.5,
                child: ThemedIcon(assetName: 'assets/icons/trash.svg'),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                await showDialog(
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  routeSettings:
                      const RouteSettings(name: AudioDialog.pageName),
                  builder: (_) => AudioDialog(
                    creationFunction: (itemsToAdd) {
                      for (final item in itemsToAdd) {
                        final id = sl<Uuid>().v4();
                        final listItem = ShoppingListItemModel(
                          id: id,
                          shoppingListId: widget.shoppingList.id,
                          name: item.$1,
                          volume: item.$2,
                          isDone: false,
                        );

                        BlocProvider.of<ShoppingListPageBloc>(context).add(
                          ShoppingListPageAddItem(
                            listItem,
                            (errorMessage) {
                              _removeElementById(id);
                              _showErrorFlushBar(errorMessage);
                            },
                          ),
                        );
                        _insertElement(listItem);
                      }
                    },
                  ),
                );
              },
              child: const CircleAvatar(
                backgroundColor: AppColors.accentLight,
                radius: 27.5,
                child: ThemedIcon(assetName: 'assets/icons/microphone.svg'),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: () async {
                final isConnected = await _checkConnection();
                if (!isConnected) return;
                if (!mounted) return;
                showDialog(
                  useSafeArea: false,
                  barrierColor: AppColors.bgDialog.withOpacity(0.7),
                  context: context,
                  builder: (_) => ListItemCreationDialog(
                    creationFunction: (name, volume) {
                      final newItemId = sl<Uuid>().v4();
                      final newItem = ShoppingListItemModel(
                        id: newItemId,
                        shoppingListId: widget.shoppingList.id,
                        name: name,
                        volume: volume,
                        isDone: false,
                      );

                      BlocProvider.of<ShoppingListPageBloc>(context).add(
                        ShoppingListPageAddItem(
                          newItem,
                          (errorMessage) {
                            _removeElementById(newItemId);
                            _showErrorFlushBar(errorMessage);
                          },
                        ),
                      );
                      _insertElement(newItem);
                    },
                  ),
                );
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

  Widget _buildBody(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            const SizedBox(height: 20),
            _buildTitle(context),
            const SizedBox(height: 10),
            _buildListItems(),
          ],
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: _buildFab(),
        ),
      ],
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              widget.shoppingList.name,
              style: AppFonts.pageTitleLight,
            ),
          ],
        ),
        GestureDetector(
          onTap: () async {
            final isConnected = await _checkConnection();
            if (!isConnected) return;
            if (!mounted) return;
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider(
                  create: (_) => sl<ListParticipantsBloc>()
                    ..add(
                      ListParticipantsLoadUsers(
                        widget.shoppingList.id,
                      ),
                    ),
                  child: ParticipantsPage(
                    shoppingListOwnerNickname:
                        widget.shoppingList.ownerNickname,
                    shoppingListId: widget.shoppingList.id,
                  ),
                ),
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.only(right: 16.0),
            child: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: ThemedIcon(
                assetName: 'assets/icons/users.svg',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListItems() {
    return BlocBuilder<ShoppingListPageBloc, ShoppingListPageState>(
      buildWhen: (previous, current) =>
          (current is ShoppingListPageLoaded ||
              current is ShoppingListPageError) &&
          !_initialized,
      builder: (context, state) {
        if (state is ShoppingListPageLoaded) {
          if (!_initialized) {
            _addAll(state.listItems);
            _initialized = true;
          }
          return Expanded(
            child: SlidableAutoCloseBehavior(
              child: AnimatedList(
                controller: _hideButtonController,
                key: _listKey,
                initialItemCount: _items.length,
                itemBuilder: (context, index, animation) =>
                    _buildItem(index, _items.elementAt(index), animation),
              ),
            ),
          );
        } else if (state is ShoppingListPageError) {
          return Expanded(
            child: CriticalError(errorMessage: state.message),
          );
        }
        return const Expanded(child: Loader());
      },
    );
  }

  Widget _buildItem(
      int index, ShoppingListItemModel item, Animation<double> animation) {
    final key = GlobalKey<_ListItemSlidableItemState>();
    _listItemStates[item.id] = key;
    return SlideTransition(
      position: animation
          .drive(Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ListItemSlidableItem(
              key: key,
              onMarked: (restoreState) async {
                item.isDone = !item.isDone;
                BlocProvider.of<ShoppingListPageBloc>(context).add(
                  ShoppingListPageMarkItem(
                    item.id,
                    item.isDone,
                    (errorMessage) {
                      item.isDone = !item.isDone;
                      restoreState();
                      _showErrorFlushBar(errorMessage);
                    },
                  ),
                );
              },
              onDeleted: () {
                BlocProvider.of<ShoppingListPageBloc>(context).add(
                  ShoppingListPageRemoveItem(
                    item.id,
                    (errorMessage) {
                      _insertElement(item);
                      _showErrorFlushBar(errorMessage);
                    },
                  ),
                );
                _removeElementById(item.id);
              },
              shoppingListItem: item,
            ),
          ),
        ),
      ),
    );
  }

  int _getItemIndex(ShoppingListItemModel newItem) {
    final listCopy = _items.toList();
    listCopy.add(newItem);
    listCopy
        .sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    return listCopy.indexOf(newItem);
  }

  void _addAll(List<ShoppingListItemModel> items) async {
    for (int i = 0; i < items.length; i++) {
      await Future.delayed(const Duration(milliseconds: 50));
      _insertElement(items[i]);
    }
  }

  void _removeAll() async {
    _items.clear();
    _listKey.currentState?.removeAllItems(
      (context, animation) => _buildItem(
          0,
          ShoppingListItemModel(
            id: 'id',
            shoppingListId: 'shoppingListId',
            name: 'name',
            volume: 'volume',
            isDone: false,
          ),
          animation),
    );
  }

  void _removeElementById(String itemId) {
    final index = _items.indexWhere((element) => element.id == itemId);
    if (index == -1) return;
    final removedItem = _items.removeAt(index);

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(index, removedItem, animation),
      duration: itemDuration,
    );
  }

  void _insertElement(ShoppingListItemModel newItem) {
    if (_items.where((element) => element.id == newItem.id).isNotEmpty) return;
    final index = _getItemIndex(newItem);
    _items.insert(
      index,
      newItem,
    );
    _listKey.currentState!.insertItem(
      index,
      duration: itemDuration,
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

class _ListItemSlidableItem extends StatefulWidget {
  final Function(VoidCallback localSetState) onMarked;
  final VoidCallback onDeleted;
  final ShoppingListItemModel shoppingListItem;

  const _ListItemSlidableItem({
    Key? key,
    required this.shoppingListItem,
    required this.onMarked,
    required this.onDeleted,
  }) : super(key: key);

  @override
  State<_ListItemSlidableItem> createState() => _ListItemSlidableItemState();
}

class _ListItemSlidableItemState extends State<_ListItemSlidableItem> {
  final _redoKey = UniqueKey();
  final _checkKey = UniqueKey();
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.shoppingListItem.isDone;
    super.initState();
  }

  void markItem() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Slidable(
        groupTag: 'group',
        startActionPane: ActionPane(
          extentRatio: 0.16,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              content: AnimatedSwitcher(
                duration: const Duration(milliseconds: 150),
                child: _isSelected
                    ? ColorFiltered(
                        key: _redoKey,
                        colorFilter: const ColorFilter.mode(
                          AppColors.accentLight,
                          BlendMode.srcIn,
                        ),
                        child: const ThemedIcon(
                          assetName: 'assets/icons/redo.svg',
                        ),
                      )
                    : ColorFiltered(
                        key: _checkKey,
                        colorFilter: const ColorFilter.mode(
                          AppColors.accentLight,
                          BlendMode.srcIn,
                        ),
                        child: const ThemedIcon(
                          assetName: 'assets/icons/check.svg',
                        ),
                      ),
              ),
              onPressed: (context) {
                widget.onMarked(
                  () => setState(() {
                    _isSelected = !_isSelected;
                  }),
                );
                setState(() {
                  _isSelected = !_isSelected;
                });
              },
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
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
              onPressed: (context) => widget.onDeleted(),
              backgroundColor: Colors.transparent,
              foregroundColor: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
          ],
        ),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          constraints: const BoxConstraints(
            minHeight: 55,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color:
                _isSelected ? AppColors.panelDimmedLight : AppColors.panelLight,
            borderRadius: BorderRadius.circular(10),
          ),
          width: double.infinity,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: Text(widget.shoppingListItem.name,
                            style: AppFonts.panelTitleLight),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 1,
                        child: Text(
                          widget.shoppingListItem.volume,
                          style: AppFonts.panelAttributeLight,
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Center(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 150),
                  child: _isSelected
                      ? Container(
                          key: UniqueKey(),
                          height: 1.5,
                          color: AppColors.accentLight,
                        )
                      : const SizedBox(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
