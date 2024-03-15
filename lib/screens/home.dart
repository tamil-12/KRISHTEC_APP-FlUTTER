// import 'package:flutter/material.dart';
// import '../wifi_list_page.dart';
// import 'scan_screen.dart';
// class Home extends StatelessWidget {
//   const Home({Key? key}) : super(key: key); // Add const here
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Home'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to BluetoothScanPage
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => BluetoothScanPage()),
//                 );
//               },
//               icon: Icon(Icons.bluetooth), // Bluetooth icon
//               label: Text('Bluetooth'),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton.icon(
//               onPressed: () {
//                 // Navigate to WifiListPage
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => WifiListPage()),
//                 );
//               },
//               icon: Icon(Icons.wifi), // WiFi icon
//               label: Text('Wi-Fi'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../wifi_list_page.dart';
import 'scan_screen.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key); // Add const here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Bluetooth button
            ElevatedButton(
              onPressed: () {
                // Navigate to BluetoothScanPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BluetoothScanPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.blue,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bluetooth, size: 60, color: Colors.white), // Bluetooth icon
                    SizedBox(height: 10),
                    Text('Bluetooth', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),
            // Wi-Fi button
            ElevatedButton(
              onPressed: () {
                // Navigate to WifiListPage
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WifiListPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              ),
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  color: Colors.orange,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi, size: 60, color: Colors.white), // Wi-Fi icon
                    SizedBox(height: 10),
                    Text('Wi-Fi', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
