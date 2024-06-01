part of 'dash_board_bloc.dart';

@immutable
abstract class DashBoardEvent {}


class DashBoardConnectedToWallet extends DashBoardEvent {
  final String walletAddress;
  DashBoardConnectedToWallet(this.walletAddress);
}

class DashBoardDisConnectedToWallet extends DashBoardEvent {

  DashBoardDisConnectedToWallet();
}