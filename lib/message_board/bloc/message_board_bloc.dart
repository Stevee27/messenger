import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/mesage.dart';
import 'message_board_repo.dart';

enum MessageBoardStatus { initial, loading, success, error }

class MessageBoardState extends Equatable {
  final MessageBoardStatus? status;
  final List<Message>? messageList;

  const MessageBoardState({this.status, this.messageList});

  MessageBoardState copyWith({MessageBoardStatus? status, List<Message>? messageList}) {
    return MessageBoardState(
      status: status ?? this.status,
      messageList: messageList ?? this.messageList,
    );
  }

  @override
  List<Object?> get props => [status, messageList];
}

class MessageBoardCubit extends Cubit<MessageBoardState> {
  MessageBoardCubit() : super(const MessageBoardState(status: MessageBoardStatus.initial, messageList: []));

  final messageBoardRepo = MessageBoardRepository();

  addMessage(Message message) {
    List<Message> newList = [...state.messageList!, message];
    emit(state.copyWith(messageList: newList));
  }
}
