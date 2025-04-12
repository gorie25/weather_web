import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/repository/email_repository.dart';
part 'email_bloc_event.dart';
part 'email_bloc_state.dart';

// Bloc
class EmailSubscriptionBloc
    extends Bloc<EmailSubscriptionEvent, EmailSubscriptionState> {
  final EmailSubscriptionRepository repository;

  EmailSubscriptionBloc({required this.repository})
      : super(EmailSubscriptionInitial()) {
    on<SubscribeEmail>(_onSubscribeEmail);

    on<UnsubscribeEmail>(_onUnsubscribeEmail);
  }

  void _onSubscribeEmail(
      SubscribeEmail event, Emitter<EmailSubscriptionState> emit) async {
    emit(EmailSubscriptionLoading());
    try {
      await repository.subscribe(event.email, event.cityName);
      emit(EmailSubscriptionSuccess(
          'Verification email sent. Please check your inbox.'));
    } catch (e) {
      emit(EmailSubscriptionError(e.toString()));
    }
  }

  void _onUnsubscribeEmail(
      UnsubscribeEmail event, Emitter<EmailSubscriptionState> emit) async {
    emit(EmailSubscriptionLoading());
    try {
      await repository.unsubscribe(event.email);
      emit(EmailSubscriptionSuccess('Successfully unsubscribed.'));
    } catch (e) {
      emit(EmailSubscriptionError(e.toString()));
    }
  }
}
