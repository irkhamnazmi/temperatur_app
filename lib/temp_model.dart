class TempModel {
  int? temperature;
  int? humidity;

  TempModel({this.temperature, this.humidity});

  TempModel.fromJson(Map<String, dynamic> json) {
    temperature = json['temperature'];
    humidity = json['humidity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
    };
  }
}
