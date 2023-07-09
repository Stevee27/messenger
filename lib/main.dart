import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:messenger/message_board/notification_screen.dart';

import 'api/firebase_api.dart';
import 'message_board/bloc/message_board_bloc.dart';
import 'message_board/message_board_layout.dart';
import 'models/mesage.dart';
import 'nav/bloc/nav_cubit.dart';

// FirebaseMessaging messaging = FirebaseMessaging.instance;
// final navigatorKey = GlobalKey<NavigatorState>();

class ContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  // FirebaseApi().initNotifications();
  runApp(const PreApp());
}

class PreApp extends StatelessWidget {
  const PreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(providers: [
      BlocProvider(create: (context) => MessageBoardCubit()),
    ], child: MyApp());
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      navigatorKey: ContextService.navigatorKey,
      home: MultiBlocProvider(
        providers: [
          // BlocProvider(create: (context) => NavCubit()),
          BlocProvider(create: (context) => NavCubit()),
        ],
        // child: MyHomePage(title: 'Flutter Cloud Messenger'),
        child: MessageBoardLayout(),
      ),
      routes: {
        NotificationScreen.route: (context) => const NotificationScreen(),
        MessageBoardLayout.route: (context) => const MessageBoardLayout(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.title}) {}

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _buttonPushed() {
    final message = Message(messageId: "xxxxxxxx!", name: 'Button Message', data: {'mm': 'just a button'});
    // BlocProvider.of<MessageBoardCubit>(context).addMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      // body: const Center(child: MessageBoardLayout()),
      // body: const Center(child: Text('The HomePage')),
      body: Text('The HomePage'),
      floatingActionButton: FloatingActionButton(
        onPressed: _buttonPushed,
        tooltip: 'Push Button',
        child: const Icon(Icons.question_mark),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
