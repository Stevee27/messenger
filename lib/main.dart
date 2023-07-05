import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'firebase_options.dart';

import 'message_board/bloc/message_board_bloc.dart';
import 'message_board/message_board_layout.dart';
import 'models/mesage.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // String? token = await messaging.getToken();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MultiBlocProvider(providers: [
          BlocProvider(create: (context) => MessageBoardCubit()),
        ], child: MyHomePage(title: 'Flutter Cloud Messenger')));
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _buttonPushed() {
    print("PUSHED");
    final message = Message(name: 'Button Message', payload: '');
    BlocProvider.of<MessageBoardCubit>(context).addMessage(message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: const Center(
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: <Widget>[
          //     MessageBoardLayout(),
          //   ],
          // ),
          child: MessageBoardLayout()),
      floatingActionButton: FloatingActionButton(
        onPressed: _buttonPushed,
        tooltip: 'Push Button',
        child: const Icon(Icons.question_mark),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
