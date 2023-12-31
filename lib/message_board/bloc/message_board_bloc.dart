import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/firebase_api.dart';
import '../../main.dart';
import '../../models/mesage.dart';
import 'message_board_repo.dart';

enum MessageBoardStatus { initial, loading, send_token, ready, success, error }

class MessageBoardState extends Equatable {
  final MessageBoardStatus? status;
  final List<Message>? messageList;
  final String? token;

  const MessageBoardState({this.status, this.messageList, this.token});

  MessageBoardState copyWith({MessageBoardStatus? status, List<Message>? messageList, String? token}) {
    return MessageBoardState(
      status: status ?? this.status,
      messageList: messageList ?? this.messageList,
      token: token ?? this.token,
    );
  }

  @override
  List<Object?> get props => [status, messageList, token];
}

class MessageBoardCubit extends Cubit<MessageBoardState> {
  MessageBoardCubit() : super(const MessageBoardState(status: MessageBoardStatus.initial, messageList: []));

  final messageBoardRepo = MessageBoardRepository();

  getToken(context) async {
    await Firebase.initializeApp();
    FirebaseApi().initNotifications();
    String? token = await FirebaseMessaging.instance.getToken();
    emit(state.copyWith(status: MessageBoardStatus.send_token, token: token));
  }

  sendToken(context) async {
    // await Send token to service
    emit(state.copyWith(status: MessageBoardStatus.ready));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      addMessage(message);
      // var mess =
      //     Message(messageId: message.messageId!, name: 'msg', data: message.data, notification: message.notification);
      // List<Message> newList = [...state.messageList!, mess];
      // emit(state.copyWith(messageList: newList));
    });
  }

  addMessage(RemoteMessage message) {
    if (state.messageList!.isNotEmpty && state.messageList!.last.messageId == message.messageId) return;
    var mess =
        Message(messageId: message.messageId!, name: 'bloc', data: message.data, notification: message.notification);
    List<Message> newList = [...state.messageList!, mess];
    emit(state.copyWith(messageList: newList));
  }

  addBackgroundMessages() async {
    print('ADDING SHARED PREFERENCED MESSAGES');
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.reload();
    final List<String>? items = prefs.getStringList('messi');
    if (items != null) {
      List<Message> updates = [];
      for (final item in items) {
        var rm = RemoteMessage.fromMap(jsonDecode(item));
        var mess = Message(messageId: rm.messageId!, name: 'bloc', data: rm.data, notification: rm.notification);
        updates.add(mess);
      }
      List<Message> newList = [...state.messageList!, ...updates];
      prefs.setStringList('messi', []);
      // prefs.remove('messi');
      emit(state.copyWith(messageList: newList));
    }
  }
}
