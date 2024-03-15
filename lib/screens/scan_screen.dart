
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'package:snowcounter/screens/connected_screen.dart';

class BluetoothScanPage extends StatefulWidget {
  @override
  _BluetoothScanPageState createState() => _BluetoothScanPageState();
}

class _BluetoothScanPageState extends State<BluetoothScanPage> {
  final flutterReactiveBle = FlutterReactiveBle();
  List<DiscoveredDevice> discoveredDevices = [];
  Map<String, bool> connectedDevices = {};

  bool isScanning = false;

  StreamSubscription? scanSubscription;

  @override
  void dispose() {
    scanSubscription?.cancel();
    super.dispose();
  }

  Future<void> scanForDevices() async {
    setState(() {
      isScanning = true;
      discoveredDevices.clear(); // Clear existing devices before scanning
    });

    try {
      scanSubscription = flutterReactiveBle
          .scanForDevices(withServices: [])
          .listen((device) {
        setState(() {
          if (!discoveredDevices.any((element) => element.id == device.id) &&
              device.name != null) {
            discoveredDevices.add(device);
            connectedDevices[device.id] =
            false; // Initialize as not connected
          }
        });
      }, onError: (dynamic error) {
        print('Error during scanning: $error');
        setState(() {
          isScanning = false;
        });
      }, onDone: () {
        setState(() {
          isScanning = false;
        });
      });

      // Stop scanning after 6 seconds
      Timer(Duration(seconds: 6), () {
        if (isScanning) {
          scanSubscription?.cancel();
          setState(() {
            isScanning = false;
          });
        }
      });
    } catch (e) {
      print('Error during scanning: $e');
      setState(() {
        isScanning = false;
      });
    }
  }

  Future<void> connectToDevice(DiscoveredDevice device) async {
    try {
      await flutterReactiveBle
          .connectToDevice(
        id: device.id,
        servicesWithCharacteristicsToDiscover: {},
        connectionTimeout: const Duration(seconds: 2),
      )
          .first;
      print('Connected to ${device.name}');
      setState(() {
        connectedDevices[device.id] = true; // Mark as connected
      });

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConnectedPage(
            deviceId: device.id,
          ),
        ),
      );
    } catch (e) {
      print('Error connecting to ${device.name}: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bluetooth Mode'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: isScanning ? null : scanForDevices,
            child: Text(isScanning ? 'Scanning...' : 'Scan for Devices'),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: discoveredDevices.isEmpty ? 1 : discoveredDevices.length,
              itemBuilder: (context, index) {
                if (discoveredDevices.isEmpty) {
                  // Display a message when no devices are found
                  return Center(
                    child: Text('No devices found'),
                  );
                } else {
                  final device = discoveredDevices[index];
                  if (device.name != null) {
                    return ListTile(
                      title: Text(device.name!),
                      subtitle: Text(device.id),
                      trailing: ElevatedButton(
                        onPressed: connectedDevices[device.id] == true
                            ? null
                            : () => connectToDevice(device),
                        child: Text(
                          connectedDevices[device.id] == true
                              ? 'Connected'
                              : 'Connect',
                        ),
                      ),
                    );
                  } else {
                    // Return an empty container if device name is null
                    return Container();
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
