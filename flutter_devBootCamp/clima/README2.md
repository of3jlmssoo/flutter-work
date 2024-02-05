## pass data
```dart
class LocationScreen extends StatefulWidget {
  LocationScreen({this.locationWeather});
  final locationWeather;
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  WeatherModel weather = WeatherModel();

  
  @override
  void initState() {
    super.initState();
    print('========> ${widget.locationWeather}');
    updateUI(widget.locationWeather);
  }
```