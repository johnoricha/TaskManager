import 'package:equatable/equatable.dart';

abstract class StateStatus extends Equatable {
  const StateStatus();

  @override
  List<Object?> get props => [];
}

class InitialState extends StateStatus {

  const InitialState();

}

class LoadingState extends StateStatus {}

class SuccessState extends StateStatus {}

class FailedState extends StateStatus {}
