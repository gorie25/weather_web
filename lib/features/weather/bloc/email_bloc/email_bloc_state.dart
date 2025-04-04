part of 'email_bloc.dart';
abstract class EmailSubscriptionState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EmailSubscriptionInitial extends EmailSubscriptionState {}

class EmailSubscriptionLoading extends EmailSubscriptionState {}

class EmailSubscriptionSuccess extends EmailSubscriptionState {
  final String message;

  EmailSubscriptionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class EmailSubscriptionError extends EmailSubscriptionState {
  final String error;

  EmailSubscriptionError(this.error);

  @override
  List<Object?> get props => [error];
}
