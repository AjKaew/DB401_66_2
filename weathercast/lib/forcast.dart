import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'location.dart';
import 'weather.dart';

Future<Weather> forecast() async {
  const url = 'https://data.tmd.go.th/nwpapi/v1/forecast/location/hourly/at';
  const token =
      'eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImY0NDY0YWRkMzFlMjZjNzIzN2VkODdiZWZjM2Q5Y2JlNDExOThmYTkxNDMzYmI0MDg1NmFmMzhmNDEwMmZhNjg1NDQ0YmExN2M0NDQ4Y2Y3In0.eyJhdWQiOiIyIiwianRpIjoiZjQ0NjRhZGQzMWUyNmM3MjM3ZWQ4N2JlZmMzZDljYmU0MTE5OGZhOTE0MzNiYjQwODU2YWYzOGY0MTAyZmE2ODU0NDRiYTE3YzQ0NDhjZjciLCJpYXQiOjE3MDc4ODIyMjAsIm5iZiI6MTcwNzg4MjIyMCwiZXhwIjoxNzM5NTA0NjIwLCJzdWIiOiIxNDI5Iiwic2NvcGVzIjpbXX0.bauyJHtmvPlUOasyx9vFdcadh_7uZFFaMN7qZ1tRobuUoUPz1hjYv0q23sw3NeJjhVlu5eBUL5EvZMQJXV6k5IyYSTX5PBKkuYKe1CEm66WvdXfRgMGkrM95Ibkh8eEDsQlSYCcRdeN6n1HNF-paifKOoDvBkTAJW8oyMY8iZ-rUhLSOoBBcfXXfpZ1m7TFTGeZ_JmVdJvCPFnIfqAlhZU0j7LOukDdR896iSktxFkP4mR4dqjeJ4juNQKYxH0Jy5rcD5Fzn7cBOGyb0HcuxHX3bNCOhJWlxhB41CtGaGaZt5nRyveBvHdF8rHxUwWwPJ3nNn-chiTusGEEncRxtjZ9UhEjEEoyirFvXZVhtonakRiGxKH4aKtrdsYfjvX4idz__LqfImAg5yI_R0kKLIJKgJdJAssbhkYWir9QvackqMav4BeaGdWCMbcCwmNucrktU_AhHVw2bxV3Vr_efbqX5iLOKVlX3Yya4uAxWHRIe1WUcbsddV3Jw3UrEfXtRW98z7Nh_2x0t3uf33Mkgkzlgqh-BDpFsxEXtAh8BvgX8GwRoxkQbmzjtcm6RZbUQkd9A4xkzcgDjBvs3pvy7jzW5l3SXIUHr-a-htaYNxNOoNRasWp6pmhbqK7tmxSmq_Uv9F1Oe5G03By52YmWKKQqLD5bbyDxzUcEINNPqUQ0';

  try {
    Position location = await getCurrentLocation();
    http.Response response = await http.get(
        Uri.parse(
            '$url?lat=${location.latitude}&lon=${location.longitude}&fields=tc,cond'),
        headers: {
          'accept': 'application/json',
          'authorization': 'Bearer $token'
        });
    if (response.statusCode == 200) {
      var result = jsonDecode(response.body)["WeatherForecasts"][0]["forecasts"]
          [0]["data"];
      Placemark address = (await placemarkFromCoordinates(
              location.latitude, location.longitude))
          .first;
      return Weather(
          address: '${address.subLocality}\n${address.administrativeArea}',
          temperature: result['tc'],
          cond: result['cond']);
    } else {
      return Future.error(response.statusCode);
    }
  } catch (e) {
    return Future.error(e);
  }
}
