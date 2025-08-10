import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:shopper/src/ui/lang/lang.dart';
import 'package:shopper/src/ui/themes/app_colors.dart';
import 'package:shopper/src/ui/themes/app_fonts.dart';
import 'package:shopper/src/ui/tutorials/tutorials.dart';
import 'package:shopper/src/ui/widgets/app_button.dart';
import 'package:shopper/src/ui/widgets/flushbar_factory.dart';
import 'package:shopper/src/ui/widgets/themed_icon.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class AudioDialog extends StatefulWidget {
  static const pageName = '/audio_dialog';
  final Function(List<(String, String)> itemsToAdd) creationFunction;

  const AudioDialog({
    required this.creationFunction,
    super.key,
  });

  @override
  State<AudioDialog> createState() => _AudioDialogState();
}

class _AudioDialogState extends State<AudioDialog> {
  final Duration listDuration = const Duration(milliseconds: 200);
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  // Speech recognition
  bool _speechAvailible = false;
  final SpeechToText _speechProcessor = SpeechToText();
  final ValueNotifier<bool> _speechEnabled = ValueNotifier(false);
  String _words = '';
  List<(String, String)> _itemsToAdd = [];

  void _initSpeech() async {
    _speechAvailible = await _speechProcessor.initialize();
    _speechProcessor.statusListener = (status) {
      if (status == 'done') {
        _stopListening();
      }
    };
  }

  @override
  void dispose() {
    _speechProcessor.cancel();
    super.dispose();
  }

  void _startListening() async {
    if (!_speechAvailible) {
      _showErrorFlushBar('Enable microphone usage for the app');
      return;
    }
    _listKey.currentState?.removeAllItems(
      (context, animation) => _buildItem(0, ('temp', 'temp'), animation),
    );

    _itemsToAdd.clear();
    _speechEnabled.value = true;
    await _speechProcessor.listen(
      localeId: 'EN',
      onResult: _onSpeechResult,
      listenMode: ListenMode.search,
      partialResults: false,
    );
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    _words = result.recognizedWords.toLowerCase();
    final items = _words.split('next');
    final fullItems = items.map((e) {
      final valuePair = e.split('of');
      if (valuePair.length > 1) {
        return (valuePair[1], valuePair[0]);
      } else {
        return (valuePair[0], '');
      }
    }).toList()
      ..removeWhere((element) => element.$1.trim() == '');
    setState(() {
      _itemsToAdd = fullItems;
    });
    for (int i = 0; i < _itemsToAdd.length; i++) {
      _insertElement(_itemsToAdd[i], i);
    }
    _stopListening();
  }

  void _stopListening() async {
    _speechEnabled.value = false;
    await _speechProcessor.stop();
    await _speechProcessor.cancel();
  }

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Tutorials.runTutorialOnce(context, TutorialType.audio);
    return Builder(
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom / 4),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.8,
              padding: const EdgeInsets.all(16).copyWith(top: 30),
              decoration: BoxDecoration(
                color: AppColors.bgLight,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: Column(
                  children: [
                    Column(
                      children: [
                        Text(
                          Lang.addWithVoice,
                          style: AppFonts.pageTitleLight,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 7),
                        Text(
                          Lang.voicePattern,
                          style: AppFonts.panelTitleLight,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                      ],
                    ),
                    _buildAudioItems(),
                    Column(
                      children: [
                        ValueListenableBuilder(
                          valueListenable: _speechEnabled,
                          builder: (context, value, child) => GestureDetector(
                            onTap: () async {
                              if (!value) {
                                _startListening();
                              } else {
                                _stopListening();
                              }
                            },
                            child: AvatarGlow(
                              animate: value,
                              glowRadiusFactor: 0.25,
                              glowColor: AppColors.accentLight,
                              child: const CircleAvatar(
                                backgroundColor: AppColors.accentLight,
                                radius: 27.5,
                                child: ThemedIcon(assetName: 'assets/icons/microphone.svg'),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 25),
                        AppButton(
                          title: Lang.addAll,
                          onPressed: () {
                            if (_itemsToAdd.isEmpty) {
                              _showErrorFlushBar(Lang.noItemsToAdd);
                              return;
                            }
                            widget.creationFunction(_itemsToAdd);
                            Navigator.pop(context);
                          },
                        ),
                        const SizedBox(height: 10),
                        AppButton(
                          inverted: true,
                          title: Lang.cancel,
                          onPressed: () {
                            Navigator.popUntil(
                                context, (route) => route.settings.name == AudioDialog.pageName);
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAudioItems() {
    return Expanded(
      child: SlidableAutoCloseBehavior(
        child: AnimatedList(
          shrinkWrap: true,
          padding: const EdgeInsets.only(top: 12),
          key: _listKey,
          initialItemCount: _itemsToAdd.length,
          itemBuilder: (context, index, animation) =>
              _buildItem(index, _itemsToAdd.elementAt(index), animation),
        ),
      ),
    );
  }

  Widget _buildItem(int index, (String, String) item, Animation<double> animation) {
    return SlideTransition(
      position: animation.drive(Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)),
      child: SizeTransition(
        sizeFactor: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _AudioListItem(
              name: item.$1,
              volume: item.$2,
              onDeleted: () {
                _removeElement(item);
              },
            ),
          ),
        ),
      ),
    );
  }

  void _removeElement((String, String) item) {
    final index =
        _itemsToAdd.indexWhere((element) => element.$1 == item.$1 && element.$2 == item.$2);
    if (index == -1) return;
    final removedItem = _itemsToAdd.removeAt(index);

    _listKey.currentState!.removeItem(
      index,
      (context, animation) => _buildItem(index, removedItem, animation),
      duration: listDuration,
    );
  }

  void _insertElement((String, String) newItem, int index) {
    _listKey.currentState!.insertItem(
      index,
      duration: listDuration,
    );
  }

  void _showErrorFlushBar(String errorMessage) {
    FlushbarFactory.warningFlushBar(message: errorMessage).show(context);
  }
}

class _AudioListItem extends StatefulWidget {
  final String name;
  final String volume;
  final VoidCallback onDeleted;

  const _AudioListItem({
    required this.name,
    required this.volume,
    required this.onDeleted,
  });

  @override
  State<_AudioListItem> createState() => _AudioListItemState();
}

class _AudioListItemState extends State<_AudioListItem> {
  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: ActionPane(
        extentRatio: 0.16,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            content: const ColorFiltered(
              colorFilter: ColorFilter.mode(AppColors.accentLight, BlendMode.srcIn),
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  widget.name,
                  style: AppFonts.panelTitleLight,
                ),
                Text(
                  widget.volume,
                  style: AppFonts.panelAttributeLight,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
