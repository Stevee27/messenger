import 'package:equatable/equatable.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    String? token = await FirebaseMessaging.instance.getToken();
    emit(state.copyWith(status: MessageBoardStatus.send_token, token: token));
  }

  sendToken(context) async {
    emit(state.copyWith(status: MessageBoardStatus.ready));
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      // Map<String, dynamic> data = message.data;
      print("THE DATA IS IN");
      var mess = Message(name: 'svx', payload: message.data);
      print(message.data);

      List<Message> newList = [...state.messageList!, mess];
      emit(state.copyWith(messageList: newList));

      // print('The user ${user.name} liked your picture "${picture.title}"!');
    });

    //TODO: SEND THRU REPO
  }

  addMessage(Message message) {
    List<Message> newList = [...state.messageList!, message];
    emit(state.copyWith(messageList: newList));
  }
}
