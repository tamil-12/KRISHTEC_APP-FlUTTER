import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:wifi_iot/wifi_iot.dart';
import 'dart:convert';

class WifiConnectedScreen extends StatefulWidget {
  final WifiNetwork connectedNetwork;

  const WifiConnectedScreen({Key? key, required this.connectedNetwork}) : super(key: key);

  @override
  _WifiConnectedScreenState createState() => _WifiConnectedScreenState();
}

class _WifiConnectedScreenState extends State<WifiConnectedScreen> {
  String? ipAddress;

  @override
  void initState() {
    super.initState();
    _getIpAddress();
  }

  Future<void> _getIpAddress() async {
    String? ip = await WiFiForIoTPlugin.getIP();
    setState(() {
      ipAddress = ip;
    });
  }

  Future<void> _sendDataToESP32(String action) async {
    try {
      String url = 'http://192.168.1.1/send-data'; // Assuming ipAddress is the ESP32's IP
      Map<String, String> data = {'action': action};

      // Convert the data map to a JSON string
      String jsonData = json.encode(data);

      // Set the headers to indicate that the request body contains JSON data
      Map<String, String> headers = {'Content-Type': 'application/json'};

      // Send the JSON data to the ESP32
      await http.post(Uri.parse(url), headers: headers, body: jsonData);
    } catch (e) {
      print('Error sending data to ESP32: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WiFi Connected'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Connected to: ${widget.connectedNetwork.ssid}'),
            SizedBox(height: 20),
            Text('IP Address: ${ipAddress ?? "Loading..."}'),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _sendDataToESP32('on');
              },
              child: Text('Turn On LED'),
            ),
            ElevatedButton(
              onPressed: () {
                _sendDataToESP32('off');
              },
              child: Text('Turn Off LED'),
            ),
          ],
        ),
      ),
    );
  }
}
// wifi_list_page.dart


// import 'package:flutter/material.dart';
// import 'package:wifi_iot/wifi_iot.dart';
//
// class WifiConnectedScreen extends StatefulWidget {
//   final WifiNetwork? connectedNetwork;
//
//   const WifiConnectedScreen({Key? key, this.connectedNetwork}) : super(key: key);
//
//   @override
//   _WifiConnectedScreenState createState() => _WifiConnectedScreenState();
// }
//
// class _WifiConnectedScreenState extends State<WifiConnectedScreen> {
//   String? _ipAddress;
//
//   @override
//   void initState() {
//     super.initState();
//     _connectToWifi();
//   }
//
//   Future<void> _connectToWifi() async {
//     try {
//       if (widget.connectedNetwork != null) {
//         String ssid = widget.connectedNetwork!.ssid ?? '';
//         await WiFiForIoTPlugin.connect(ssid, security: NetworkSecurity.WPA, password: 'password');
//         String? ipAddress = await WiFiForIoTPlugin.getIP();
//         setState(() {
//           _ipAddress = ipAddress;
//         });
//       }
//     } catch (e) {
//       print('Error connecting to Wi-Fi network: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Wi-Fi Connected'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             if (widget.connectedNetwork != null)
//               Text('Connected to: ${widget.connectedNetwork!.ssid ?? "Unknown"}'),
//             SizedBox(height: 20),
//             Text('IP Address: ${_ipAddress ?? "Loading..."}'),
//           ],
//         ),
//       ),
//     );
//   }
// }


