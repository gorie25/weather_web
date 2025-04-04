import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:weather_app/features/weather/bloc/email_bloc/email_bloc.dart';
import 'package:weather_app/utils/validator.dart';

class EmailSubscriptionPage extends StatefulWidget {
  final String? initialCityName;

  const EmailSubscriptionPage({Key? key, this.initialCityName}) : super(key: key);

  @override
  State<EmailSubscriptionPage> createState() => _EmailSubscriptionPageState();
}

class _EmailSubscriptionPageState extends State<EmailSubscriptionPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubscribing = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
        title: Text(
          _isSubscribing ? 'Subscribe to Weather Forecast' : 'Unsubscribe',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue[600],
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: BlocListener<EmailSubscriptionBloc, EmailSubscriptionState>(
            listener: (context, state) {
              if (state is EmailSubscriptionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.message), backgroundColor: Colors.green),
                );
                Navigator.pop(context);
              } else if (state is EmailSubscriptionError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(state.error), backgroundColor: Colors.red),
                );
              }
            },
            child: Form(
              key: _formKey,
              child: SizedBox(
                width: 300, // Đặt chiều rộng cố định cho form
                child: Column(
                  mainAxisSize: MainAxisSize.min, // Thu nhỏ chiều cao của cột
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email Address',
                        hintText: 'Enter your email address',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: validateEmail,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          if (_isSubscribing) {
                            context.read<EmailSubscriptionBloc>().add(
                              SubscribeEmail(
                                _emailController.text,
                                cityName: widget.initialCityName,
                              ),
                            );
                          } else {
                            context.read<EmailSubscriptionBloc>().add(
                              UnsubscribeEmail(_emailController.text),
                            );
                          }
                        }
                      },
                      child: Text(_isSubscribing ? 'Subscribe' : 'Unsubscribe'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _isSubscribing = !_isSubscribing;
                        });
                      },
                      child: Text(
                        _isSubscribing
                            ? 'Want to unsubscribe instead?'
                            : 'Want to subscribe instead?',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}