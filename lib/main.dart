import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

import 'Core/Config/app_session.dart';
import 'Core/Config/routes.dart';
import 'Features/General/Screens/home.dart';

void main() {
  runApp(MyApp());
}

bool _initialUriIsHandled = false;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
    _handleInitialUri();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  void _handleIncomingLinks() {
    if (!kIsWeb) {
      _sub = uriLinkStream.listen((Uri? uri) {});
    }
  }

  Future<void> _handleInitialUri() async {
    if (!_initialUriIsHandled) {
      _initialUriIsHandled = true;
      try {
        await getInitialUri();
      } on PlatformException {
        // print('malformed initial uri');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: AppSession()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Balout Pastry',
        theme: ThemeData(
          fontFamily: 'iranyekan',
          primaryColor: mainFontColor,
          textSelectionTheme: TextSelectionThemeData(
            cursorColor: mainFontColor,
            selectionColor: mainFontColor,
          ),
          inputDecorationTheme: InputDecorationTheme(
            // border: UnderlineInputBorder(
            //   borderSide: BorderSide(color: Colors.red),
            // ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mainFontColor),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: mainFontColor),
            ),
          ),
        ),
        routes: Routes().appRoutes,
        home: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: HomeScreen(),
        ),
      ),
    );
  }
}

// void main() => runApp(MaterialApp(home: MyApp()));

// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }

// class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
//   StreamSubscription? _sub;
//   @override
//   void initState() {
//     super.initState();
//     _handleIncomingLinks();
//     _handleInitialUri();
//   }
//   @override
//   void dispose() {
//     _sub?.cancel();
//     super.dispose();
//   }

//   void _handleIncomingLinks() {
//     if (!kIsWeb) {
//       _sub = uriLinkStream.listen((Uri? uri) {});
//     }
//   }

//   Future<void> _handleInitialUri() async {
//     if (!_initialUriIsHandled) {
//       _initialUriIsHandled = true;
//       try {
//         await getInitialUri();

//       } on PlatformException {
//         print('malformed initial uri');
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('uni_links example app'),
//       ),
//       body: Container(),
//     );
//   }
// }
