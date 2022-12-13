import 'dart:html';

import 'package:beat_challenge/cards.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
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
                    const GameWidget.controlled(gameFactory: BeatChallenge.new),
                    GestureDetector(
                      onTap: () {
                        if (_gameService.gameState == GameState.playing) {
                          var dt = DateTime.now()
                              .difference(_gameService.lastBeat)
                              .inMilliseconds;

                          if (dt < 200) {
                            _gameService.scoreIncrease();
                            print("great");
                          } else if (dt > 300) {
                            _gameService.scoreDecrease();
                            print("miss");
                          } else {
                            print("nice");
                          }
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

class BeatChallenge extends FlameGame {
  List<SpriteComponent> cardsLoaded = [];
  List<int> currentBeat = [];

  @override
  Future<void> onLoad() async {}

  @override
  Color backgroundColor() => const Color(0xFFFFFFFF);
}
