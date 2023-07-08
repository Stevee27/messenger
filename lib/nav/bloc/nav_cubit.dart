// import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:messenger/message_board/message_board_layout.dart';
// import 'nav_state.dart';

class NavState extends Equatable {
  final ValueKey? dest;

  const NavState({this.dest});

  NavState copyWith({ValueKey? dest}) {
    return NavState(
      dest: dest ?? this.dest,
    );
  }

  @override
  List<Object?> get props => [dest];
}

class NavCubit extends Cubit<NavState> {
  // final Set<ValueKey> destPages = <ValueKey>{};

  NavCubit() : super(const NavState(dest: MessageBoardLayout.valueKey)) {
    // destPages.add(AuthView.valueKey);
  }

  popPage(ValueKey<String> key) {
    emit(state.copyWith(dest: key));
  }

  showMessageBoard() {
    emit(state.copyWith(dest: MessageBoardLayout.valueKey));
  }
}
