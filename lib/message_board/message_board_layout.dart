import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/message_board/bloc/message_board_bloc.dart';

class MessageBoardLayout extends StatelessWidget {
  const MessageBoardLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MessageBoardCubit, MessageBoardState>(builder: (context, state) {
      if (state.status == MessageBoardStatus.initial) {
        BlocProvider.of<MessageBoardCubit>(context).getToken(context);
      } else if (state.status == MessageBoardStatus.send_token) {
        BlocProvider.of<MessageBoardCubit>(context).sendToken(context);
      }
      var items = state.messageList!;
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return Text('${items[index].name}  ${items[index].data} ${items[index].notification}');
        },
      );
    });
  }
}
