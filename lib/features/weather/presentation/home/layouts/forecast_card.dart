import 'package:flutter/material.dart';
import 'package:weather_app/features/weather/model/forecast.dart';

class ForecastCard extends StatelessWidget {
  final Forecast forecasts;

  const ForecastCard({Key? key, required this.forecasts}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: forecasts.forecastday.length,
        itemBuilder: (context, index) {
          final forecastday = forecasts.forecastday[index];
          return Padding(
            padding: const EdgeInsets.all(6.0),
            child: SizedBox(
              width: 150,
              child: Card(
                elevation: 4,
                color: Colors.grey[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(right: 8, bottom: 8),
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        forecastday.date,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Image.network(
                        forecastday.conditionIcon,
                        width: 48,
                        height: 48,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.cloud,
                            color: Colors.white,
                            size: 48,
                          );
                        },
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Temp: ${forecastday.tempC}°C',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Wind: ${forecastday.windMph}M/s',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Humidity: ${forecastday.humidity}%',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
