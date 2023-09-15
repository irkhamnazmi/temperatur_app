class TempModel {
  String? temperature;
  String? humidity;

  TempModel({this.temperature, this.humidity});

  TempModel.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'].toString();
    humidity = json['humidity'].toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}
