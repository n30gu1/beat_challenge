import 'package:beat_challenge/cards.dart';
import 'package:flutter/material.dart';

import 'beatmaker.dart';

void main() {
  runApp(const BeatChallengeApp());
}

final GameService _gameService = GameService();

class BeatChallengeApp extends StatelessWidget {
  const BeatChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Beat Challenge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
          body: AnimatedBuilder(
              animation: _gameService,
              builder: (context, child) {
                return Stack(
                  children: [
                    Center(
                      child: BeatChallenge(),
                    ),
                    GestureDetector(
                      onTapDown: (details) {
                        if (_gameService.gameState == GameState.playing) {
                          var dt = DateTime.now()
                              .difference(_gameService.lastBeat)
                              .inMilliseconds;

                          if (dt < 200) {
                            _gameService.scoreIncrease();
                            print("great");
                          } else if (dt > 300) {
                            _gameService.scoreDecrease();
                            _gameService.increaseMissCount();
                            print("miss");
                          } else {
                            print("nice");
                          }

                          _gameService.updateLastTap();
                        } else {
                          _gameService.playBeat();
                        }
                      },
                      child: _gameService.gameState != GameState.playing
                          ? Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              color: _gameService.gameState == GameState.playing
                                  ? null
                                  : Colors.grey,
                              child: () {
                                switch (_gameService.gameState) {
                                  case GameState.ready:
                                    return const Center(
                                        child: Text("탭해서 시작",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold)));
                                  case GameState.playing:
                                    return null;
                                  case GameState.over:
                                    return const Center(
                                        child: Text("게임 오버",
                                            style: TextStyle(
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold)));
                                }
                              }())
                          : null,
                    ),
                    SafeArea(
                        child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text("BPM ${_gameService.bpm}",
                                style: const TextStyle(fontSize: 20)),
                            Text("${_gameService.score}점",
                                style: const TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold)),
                            ElevatedButton(
                                onPressed:
                                    _gameService.gameState == GameState.playing
                                        ? () async {
                                            _gameService.stopBeat();
                                            _gameService.resetScore();
                                          }
                                        : null,
                                child: const Text('비트 멈추기')),
                          ],
                        ),
                        Text("${_gameService.missCount} Miss",
                            style: const TextStyle(fontSize: 20)),
                        Text(_gameService.beats.toString()),
                        Text(_gameService.currentBeatIndex.toString()),
                      ],
                    ))
                  ],
                );
              })),
    );
  }
}

class CardLoader extends ChangeNotifier {
  List<Widget> _cardsLoaded = [];
  List<Widget> get cardsLoaded => _cardsLoaded;
  void loadCard(List<int> beatList) {
    List<Widget> cards = beatList.map((e) {
      switch (e) {
        case 0:
          return const QuarterRest();
        case 1:
          return const QuarterNote();
        case 2:
          return const DoubleEighthNote();
        case 3:
          return const QuadSixteenthNote();
        case 4:
          return const EighthAndEighthRest();
        default:
          return const QuarterRest();
      }
    }).toList();

    if (cardsLoaded.isEmpty) {
      _cardsLoaded = cards;
    }

    for (int i = 0; i < cards.length; i++) {
      if (cards[i] != cardsLoaded[i]) {
        _cardsLoaded[i] = AnimatedPositioned(
            duration: const Duration(milliseconds: 100),
            top: -10,
            curve: Curves.easeInOut,
            child: cards[i]);
      }
    }

    notifyListeners();
  }
}

class BeatChallenge extends StatelessWidget {
  final _cardLoader = CardLoader();

  BeatChallenge({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: Listenable.merge([_gameService, _cardLoader]),
        builder: (context, child) {
          _cardLoader.loadCard(_gameService.beats);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: _cardLoader.cardsLoaded.map((element) {
                  return Flexible(child: element);
                }).toList(),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: 8.0,
                    left: 32 +
                        (MediaQuery.of(context).size.width / 4) *
                            (_gameService.currentBeatIndex ?? 0)),
                child: Text("^", style: TextStyle(fontSize: 50)),
              )
            ],
          );
        });
  }
}
