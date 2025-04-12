part of 'weather_bloc.dart';

abstract class WeatherBlocState extends Equatable {
  const WeatherBlocState();

  @override
  List<Object?> get props => [];

  get weatherData => null;
  get forecastData => null;
}

class WeatherInitial extends WeatherBlocState {}

class WeatherLoading extends WeatherBlocState {}

class WeatherLoaded extends WeatherBlocState {
  final WeatherModel weatherData;
  final Forecast forecastData;
  const WeatherLoaded(this.weatherData, this.forecastData);
  WeatherLoaded copyWith({
    WeatherModel? weatherData,
    Forecast? forecastData,
  }) {
    return WeatherLoaded(
      weatherData ?? this.weatherData,
      forecastData ?? this.forecastData,
    );
  }

  @override
  List<Object?> get props => [weatherData, forecastData];
}

class WeatherError extends WeatherBlocState {
  final String message;

  const WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}
