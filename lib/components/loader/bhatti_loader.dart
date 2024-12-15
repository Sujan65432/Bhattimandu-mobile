import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class BhattiLoader extends StatelessWidget {
  const BhattiLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:Colors.black,
      child: Center(
          child: Container(
        padding: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'images/bhatti-cup.png',
              width: 300,
              height: 280,
            ),

            const SpinKitThreeInOut(color: Colors.white, size: 40.0)
          ],
        ),
      )),
    );
  }
}
