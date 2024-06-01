import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'dash_board_event.dart';
part 'dash_board_state.dart';

class DashBoardBloc extends Bloc<DashBoardEvent, DashBoardState> {
  DashBoardBloc() : super(DashBoardInitial()) {
    on<DashBoardConnectedToWallet>((event, emit) {
      emit(DashBoardConnectedToWalletState(event.walletAddress));
    });
    }
  }

