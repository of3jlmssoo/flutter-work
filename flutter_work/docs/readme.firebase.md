(1) Firebase
Firebase で新規プロジェクト Firebase-Flutter-Codelab
Firebase-Flutter-Codelab の初期画面の work(android)
(必要な一度削除)
Android package name : co.myfirebase.example
App nickname : My Firebase Android Example
Register app
Download google-services.json
to android/app/
Next
Groovy(build.gradle)

    <project>/build.gradle : copy and paste

    <project>/<app-module>/build.gradle

android
app
build.gradle
defaultConfig の applicationId は(1)

$ firebase init

     ######## #### ########  ######## ########     ###     ######  ########
     ##        ##  ##     ## ##       ##     ##  ##   ##  ##       ##
     ######    ##  ########  ######   ########  #########  ######  ######
     ##        ##  ##    ##  ##       ##     ## ##     ##       ## ##
     ##       #### ##     ## ######## ########  ##     ##  ######  ########

You're about to initialize a Firebase project in this directory:

/home/hiroshisakuma/projects/flutter-work/flutter_work/android

? Which Firebase features do you want to set up for this directory? Press Space to select features, then Enter to confirm your choices. Firestore: Configure security rules and indexes files for Firestore

=== Project Setup

First, let's associate this project directory with a Firebase project.
You can create multiple project aliases by running firebase use --add,
but for now we'll just set up a default project.

? Please select an option: Use an existing project
? Select a default Firebase project for this directory: fir-flutter-codelab-aec96 (Firebase-Flutter-Codelab)
i Using project fir-flutter-codelab-aec96 (Firebase-Flutter-Codelab)

=== Firestore Setup

Firestore Security Rules allow you to define how and when to allow
requests. You can keep these rules in your project directory
and publish them with firebase deploy.

? What file should be used for Firestore Rules? firestore.rules

Firestore indexes allow you to perform complex queries while
maintaining performance that scales with the size of the result
set. You can keep index definitions in your project directory
and publish them with firebase deploy.

? What file should be used for Firestore indexes? firestore.indexes.json

i Writing configuration info to firebase.json...
i Writing project information to .firebaserc...

✔ Firebase initialization complete!
hiroshisakuma@hiroshisakuma-NUC10i7FNH:~/projects/flutter-work/flutter_work/andorid

flutterfire configure で The files android/build.gradle & android/app/build.gradle will be updated to apply Firebase configuration and gradle build plugins. Do you want to continue? · yes
flutterfire configure でinitialization用オプション作成
