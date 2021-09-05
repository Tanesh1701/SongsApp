import 'package:audioly/constants.dart';
import 'package:audioly/screens/music_player.dart';
import 'package:audioly/screens/favorites.dart';
import 'package:audioly/screens/playlists.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<SongInfo> songs = [];
  List<SongInfo> duplicate = [];
  var toRemove = [];
  bool sortType = false;

  Future<void> getAllSongs(bool type) async {
    songs = await audioQuery.getSongs();
    duplicate = List.from(songs);

    if (type) {
      songs = songs.reversed.toList();
    } else if (type == false) {
      songs.clear();
      songs = List.from(duplicate);
    }

    songs.forEach((song) {
      if (song.isAlarm ||
          song.isNotification ||
          song.isPodcast ||
          song.isRingtone ||
          song.filePath.contains(".m4a")) {
        toRemove.add(song);
      }
    });
    songs.removeWhere((e) => toRemove.contains(e));
  }

  @override
  void initState() {
    super.initState();
    getAllSongs(sortType);
  }

  @override
  Widget build(BuildContext context) {
    songs.sort((a, b) => b.title.compareTo(a.title));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Audioly",
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: fontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        backgroundColor: screenColor,
        actions: [
          CupertinoButton(
            child: Icon(
              Icons.sort_rounded,
              size: 25,
              color: fontColor,
            ),
            onPressed: () {
              setState(() {
                sortType = !sortType;
              });
            },
          )
        ],
      ),
      body: FutureBuilder(
          future: getAllSongs(sortType),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                color: screenColor,
                child: ListView.builder(
                    itemCount: songs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Card(
                          color: screenColor,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Player(songs[index], songs, index)));
                            },
                            child: ListTile(
                              tileColor: screenColor,
                              title: FontProperties(
                                  textToBeUsed: songs[index].title,
                                  color: fontColor,
                                  sizeFont: 15),
                              subtitle: FontProperties(
                                  textToBeUsed: songs[index].artist,
                                  color: Colors.grey,
                                  sizeFont: 13),
                              trailing: FontProperties(
                                  textToBeUsed:
                                      "${parseToMinutesSeconds(int.parse(songs[index].duration))}",
                                  color: Colors.grey[600]!,
                                  sizeFont: 12),
                            ),
                          ),
                        ),
                      );
                    }),
              );
            } else {
              return Container(
                color: screenColor,
                child: Center(
                  child: CircularProgressIndicator(
                    value: 2,
                    color: accentColor,
                  ),
                ),
              );
            }
          }),
      drawer: Drawer(
        child: Container(
          color: screenColor,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
             DrawerTile(title: "Favorites", goToRoute: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Favorites()));
              }),
              DrawerTile(title: "Playlists", goToRoute: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Playlists()));
              }),
            ],
          ),
        ),
      ),
    );
  }
}

class DrawerTile extends StatelessWidget {
  final String title;
  final VoidCallback goToRoute;
  
  DrawerTile({required this.title, required this.goToRoute});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: screenColor,
      child: ListTile(
        tileColor: Colors.black,
        title: Text(
          title,
          style: GoogleFonts.montserrat(
            color: fontColor, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        onTap: goToRoute
      ),
    );
  }
}
