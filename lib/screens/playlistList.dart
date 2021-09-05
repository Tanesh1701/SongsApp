import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';
import 'music_player.dart';

class PlayListList extends StatefulWidget {
  final String title;
  final List<PlaylistInfo> playlist;
  final int index;

  PlayListList(this.title, this.playlist, this.index);

  @override
  _PlayListListState createState() => _PlayListListState();
}

class _PlayListListState extends State<PlayListList> {
  List<SongInfo> songs = [];
  FlutterAudioQuery audioQuery = FlutterAudioQuery();

  Future<void> getPlaylistSongs() async {
    songs = await audioQuery.getSongsFromPlaylist(playlist: widget.playlist[widget.index]);
  }

  @override
  void initState() {
    super.initState();
    getPlaylistSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.title,
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: fontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        backgroundColor: screenColor,
      ),
      body: FutureBuilder(
        future: getPlaylistSongs(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              color: screenColor,
              child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(
                      color: screenColor,
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
                        trailing: IconButton(
                          icon: Icon(Icons.delete_rounded, size: 20, color: fontColor),
                          onPressed: () async {
                            await widget.playlist[widget.index].removeSong(song: songs[index]);
                            setState(() {
                              
                            });
                          },
                        ),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Player(songs[index], songs, index)));
                        },
                      ),
                    ),
                  );
                },
              ),
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
        },
      ),
    );
  }
}
