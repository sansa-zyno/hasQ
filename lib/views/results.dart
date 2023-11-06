import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quizapp2/admob_service.dart';
import 'package:quizapp2/views/home.dart';

class Results extends StatefulWidget {
  final int total, correct, incorrect, notattempted;
  Results({this.incorrect, this.total, this.correct, this.notattempted});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  AudioPlayer player;

  playOnScore() async {
    if (widget.correct < 5) {
      await player.setAsset('assets/Dorime.mp3');
      player.play();
    } else {
      await player.setAsset('assets/Champions.mp3');
      player.play();
    }
  }

  stopPlayer() async {
    await player.stop();
  }

  @override
  void initState() {
    super.initState();
    //AdmobService.showRewardedAd();
    player = AudioPlayer();
    playOnScore();
  }

  @override
  void dispose() {
    //AdmobService.showRewardedAd();
    stopPlayer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${widget.correct}/ ${widget.total}",
                style: TextStyle(fontSize: 25),
              ),
              SizedBox(
                height: 5,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  "You answered ${widget.correct} question(s) correctly and ${widget.incorrect} question(s) incorrectly. There are ${widget.notattempted} question(s) unattempted",
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 24,
              ),
              GestureDetector(
                onTap: () {
                  stopPlayer();
                  Navigator.pushReplacement(
                      context, MaterialPageRoute(builder: (ctx) => Home()));
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(30)),
                  child: Text(
                    "Go to home",
                    style: TextStyle(color: Colors.white, fontSize: 19),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
