import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app/features/weather/data/repository/history_repository.dart';
import 'package:weather_app/features/weather/data/repository/weather_repository.dart';
import 'package:weather_app/features/weather/model/forecast.dart';
import 'package:weather_app/features/weather/model/history.dart';
import 'package:weather_app/features/weather/model/weather.dart';
import 'package:weather_app/service/location_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
part 'weather_bloc_event.dart';
part 'weather_bloc_state.dart';

class WeatherBloc extends Bloc<WeatherBlocEvent, WeatherBlocState> {
  final WeatherRepository weatherService;
  final HistoryRepository historyRepository = HistoryRepository();
  WeatherBloc(this.weatherService) : super(WeatherInitial()) {
    on<FetchWeather>(_onFetchWeatherEvent);
    on<SearchWeather>(_onSreachWeatherEvent);
    on<FetchWeatherByCurrentCoordinates>(
        _onFetchWeatherByCurrentCoordinatesEvent);
    on<LoadMoreForecast>(_onLoadMoreForecastEvent);
  }
  void _onFetchWeatherEvent(
      FetchWeather event, Emitter<WeatherBlocState> emit) async {
    emit(WeatherLoading());
    try {
      WeatherModel weather = await weatherService.getCurrentWeather(event.city);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lastCity', weather.cityName);
      Forecast forecast = await weatherService.forecastWeather4days(event.city);
      emit(WeatherLoaded(weather, forecast));
    } catch (e) {
      print(e);
      emit(WeatherError('Failed to fetch weather data'));
    }
  }

//  void _onLoadMoreForecastEvent(
//       LoadMoreForecast event, Emitter<WeatherBlocState> emit) async {
//     emit(WeatherLoading());
//     try {
//       WeatherModel weather = await weatherService.getCurrentWeather(event.city);
//       Forecast forecast = await weatherService.loadmoreForecastWeatherDays(event.city);
//       emit(WeatherLoaded(weather, forecast));
//     } catch (e) {
//       print(e);
//       emit(WeatherError('Failed to fetch weather data'));
//     }
//   }
  void _onLoadMoreForecastEvent(
      LoadMoreForecast event, Emitter<WeatherBlocState> emit) async {
    if (state is WeatherLoaded) {
      final currentState = state as WeatherLoaded;
      try {
        Forecast forecast =
            await weatherService.loadmoreForecastWeatherDays(event.city);
           
        emit(currentState.copyWith(forecastData: forecast));
      } catch (e) {
        print(e);
        emit(WeatherError('Failed to load more forecast data'));
      }
    }
  }

  void _onFetchWeatherByCurrentCoordinatesEvent(
      FetchWeatherByCurrentCoordinates event,
      Emitter<WeatherBlocState> emit) async {
    emit(WeatherLoading());
    try {
      final location = await LocationService.getCurrentLocation();
      final latitude = location?['latitude']!;
      final longitude = location?['longitude']!;
      WeatherModel weather =
          await weatherService.getWeatherByCoordinates(latitude!, longitude!);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lastCity', weather.cityName);
      Forecast forecast =
          await weatherService.forecastWeather4days(weather.cityName);
      emit(WeatherLoaded(weather, forecast));
    } catch (e) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: const Text("Failed to fetch current weather location"),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _onSreachWeatherEvent(
      SearchWeather event, Emitter<WeatherBlocState> emit) async {
    try {
      WeatherModel weather = await weatherService.getCurrentWeather(event.city);
      Forecast forecast = await weatherService.forecastWeather4days(event.city);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('lastCity', weather.cityName);
      emit(WeatherLoaded(weather, forecast));
    } catch (e) {
      ScaffoldMessenger.of(event.context).showSnackBar(
        SnackBar(
          content: const Text("City not found! Try again!"),
          duration: const Duration(seconds: 2),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
