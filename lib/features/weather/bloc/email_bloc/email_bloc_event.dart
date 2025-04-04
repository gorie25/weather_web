part of 'email_bloc.dart';
abstract class EmailSubscriptionEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubscribeEmail extends EmailSubscriptionEvent {
  final String email;
  final String? cityName;

  SubscribeEmail(this.email, {this.cityName});

  @override
  List<Object?> get props => [email, cityName];
}

class VerifyEmail extends EmailSubscriptionEvent {
  final String email;
  final String token;

  VerifyEmail(this.email, this.token);

  @override
  List<Object?> get props => [email, token];
}

class UnsubscribeEmail extends EmailSubscriptionEvent {
  final String email;

  UnsubscribeEmail(this.email);

  @override
  List<Object?> get props => [email];
}

