import 'package:flutter/material.dart';


class Visualizer extends StatefulWidget {
  final int duration;
  final Color colors;
  Visualizer({required this.duration, required this.colors});

  @override
  _VisualizerState createState() => _VisualizerState();
}

class _VisualizerState extends State<Visualizer> with SingleTickerProviderStateMixin {
  Animation<double>? animation;
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: widget.duration));
    final curvedAnimation = CurvedAnimation(parent: animationController!, curve: Curves.bounceIn);

    animation = Tween<double>(begin: 0, end: 100).animate(curvedAnimation)..addListener(() { 
      setState(() {
        
      });
    });
    animationController!.repeat(reverse: true);
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
          width: 10,
          decoration: BoxDecoration(
            color: widget.colors,
            borderRadius: BorderRadius.circular(5),
          ),
          height: animation!.value + 30,
      ),
    );
  }
}