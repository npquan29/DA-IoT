import 'package:application_1/config/coap_config.dart';
import 'package:application_1/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:coap/coap.dart';
import 'dart:convert';
import 'dart:math';
import 'dart:async';
// import 'package:flutter/services.dart' show rootBundle;
import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:toastification/toastification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> jsonData = [];

  final Random _random = Random();
  SensorData sensorData = SensorData.random(Random());
  String deviceId = 'Unknown';
  // Position? currentPosition;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // loadJsonData();

    _getDeviceId();
    _updateSensorData();
    _timer = Timer.periodic(const Duration(seconds: 20), (Timer t) {
      _updateSensorData();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getDeviceId() async {
    final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        deviceId = androidInfo.id; // Android dùng ID thiết bị
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        deviceId =
            iosInfo.identifierForVendor ?? 'Unknown'; // iOS dùng identifier
      }
      setState(() {}); // Cập nhật UI sau khi lấy MAC thành công
    } catch (e) {
      print("Lỗi khi lấy địa chỉ MAC: $e");
    }
  }

  void _updateSensorData() {
    setState(() {
      sensorData = SensorData.random(_random);
    });
  }

  String encryptData(String plainText) {
    final key = encrypt.Key.fromUtf8('WJv4mZt9Pq2x8LhT5rQn3DfU6gJbYzA1');
    final iv = encrypt.IV.fromLength(16);
    final encrypter =
        encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));

    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  Future<List<double>> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.medium));
      return [position.latitude, position.longitude];
    } catch (e) {
      print("Error getting GPS position: $e");
      return [0.0, 0.0]; // Trả về giá trị mặc định khi có lỗi
    }
  }

  Future<void> sendMessage() async {
    // Lấy ngẫu nhiên một object từ mảng JSON
    final position = await _getCurrentLocation();
    final latitude = position[0];
    final longitude = position[1];

    // Tạo object JSON để gửi
    final data = {
      "deviceId": deviceId,
      ...sensorData.toJson(),
      "position": "$latitude, $longitude",
    };

    // Chuyển đổi thành chuỗi JSON
    final jsonString = jsonEncode(data);

    String encryptedData = encryptData(jsonString);

    final conf = CoapConfig();
    final baseUri =
        Uri(scheme: 'coap', host: '192.168.0.161', port: conf.defaultPort);
    final client = CoapClient(baseUri, config: conf);

    try {
      var response = await client.post(
        Uri(path: 'send-message'),
        payload: encryptedData,
      );

      if (response.isSuccess) {
        toastification.show(
          type: ToastificationType.success,
          style: ToastificationStyle.flat,
          description:
              Text(response.payloadString, style: PrimaryFont.bold(18)),
          alignment: Alignment.topCenter,
          autoCloseDuration: const Duration(seconds: 3),
          borderRadius: BorderRadius.circular(12.0),
          boxShadow: lowModeShadow,
          showProgressBar: false,
        );
      }
    } catch (e) {
      print('Error sending message: $e');
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorGray,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                "Disaster Monitoring & Support System",
                style: PrimaryFont.bold(18),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                "Parameter Monitoring Dashboard",
                style: PrimaryFont.bold(16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 14,
              ),
              Row(
                children: [
                  Expanded(
                    child: _ItemCard(
                        icon: temperatureIcon,
                        value: sensorData.temperature,
                        unit: temperatureUnit),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _ItemCard(
                        icon: humidityIcon,
                        value: sensorData.humidity,
                        unit: humidityUnit),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: _ItemCard(
                        icon: lightIcon,
                        value: sensorData.light,
                        unit: lightUnit),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _ItemCard(
                        icon: pressureIcon,
                        value: sensorData.pressure,
                        unit: pressureUnit),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                    child: _ItemCard(
                        icon: bodyTemperatureIcon,
                        value: sensorData.bodyTemperature,
                        unit: bodyTemperatureUnit),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: _ItemCard(
                        icon: heartRateIcon,
                        value: sensorData.heartRate,
                        unit: heartRateUnit),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          // Vòng tròn ngoài cùng
                          Container(
                            width: 240,
                            height: 240,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade100.withOpacity(0.3),
                            ),
                          ),
                          // Vòng tròn thứ hai
                          Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.red.shade100.withOpacity(0.6),
                            ),
                          ),
                          // Vòng tròn thứ ba
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: const CircleBorder(),
                                backgroundColor: kColorRedButton,
                                fixedSize: const Size(160, 160)),
                            onPressed: () {
                              // Xử lý sự kiện khi bấm nút
                              sendMessage();
                            },
                            child: Center(
                              child: Text(
                                "SOS",
                                style: PrimaryFont.bold(48)
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ItemCard extends StatelessWidget {
  final String icon;
  final num value;
  final String unit;

  const _ItemCard(
      {required this.icon, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(5, 17, 17, 26),
              offset: Offset(4, 4),
              spreadRadius: 0,
              blurRadius: 16,
            ),
            BoxShadow(
                color: Color.fromARGB(5, 17, 17, 26),
                offset: Offset(8, 8),
                spreadRadius: 0,
                blurRadius: 32)
          ]),
      child: Column(
        children: [
          FractionallySizedBox(
            widthFactor: 0.3,
            child: Image.asset(fit: BoxFit.cover, icon),
          ),
          const SizedBox(
            height: 8,
          ),
          Text(
            "$value $unit",
            style: PrimaryFont.bold(18),
          )
        ],
      ),
    );
  }
}

class SensorData {
  int temperature;
  int humidity;
  int light;
  int pressure;
  int heartRate;
  int bodyTemperature;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.pressure,
    required this.heartRate,
    required this.bodyTemperature,
  });

  // Hàm tạo giá trị ngẫu nhiên cho các thông số
  factory SensorData.random(Random random) {
    return SensorData(
      temperature: (15 + random.nextDouble() * 15).toInt(), // 15 - 30 °C
      humidity: (40 + random.nextDouble() * 60).toInt(), // 40 - 100 %
      light: (100 + random.nextDouble() * 900).toInt(), // 100 - 1000 lx
      pressure: (980 + random.nextDouble() * 40).toInt(), // 980 - 1020 hPa
      heartRate: 60 + random.nextInt(40), // 60 - 100 bpm
      bodyTemperature: (36 + random.nextDouble() * 2).toInt(), // 36 - 38 °C
    );
  }

  Map<String, int> toJson() {
    return {
      'temperature': temperature,
      'humidity': humidity,
      'light': light,
      'pressure': pressure,
      'heartRate': heartRate,
      'bodyTemperature': bodyTemperature,
    };
  }
}
