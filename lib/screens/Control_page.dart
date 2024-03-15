// import 'dart:async';
// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import '../utils/snackbar.dart';
// import '../widgets/descriptor_tile.dart';
//
// class ControlPage extends StatefulWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//
//   const ControlPage({Key? key, required this.characteristic, required this.descriptorTiles}) : super(key: key);
//
//   @override
//   State<ControlPage> createState() => _ControlPageState();
// }
//
// class _ControlPageState extends State<ControlPage> {
//   late StreamSubscription<List<int>> _lastValueSubscription;
//
//   @override
//   void initState() {
//     super.initState();
//     _lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
//       // Handle incoming values and update UI
//       String receivedData = utf8.decode(value);
//       // Show received data in a snackbar or any other UI element
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Received data: $receivedData'),
//           duration: Duration(seconds: 2), // Adjust duration as needed
//         ),
//       );
//     });
//   }
//
//   @override
//   void dispose() {
//     _lastValueSubscription.cancel();
//     super.dispose();
//   }
//
//   Future<void> sendOn() async {
//     try {
//       String dataToSend = "on";
//       List<int> bytes = utf8.encode(dataToSend);
//       await widget.characteristic.write(bytes);
//       Snackbar.show(ABC.c, "Sent 'On' to Characteristic: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Write 'On' Error:", e), success: false);
//     }
//   }
//
//   Future<void> sendOff() async {
//     try {
//       String dataToSend = "off";
//       List<int> bytes = utf8.encode(dataToSend);
//       await widget.characteristic.write(bytes);
//       Snackbar.show(ABC.c, "Sent 'Off' to Characteristic: Success", success: true);
//     } catch (e) {
//       Snackbar.show(ABC.c, prettyException("Write 'Off' Error:", e), success: false);
//     }
//   }
//
//   Widget buildOnButton(BuildContext context) {
//     return TextButton(
//       child: Text("Send On"),
//       onPressed: () async {
//         await sendOn();
//       },
//     );
//   }
//
//   Widget buildOffButton(BuildContext context) {
//     return TextButton(
//       child: Text("Send Off"),
//       onPressed: () async {
//         await sendOff();
//       },
//     );
//   }
//
//   void _showOptions(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       builder: (BuildContext context) {
//         return Container(
//           padding: EdgeInsets.all(16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               ListTile(
//                 leading: Icon(Icons.show_chart),
//                 title: Text('Gauge'),
//                 onTap: () {
//                   // Implement action for gauge option
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.linear_scale),
//                 title: Text('Slider'),
//                 onTap: () {
//                   // Implement action for slider option
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.toggle_on),
//                 title: Text('Switch'),
//                 onTap: () {
//                   // Implement action for switch option
//                   Navigator.pop(context);
//                 },
//               ),
//               ListTile(
//                 leading: Icon(Icons.monitor),
//                 title: Text('Value Display'),
//                 onTap: () {
//                   // Implement action for value display option
//                   Navigator.pop(context);
//                   // Show received data in a snackbar or any other UI element
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     SnackBar(
//                       content: Text('Received data: $receivedData'),
//                       duration: Duration(seconds: 2), // Adjust duration as needed
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Control Page'),
//       ),
//       body: ExpansionTile(
//         title: ListTile(
//           title: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               const Text('Characteristic'),
//               Text('UUID: ${widget.characteristic.uuid}', style: TextStyle(fontSize: 13)),
//             ],
//           ),
//           subtitle: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               buildOnButton(context),
//               buildOffButton(context),
//             ],
//           ),
//           contentPadding: const EdgeInsets.all(0.0),
//         ),
//         children: widget.descriptorTiles,
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           _showOptions(context);
//         },
//         child: Icon(Icons.add),
//       ),
//     );
//   }
// }

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../utils/snackbar.dart';
import '../widgets/descriptor_tile.dart';

class ControlPage extends StatefulWidget {
  final BluetoothCharacteristic characteristic;
  final List<DescriptorTile> descriptorTiles;

  const ControlPage({Key? key, required this.characteristic, required this.descriptorTiles}) : super(key: key);

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  late StreamSubscription<List<int>> _lastValueSubscription;

  @override
  void initState() {
    super.initState();
    _lastValueSubscription = widget.characteristic.lastValueStream.listen((value) {
      // Handle incoming values and update UI
      String receivedData = utf8.decode(value);
      // Show received data in a snackbar or any other UI element
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Received data: $receivedData'),
          duration: Duration(seconds: 2), // Adjust duration as needed
        ),
      );
    });
  }

  @override
  void dispose() {
    _lastValueSubscription.cancel();
    super.dispose();
  }

  Future<void> sendOn() async {
    try {
      String dataToSend = "on";
      List<int> bytes = utf8.encode(dataToSend);
      await widget.characteristic.write(bytes);
      Snackbar.show(ABC.c, "Sent 'On' to Characteristic: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write 'On' Error:", e), success: false);
    }
  }

  Future<void> sendOff() async {
    try {
      String dataToSend = "off";
      List<int> bytes = utf8.encode(dataToSend);
      await widget.characteristic.write(bytes);
      Snackbar.show(ABC.c, "Sent 'Off' to Characteristic: Success", success: true);
    } catch (e) {
      Snackbar.show(ABC.c, prettyException("Write 'Off' Error:", e), success: false);
    }
  }

  Widget buildOnButton(BuildContext context) {
    return TextButton(
      child: Text("Send On"),
      onPressed: () async {
        await sendOn();
      },
    );
  }

  Widget buildOffButton(BuildContext context) {
    return TextButton(
      child: Text("Send Off"),
      onPressed: () async {
        await sendOff();
      },
    );
  }

  void _showOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.show_chart),
                title: Text('Gauge'),
                onTap: () {
                  // Implement action for gauge option
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.linear_scale),
                title: Text('Slider'),
                onTap: () {
                  // Implement action for slider option
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.toggle_on),
                title: Text('Switch'),
                onTap: () {
                  // Implement action for switch option
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.monitor),
                title: Text('Value Display'),
                onTap: () {
                  // Implement action for value display option
                  Navigator.pop(context);
                  // Show received data in a snackbar or any other UI element
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Received data: $receivedData'),
                      duration: Duration(seconds: 2), // Adjust duration as needed
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Control Page'),
      ),
      body: ExpansionTile(
        title: ListTile(
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Characteristic'),
              Text('UUID: ${widget.characteristic.uuid}', style: TextStyle(fontSize: 13)),
            ],
          ),
          subtitle: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildOnButton(context),
              buildOffButton(context),
            ],
          ),
          contentPadding: const EdgeInsets.all(0.0),
        ),
        children: widget.descriptorTiles,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showOptions(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
