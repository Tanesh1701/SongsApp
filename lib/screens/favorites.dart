import 'package:audioly/db/database_provider.dart';
import 'package:audioly/screens/music_player.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants.dart';

class Favorites extends StatefulWidget {

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List favoriteMusic = [];

  @override
  void initState() {
    super.initState();
    DatabaseProvider.db.getMusic().then((value) {
      setState(() {
        favoriteMusic.addAll(value);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Favorites",
          style: GoogleFonts.montserrat(
            textStyle: TextStyle(
              color: fontColor,
              fontSize: 20,
              fontWeight: FontWeight.bold
            )
          )
        ),
        backgroundColor: screenColor,
      ),
      body: Container(
        color: screenColor,
        child: ListView.builder(
          itemCount: favoriteMusic.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Card(
                color: screenColor,
                child: ListTile(
                  tileColor: screenColor,
                  title: FontProperties(textToBeUsed: favoriteMusic[index].title, color: fontColor, sizeFont: 15),
                  subtitle: FontProperties(textToBeUsed: favoriteMusic[index].artist, color: Colors.grey, sizeFont: 13),
                  trailing: FontProperties(textToBeUsed: "${parseToMinutesSeconds(int.parse(favoriteMusic[index].duration))}", color: Colors.grey[600]!, sizeFont: 12),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Player(favoriteMusic[index], favoriteMusic, index)));
                  },
                  onLongPress: () {
                    DatabaseProvider.db.delete(favoriteMusic[index].id).then((value) {
                      setState(() {
                        favoriteMusic.removeAt(index);
                      });
                    });
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}