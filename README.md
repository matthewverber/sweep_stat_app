## SweepStat Mobile App

The SweepStat mobile application is a cross-platform app developed in Flutter for interfacing with the low-cost SweepStat potentiostat over BLE. It allows users to set experiment parameters, send them to the device, receive experiment data, and perform basic analysis.


## Getting Started


### Prerequisites

Flutter SDK, Android/iOS Device/Emulator, an IDE (Android Studio, Xcode, VS Code, etc.)

Flutter SDK: Steps for specific OS can be found at [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) 



1. Download the Flutter SDK for your OS ([https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install))
2. Extract the SDK and add flutter to your path
3. Run command “flutter doctor” in your CLI and follow any additional steps 

Device/Emulator: View specific device and emulator install steps for all platforms at [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install) 

Setup and IDE: For this example, we will setup VS Code ([https://flutter.dev/docs/get-started/editor?tab=vscode](https://flutter.dev/docs/get-started/editor?tab=vscode)) 



1. Download and install VS Code ([https://code.visualstudio.com/](https://code.visualstudio.com/))
2. Click the View dropdown along the top, then select Command Palette.
3. Type install and select “Extensions: Install Extensions”
4. Type “flutter” in the extensions field, select Flutter, then click Install.
5. Validate that the setup worked by typing “doctor” into the Command Palette and selecting “Flutter: Run Flutter Doctor”


### Installing

To install the project and its dependencies:



1. Download the code from the Github repository: [https://github.com/ByrdOfAFeather/sweep_stat_app](https://github.com/ByrdOfAFeather/sweep_stat_app) 
    1. Download the code and unzip it to a folder OR
    2. Use the git command “git clone [https://github.com/ByrdOfAFeather/sweep_stat_app.git](https://github.com/ByrdOfAFeather/sweep_stat_app.git)”
2. In the root of the project, run the command “flutter pub get” in your CLI


### Running Locally

There are two ways to run the app locally:



*   Use the CLI command “flutter run” in the root of the project directory with a device connected
*   Use the IDE’s run commands
    *   In the case of VS Code, select the device/emulator at the bottom of the IDE, then click the dropdown Run and select “Start Debugging”


### Warranty

Instructions verified to work on Windows 10 by Jake Ryan on 11/9/2020


## Testing 

Unit and integration tests can be found in the test folder of the project. To run the tests, use the CLI command “flutter test”. To produce a lcov.info file detailing test coverage, run the CLI command “flutter test --coverage” whose output will be found in the coverage folder.

For our project, we have displayed our coverage using LCOV, which can be downloaded for macOS and Linux at [http://ltp.sourceforge.net/coverage/lcov.php](http://ltp.sourceforge.net/coverage/lcov.php). Once the coverage file has been created with “flutter test --coverage”, a graphical HTML/CSS report can be generated with the command “genhtml coverage/lcov.info”. 


## Deployment

The current version of the app is in development and hasn’t been deployed to the App Store/Play Store

Instructions for building Android apk and deploying to the Play Store can be found here: [https://flutter.dev/docs/deployment/android](https://flutter.dev/docs/deployment/android) 

Instructions for producing a release build and deploying to the App Store can be found here: [https://flutter.dev/docs/deployment/ios](https://flutter.dev/docs/deployment/ios) 


## Technologies Used 

Flutter libraries used



*   share: [https://pub.dev/packages/share](https://pub.dev/packages/share) 
*   path_provider: [https://pub.dev/packages/path_provider](https://pub.dev/packages/path_provider) 
*   fl_chart: [https://pub.dev/packages/fl_chart](https://pub.dev/packages/fl_chart) 
*   flutter_blue: [https://pub.dev/packages/flutter_blue](https://pub.dev/packages/flutter_blue) 

Development tools used 



*   VS Code: [https://code.visualstudio.com/](https://code.visualstudio.com/) 
*   Flutter: [https://flutter.dev/](https://flutter.dev/) 
*   SweepStat potentiostat: [https://www.nanoelectrochemistry.com/sweepstat](https://www.nanoelectrochemistry.com/sweepstat) 
*   Android and iOS devices

ADRs can be found at: (TODO ADD APRs TO PROJECT REPO)


## Contributing

At the time of writing (11/9/2020), this project is being developed by a team of students in the _COMP 523: Software Engineering Laboratory_ class at UNC Chapel Hill. Requirements for future contributions are TBD by the SweepStat research team, and the readme will be updated accordingly. As of now, this repository is the only system the developers need access to in order to contribute to the project. After 11/18/2020, this repo will not be actively maintained by the current development team and will be handed off to the SweepStat research team to determine next steps in development.

The Fall 2020 team has adopted the following style guide:



1. Explicit types are better than implicit types. Always define explicit types in function declarations/variable declarations when possible. When using a dynamic/var initialization, document somewhere what the type should be.
2. A widget is not complete until it is documented including the following:
    *   Function
    *   Expected variables and type
3. Tabs instead of spaces.
4. When using dart packages, ALWAYS check if the feature is implemented in both iOS and Android (**very important**).
5. Separate widgets when possible. The code can become very unreadable very quickly if monolithic widget building is in place. Also be careful not to create the same widget twice. If a form requires only a change of text and submit callback, abstract it.
6. Variable names should be in camelCase. Class names in UpperCamelCase.

As nearly all of the project is written in Dart, you should also consult the Effective Dart guide for more specific style recommendations: [https://dart.dev/guides/language/effective-dart](https://dart.dev/guides/language/effective-dart) 

For more information, see our project site for the Fall 2020 semester:

[https://tarheels.live/sweepstatf20/](https://tarheels.live/sweepstatf20/)


## Authors

Jake Ryan: [https://github.com/jake612](https://github.com/jake612) 

Braden Goodwin: [https://github.com/bradengoodwin](https://github.com/bradengoodwin)

Matthew Byrd: [https://github.com/ByrdOfAFeather](https://github.com/ByrdOfAFeather) 


## License

TBD due to in-process licensing agreements with client


## Acknowledgements

The development team would like to thank Matthew Verber, Matthew Glascott, and Rebecca Clark of the SweepStat team for their effective and continuous communication as our client. They made themselves available each week to hear about the progress of our development, give feedback, and address any uncertainty we had about design choices (and chemistry jargon). Additionally, we appreciate the time and resources they provided us in learning how the SweepStat hardware works and the purpose it serves.

We also thank our professor, Dr. Jeff Terrell, for all of the wisdom he shared in lectures as an experienced software engineer, and for his good taste in music.

