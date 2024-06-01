part of 'dash_board_bloc.dart';

@immutable
abstract class DashBoardState {}

class DashBoardInitial extends DashBoardState {}


class DashBoardConnectedToWalletState extends DashBoardState {
  final String walletAddress;
  DashBoardConnectedToWalletState(this.walletAddress);
}

class DashBoardDisConnectedToWalletState extends DashBoardState {

  DashBoardDisConnectedToWalletState();
}

class DashBoardLoadingState extends DashBoardState {
  DashBoardLoadingState();
}

class DashBoardErrorState extends DashBoardState {
  final String error;
  DashBoardErrorState(this.error);
}

class DashBoardSuccessState extends DashBoardState {
  final int projects;
  final int totalMoneyRaised;
  final int investments;
  final int totalMoneyInvested;
  DashBoardSuccessState(this.projects, this.totalMoneyRaised, this.investments, this.totalMoneyInvested);
}