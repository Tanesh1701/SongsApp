import 'package:audioly/constants.dart';
import 'package:audioly/db/database_provider.dart';
import 'package:audioly/models/model.dart';
import 'package:audioly/screens/addtoplaylist.dart';
import 'package:audioly/visualizers.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class Player extends StatefulWidget {
  var song;
  List songs = [];
  int index;
  Player(this.song, this.songs, this.index);

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<Player> with SingleTickerProviderStateMixin {
  bool pause = true, isFavorite = false, isShuffled = false;
  AudioPlayer _player = new AudioPlayer();
  String? songTitle;
  String? songArtist;
  String? path;
  int? songIndex;
  Duration _position = new Duration(), _duration = new Duration();
  Music? music;
  var dropdownItems = ["Add to playlist", "Loop", "Repeat list", "Share"];
  String dropdownValue = "Add to playlist";

  void shuffle() {
    widget.songs.shuffle();
  }

  void unshuffle() {
    widget.songs.sort((a,b) => a.title.compareTo(b.title));
  }

  Widget slider() {
    return SliderTheme(
      data: SliderThemeData(
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 7.0),
      ),
      child: Slider(
        activeColor: accentColor,
        inactiveColor: secondaryColor,
        value: _position.inSeconds.toDouble(),
        min: 0.0,
        max: _duration.inSeconds.toDouble(),
        onChanged: (double value) {
          setState(() {
            changeToSecond(value.toInt());
            value = value;
          });
        },
      ),
    );
  }

  void changeToSecond(int second) {
    Duration newDuration = Duration(seconds: second);
    _player.seek(newDuration);
  }

  @override
  void initState() {
    super.initState();
    songIndex = widget.index;
    _player.play(widget.songs[widget.index].filePath, isLocal: true);
    songTitle = widget.songs[widget.index].title;
    songArtist = widget.songs[widget.index].artist;
    path = widget.songs[widget.index].filePath;
    _player.onDurationChanged.listen((d) { 
      setState(() {
        _duration = d;
      });
    });
    _player.onAudioPositionChanged.listen((d) { 
      setState(() {
        _position = d;
      });
    });
    _player.onPlayerCompletion.listen((event) async{
      songIndex = songIndex! + 1;
      await _player.stop();
      await _player.play(widget.songs[songIndex!].filePath, isLocal: true);
      setState(() {
        songTitle = widget.songs[songIndex!].title;
        songArtist = widget.songs[songIndex!].artist;
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement playing music in background alongside a notification player
    super.dispose();
    _player.stop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: screenColor,
        title: Text(
          "Now playing",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: fontColor,
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          ),
        ),
        actions: [
          DropdownButton(
            dropdownColor: screenColor,
            underline: Container(),
            icon: Icon(Icons.more_vert_rounded, size: 25, color: fontColor),
            items: dropdownItems.map((String items) {
              return DropdownMenuItem(
                value: items,
                child: FontProperties(textToBeUsed: items, color: fontColor, sizeFont: 15,)
              );
            }
            ).toList(),
            onChanged: (String? newValue) {
              dropdownValue = newValue!;
              switch (newValue) {
                case "Add to playlist":
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddToPlaylist(widget.songs[widget.index])),
                    );
                  break;
                case "Loop":
                setState(() {
                  dropdownItems[1] = "Loop - on";
                });
                break;
                default:
              }
            },
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              height: 120,
              width: double.infinity,
              child: pause ? VisualizerSettings() : Container(color: screenColor)
            ),
            Text(
              songTitle!,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: fontColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  height: 1.5
                  )
                ),
                textAlign: TextAlign.center,
              ),
             Text(
              songArtist!,
              style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                  color: secondaryColor,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
                  )
                ),
              ),
            slider(),
            Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Text(
                      _position.toString().split(".")[0].substring(2),
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: fontColor,
                          fontSize: 15
                        )
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 15.0),
                    child: Text(
                      _duration.toString().split(".")[0].substring(2),
                      style: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                          color: fontColor,
                          fontSize: 15
                        )
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CupertinoButton(
                  child: isFavorite == false ? Icon(Icons.favorite_outline_rounded, color: accentColor, size: 30) : Icon(Icons.favorite_rounded, color: accentColor, size: 30),
                  onPressed: () {
                    isFavorite = !isFavorite;
                    music = Music(songTitle, songArtist, widget.songs[songIndex!].duration, path);
                    DatabaseProvider.db.insert(music!);
                  },
                ),
                CupertinoButton(
                  onPressed: () async{
                   setState(() {
                     pause = true;
                     songIndex = songIndex! - 1;
                     songTitle = widget.songs[songIndex!].title;
                     songArtist = widget.songs[songIndex!].artist;
                   });

                    await _player.stop();
                    await _player.play(widget.songs[songIndex!].filePath, isLocal: true);
                    setState(() {});
                  },
                  child: Icon(Icons.skip_previous_rounded, color: accentColor, size: 40),
                ),
                CupertinoButton(
                  child: pause ? Icon(Icons.pause_rounded, color: accentColor, size: 40): Icon(Icons.play_arrow_rounded, color: accentColor, size: 40),
                  onPressed: () async{
                    if(pause == false) {
                      await _player.play(widget.songs[songIndex!].filePath, isLocal: true);
                      setState(() {
                        pause = true;
                      });
                    } else if (pause == true) {
                      await _player.pause();
                      setState(() {
                        pause = false;
                      });
                    }
                  },
                ),
                CupertinoButton(
                  onPressed: () async {
                    setState(() {
                      pause = true;
                      songIndex = songIndex! + 1;
                      songTitle = widget.songs[songIndex!].title;
                      songArtist = widget.songs[songIndex!].artist;
                    });

                    await _player.stop();
                    await _player.play(widget.songs[songIndex!].filePath, isLocal: true);
                    setState((){});
                  },
                  child: Icon(Icons.skip_next_rounded, color: accentColor, size: 40),
                ),
                CupertinoButton(
                  child: isShuffled == false ? Icon(Icons.shuffle_rounded, color: accentColor, size: 30) : Icon(Icons.shuffle_on_rounded, color: accentColor, size: 30),
                  onPressed: () {
                    if (isShuffled == true) {
                      unshuffle();
                      setState(() {
                        isShuffled = false;
                      });
                    }
                    else if (isShuffled == false) {
                      shuffle();
                      setState(() {
                        isShuffled = true;
                      });
                    }
                  },
                )
              ],
            ),
          ],
        )
      ),
      backgroundColor: screenColor,
    );
  }
}


// ignore: must_be_immutable
class VisualizerSettings extends StatelessWidget {
  List<Color> color = [accentColor, accentColor, accentColor, accentColor];
  List<int> duration = [900, 700, 600, 800, 500];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: new List<Widget>.generate(10, (index) => Visualizer(duration: duration[index % 5], colors: color[index % 4]))
    );
  }
}
