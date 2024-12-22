import 'package:flutter/material.dart';

const kColorBluePrimary = Color(0xFF00A9FF);
const kColorBlueSecondary = Color(0xFFCDF5FD);
const kColorRed = Color(0xFFD7413F);
const kColorRedButton = Color(0xFFFF403D);
const kColorGray = Color(0xFFF4F6FF);

const String temperatureUnit = "°C";
const String humidityUnit = "%";
const String lightUnit = "lx";
const String heartRateUnit = "bpm";
const String bodyTemperatureUnit = "°C";
const String pressureUnit = "hPa";

const String temperatureIcon = "assets/images/icons/temperature-control.png";
const String humidityIcon = "assets/images/icons/weather.png";
const String lightIcon = "assets/images/icons/light-bulb.png";
const String heartRateIcon = "assets/images/icons/ekg.png";
const String bodyTemperatureIcon = "assets/images/icons/body-temperature.png";
const String pressureIcon = "assets/images/icons/gauge.png";

String getGreetingMessage() {
  int hour = DateTime.now().hour;

  if (hour < 12) {
    return "Good morning!";
  } else if (hour < 18) {
    return "Good afternoon!";
  } else {
    return "Good evening!";
  }
}

class PrimaryFont {
  static String fontFamily = "Inter";

  static TextStyle regular(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontSize: size, fontWeight: FontWeight.w400);
  }

  static TextStyle medium(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontSize: size, fontWeight: FontWeight.w500);
  }

  static TextStyle bold(double size) {
    return TextStyle(
        fontFamily: fontFamily, fontSize: size, fontWeight: FontWeight.w700);
  }
}

// Future<void> loadJsonData() async {
//     // Đọc dữ liệu từ file JSON
//     String data = await rootBundle.loadString('mock/data.json');
//     setState(() {
//       jsonData = json.decode(data);
//     });
//   }

//   String encryptData(String plainText) {
//     final key = encrypt.Key.fromUtf8('WJv4mZt9Pq2x8LhT5rQn3DfU6gJbYzA1');
//     final iv = encrypt.IV.fromLength(16);
//     final encrypter =
//         encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

//     final encrypted = encrypter.encrypt(plainText, iv: iv);
//     return '${iv.base64}:${encrypted.base64}';
//   }

//   Future<void> sendMessage() async {
//     if (jsonData.isNotEmpty) {
//       // Lấy ngẫu nhiên một object từ mảng JSON
//       var randomObject = jsonData[Random().nextInt(jsonData.length)];

//       String jsonString = json.encode(randomObject);

//       // Mã hóa dữ liệu JSON
//       String encryptedData = encryptData(jsonString);

//       final conf = CoapConfig();
//       final baseUri =
//           Uri(scheme: 'coap', host: '192.168.0.161', port: conf.defaultPort);
//       final client = CoapClient(baseUri, config: conf);

//       try {
//         var response = await client.post(
//           Uri(path: 'send-message'),
//           payload: encryptedData,
//         );

//         print('Response: ${response.payloadString}');
//       } catch (e) {
//         print('Error sending message: $e');
//         client.close();
//       }
//     } else {
//       print('No data available');
//     }
//   }