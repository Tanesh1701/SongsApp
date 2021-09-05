import 'package:audioly/screens/playlistList.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:flutter_audio_query/flutter_audio_query.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants.dart';

class Playlists extends StatefulWidget {
  const Playlists({Key? key}) : super(key: key);

  @override
  _PlaylistsState createState() => _PlaylistsState();
}

class _PlaylistsState extends State<Playlists> {

  final FlutterAudioQuery audioQuery = FlutterAudioQuery();
  List<PlaylistInfo> playlist = [];
  final TextEditingController controller = TextEditingController();
  PlaylistInfo? newPlaylist;

  Future<void> getPlaylists() async {
    playlist = await audioQuery.getPlaylists();
  }

  dialog() {
    controller.clear();
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: TextField(
                style: GoogleFonts.montserrat(
                    textStyle: TextStyle(
                        color: Color(0xff121212), fontSize: 13, height: 2)),
                autofocus: true,
                controller: controller,
                decoration: InputDecoration(
                    labelText: 'Create a new playlist',
                    labelStyle: GoogleFonts.montserrat(
                        textStyle: TextStyle(
                            color: accentColor,
                            fontSize: 17,
                            height: 1))),
              ),
              actions: [
                TextButton(
                    onPressed: () async {
                      if(controller.text.isEmpty) {
                       
                      } else {
                      await FlutterAudioQuery.createPlaylist(playlistName: controller.text);
                      Navigator.pop(context);
                      }
                      setState(() {});
                    },
                    child: Text(
                      'Done',
                      style: GoogleFonts.montserrat(
                          textStyle: TextStyle(
                        color: Color(0xff3577FF),
                      )),
                    ))
              ]);
        });
  }

  @override
  void initState() {
    super.initState();
    getPlaylists();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Playlists",
            style: GoogleFonts.montserrat(
                textStyle: TextStyle(
                    color: fontColor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold))),
        backgroundColor: screenColor,
      ),
      body: FutureBuilder(
        future: getPlaylists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              color: screenColor,
              child: ListView.builder(
                  itemCount: playlist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Card(
                        color: screenColor,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => PlayListList(playlist[index].name, playlist, index))
                            );
                          },
                          onLongPress: () {
                            
                          },
                          child: ListTile(
                            tileColor: screenColor,
                            title: FontProperties(
                                textToBeUsed: playlist[index].name,
                                color: fontColor,
                                sizeFont: 15),
                            subtitle: FontProperties(textToBeUsed: "${playlist[index].memberIds.length} songs", color: fontColor, sizeFont: 13,),
                            trailing: IconButton(
                              icon: Icon(Icons.delete_rounded, size: 20, color: fontColor,),
                              onPressed: () async {
                                await FlutterAudioQuery.removePlaylist(playlist: playlist[index]);
                                setState((){});
                              },
                            ),
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
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: accentColor,
        child: Icon(Icons.add, size: 25, color: fontColor),
        onPressed: () {
          dialog();
        },
      ),
    );
  }
}
