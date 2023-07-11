import 'package:flutter/material.dart';

class CameraHeader extends StatelessWidget {
  CameraHeader(this.title, {this.onBackPressed});
  final String title;
  final void Function()? onBackPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 150,
      decoration:const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[Colors.black, Colors.transparent],
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: onBackPressed,
            child: Container(
              margin:const EdgeInsets.all(20),
              height: 50,
              width: 50,
              child: Center(child: Icon(Icons.arrow_back)),
            ),
          ),
          Text(
            title,
            style:const TextStyle(
                color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 90,
          )
        ],
      ), 
    );
  }
}
