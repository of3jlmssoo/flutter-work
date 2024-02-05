git clone https://github.com/flutter/codelabs.git flutter-codelabs

cd flutter-codelabs/firebase-emulator-suite/start

curl -sL https://firebase.tools | bash
curl -sL firebase.tools | upgrade=true bash

firebase login

firebase projects:list

dart pub global activate flutterfire_cli
flutterfire --help

firebase init
When prompted to select features, select "Firestore" and "Emulators". (There is no Authentication option, as it doesn't use configuration that's modifiable from your Flutter project files.)

flutterfire configure

flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add cloud_firestore

4. Enabling Firebase emulators
firebase emulators:start
http://127.0.0.1:4000/
Click Auth
Add user
   Display name: Dash
   Email: dash@email.com
   Password: dashword

multidex support
flutter run

/home/hiroshisakuma/sampleProjects/flutter-codelabs/firebase-emulator-suite/start/android/app/src/debug/AndroidManifest.xml
<application android:usesCleartextTraffic="true"/>

firestore emulator
There are no tabs for Rules, Indexes or Usage. There is a tool (discussed in the next section) that helps write security rules, but you cannot set security rules for the local emulator.

app_state.dart

StreamController in Dart

path: '/login',loggedoutviewへ行く
loginすると/へ
すると今度はLoggedInViewへ

logged_in_view.dartで
return PageView(
controller: _controller,
scrollDirection: Axis.horizontal,
children: [
EntryForm(),
for (var entry in allEntries!)
   EntryView()
]
している。横スクロール


firebase emulators:export ./emulators_data
firebase emulators:start --import ./emulators_data


firebase emulators:start --import ./emulators_data --export-on-exit

webでProejctとFirestoreは作っておく
   curl -sL https://firebase.tools | bash
firebase login
   dart pub global activate flutterfire_cli
firebase init
flutterfire configure
   flutter pub add firebase_core
   flutter pub add firebase_auth
   flutter pub add cloud_firestore
main.dart編集
```dart
void main() async {
 WidgetsFlutterBinding.ensureInitialized();
 await Firebase.initializeApp(
   options: DefaultFirebaseOptions.currentPlatform,
 );

 if (kDebugMode) {
   try {
     FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
   } catch (e) {
     // ignore: avoid_print
     print(e);
   }
 }

 runApp(MyApp());
}

```
firebase emulators:start --import ./emulators_data --export-on-exit