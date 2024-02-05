import 'package:flutter/material.dart';

// initially three layers
//  MaterialApp
//    Center
//      Text

// MaterialApp
//  Scaffold
//    AppBar
//      Text

// debugShowCheckedModeBanner: false, in MaterialApp()
// attributes of AppBar()
//  backgroundColor: Colors.blueGrey[900],

// initially Image() is the only widget in the body
// set the cursor to Image( and hit Alt + Enter
// and select Center

// do not forget to put , after a widget

// create a folder, images and put diamond.png into it.
// open and edit pubspec.yaml, assets: section
// be careful about two space indentation
// after the edit, save and push pub get at the top right corner
// specify a file or a folder/ containing image files

// application icon
// create application icons on https://www.appicon.co/
// some icons are created one for mid size another for large(x) size
//
//  folders
//  i_am_rich
//    android
//      app
//        src
//          main
//            res
//              mipmap-mdpi
//              mipmap-xhdpi
//              mipmap-xxhdpi
//              mipmap-xxxxhdpi
//  overwrite the above folders by created folders.
//  in case of ios
//    ios, runner, assets.xcassets
// to list application on the android
//  hold right button and move the right hand sided ball at the same time
//
//     the style of icons created on appicon.co is old
//      select i_am_rich at Project
//      click the rigth button
//      select flutter and open in new window
//      app, res
//      right click at the res folder (not res(generated) but just res)
//      new, image assets
//      specify the original icon at PATH and adjust the size
//      this creates round icons which is current style
void main() {
  runApp(
    MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueGrey,
        appBar: AppBar(
          centerTitle: true,
          title: Text('I am Rich'),
          backgroundColor: Colors.blueGrey[900],
        ),
        body: Center(
          child: Image(image: AssetImage('images/diamond.png')
              // image: NetworkImage(
              //     'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
              ),
        ),
      ),
    ),
  );
}
