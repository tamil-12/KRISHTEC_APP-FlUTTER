import 'package:flutter/material.dart';
import 'package:flutter_reactive_ble/flutter_reactive_ble.dart';
import 'dart:convert';
import 'package:syncfusion_flutter_gauges/gauges.dart'; // Import Syncfusion Flutter package

class ConnectedPage extends StatefulWidget {
  final String deviceId;

  ConnectedPage({required this.deviceId});

  @override
  _ConnectedPageState createState() => _ConnectedPageState();
}

class _ConnectedPageState extends State<ConnectedPage> {
  late final FlutterReactiveBle _flutterReactiveBle;
  late QualifiedCharacteristic _characteristic;
  double _gaugeValue = 0; // Variable to hold gauge value
  double _sliderValue = 0; // Variable to hold slider value
  double _minSliderValue = 0; // Minimum range for slider
  double _maxSliderValue = 100; // Maximum range for slider
  List<ItemModel> _items = []; // List to hold selected options
  bool _isSwitchOn = false; // Variable to hold switch state
  bool _isDisconnected = false;

  set _isConnected(bool _isConnected) {} // Variable to track disconnection status

  @override
  void initState() {
    super.initState();
    _flutterReactiveBle = FlutterReactiveBle();
    _characteristic = QualifiedCharacteristic(
      serviceId: Uuid.parse("fc96f65e-318a-4001-84bd-77e9d12af44b"),
      characteristicId: Uuid.parse("04d3552e-b9b3-4be6-a8b4-aa43c4507c4d"),
      deviceId: widget.deviceId,
    );
    _subscribeToCharacteristic();
  }
  void _subscribeToCharacteristic() {
    _flutterReactiveBle.subscribeToCharacteristic(_characteristic).listen(
          (data) {
        // Handle received data
        _handleReceivedData(data);
      },
      onError: (error) {
        print('Error subscribing to characteristic: $error');
        // Handle subscription error
        setState(() {
          _isConnected = false; // Update connection state
        });
        // Show disconnection message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device disconnected')),
        );
        // Navigate back to the previous screen
        Navigator.pop(context);
      },
      onDone: () {
        // Handle disconnection
        setState(() {
          _isConnected = false; // Update connection state
        });
        // Show disconnection message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Device disconnected')),
        );
        // Navigate back to the previous screen
        Navigator.pop(context);
      },
    );
  }


  void _handleReceivedData(List<int> data) {
    try {
      // Decode the received data
      String receivedString = utf8.decode(data);
      // Example: If the received data is a character string
      print('Received String: $receivedString');

      // Example: If the received data is a floating-point value
      double receivedValue = double.parse(receivedString);
      print('Received Value: $receivedValue');

      // Check if the widget is mounted before calling setState
      if (mounted) {
        setState(() {
          // Update gauge value if there's a Radial Gauge item
          var radialGaugeItem = _items.firstWhere((item) => item.type == 'Radial Gauge', orElse: () => ItemModel(type: 'Radial Gauge'));
          radialGaugeItem.value = receivedValue;

          // Update display value if there's a Display item
          var displayItem = _items.firstWhere((item) => item.type == 'Display', orElse: () => ItemModel(type: 'Display'));
          displayItem.value = receivedValue;
        });
      }
    } catch (e) {
      print('Error handling received data: $e');
      // Handle parsing error
    }
  }

  void _sendpin(int data, String selectedPinMode) async {
    try {
      // Construct the string to send, including pin number and mode
      String dataString = 'Pin $data, Pin mode:$selectedPinMode';

      // Encode the string data to bytes
      List<int> bytes = utf8.encode(dataString);

      // Write the bytes to the characteristic
      await _flutterReactiveBle.writeCharacteristicWithResponse(
        _characteristic,
        value: bytes,
      );

      // Data sent successfully, provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data sent successfully')),
      );
    } catch (e) {
      print('Error sending data: $e');
      // Handle write error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send data')),
      );
    }
  }


  void _sendData(int data) async {
    try {
      // Convert the integer value to a string
      String dataString = data.toString();

      // Encode the string data to bytes
      List<int> bytes = utf8.encode(dataString);

      // Write the bytes to the characteristic
      await _flutterReactiveBle.writeCharacteristicWithResponse(
        _characteristic,
        value: bytes,
      );

      // Data sent successfully, provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Data sent successfully')),
      );
    } catch (e) {
      print('Error sending data: $e');
      // Handle write error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send data')),
      );
    }
  }

  void _showOptionsPopupMenu() {
    if (!_isDisconnected) {
      showMenu(
        context: context,
        position: RelativeRect.fromLTRB(100, 100, 0, 0),
        items: [
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.show_chart),
              title: Text('Radial Gauge'),
            ),
            value: 'Radial Gauge',
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.linear_scale),
              title: Text('Slider'),
            ),
            value: 'Slider',
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.text_fields),
              title: Text('Display'),
            ),
            value: 'Display',
          ),
          PopupMenuItem(
            child: ListTile(
              leading: Icon(Icons.toggle_on),
              title: Text('Switch'),
            ),
            value: 'Switch',
          ),
        ],
      ).then((value) {
        // Handle the selected option
        if (value != null) {
          // Check if the selected type already exists in the list
          bool exists =true;
          if (exists) {
            setState(() {
              _items.add(ItemModel(type: value)); // Add selected option to the list
            });
          } else {
            // Show error message for duplicate selection
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Cannot add duplicate items')),
            );
          }
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Cannot add items when disconnected')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connected Device'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _showOptionsPopupMenu,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Device ID: ${widget.deviceId}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _items.length,
                itemBuilder: (context, index) {
                  return Dismissible(
                    key: Key(_items[index].type),
                    onDismissed: (direction) {
                      setState(() {
                        _items.removeAt(index); // Remove item from the list
                      });
                    },
                    background: Container(color: Colors.red),
                    child: buildItem(_items[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildItem(ItemModel item) {
    final double boxHeight = 280; // Height of the box
    final double boxWidth = double.infinity; // Width of the box

    return Container(
      height: boxHeight,
      width: boxWidth,
      child: Card(
        elevation: 4,
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item.title.isNotEmpty ? item.title : item.type,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 8),
                if (item.type == 'Radial Gauge')
                  Expanded(
                    child: Center(
                      child: Container(
                        padding: EdgeInsets.all(8),
                        child: AspectRatio(
                          aspectRatio: 1,
                          child: SfRadialGauge(
                            // Radial Gauge configuration
                            axes: <RadialAxis>[
                              RadialAxis(
                                minimum: item.minRange,
                                maximum: item.maxRange,
                                ranges: <GaugeRange>[
                                  GaugeRange(startValue: item.minRange, endValue: item.value, color: Colors.green),
                                ],
                                pointers: <GaugePointer>[
                                  NeedlePointer(value: item.value, enableAnimation: true),
                                ],
                                annotations: <GaugeAnnotation>[
                                  GaugeAnnotation(
                                    widget: Text(
                                      item.value.toStringAsFixed(2),
                                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                                    ),
                                    angle: 90,
                                    positionFactor: 0.5,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                if (item.type == 'Slider')
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Slider(
                            value: _sliderValue,
                            min: item.minRange,
                            max: item.maxRange,
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                              });
                            },
                            onChangeEnd: (value) {
                              _sendData(value.toInt());
                            },
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Value: ${_sliderValue.toInt()}',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (item.type == 'Switch')
                  Expanded(
                    child: Center(
                      child: Switch(
                        value: _isSwitchOn,
                        onChanged: (value) {
                          setState(() {
                            _isSwitchOn = value;
                          });
                          // Send data based on switch value
                          int dataToSend = value ? 1 : 0;
                          _sendData(dataToSend);
                        },
                      ),
                    ),
                  ),
                if (item.type == 'Display')
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        // Handle displaying the value
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: Text('Value'),
                            content: Text('${item.value.toInt()}'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('OK'),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.all(8.0),
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Center(
                          child: Text(
                            '${item.value.toInt()}',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                icon: Icon(Icons.settings),
                onPressed: () {
                  _showSettingsDialog(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
  void _showSettingsDialog(ItemModel item) {
    TextEditingController titleController = TextEditingController(text: item.title);
    double minRange = item.minRange; // Default minimum range
    double maxRange = item.maxRange; // Default maximum range
    int? selectedPin = item.selectedPin; // Selected pin
    String selectedPinMode = 'Input'; // Default pin mode
    List<String> pinModes = ['Input', 'Output']; // Pin mode options

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Settings'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(labelText: 'Title'),
              onChanged: (value) {
                setState(() {
                  item.title = value; // Update the title
                });
              },
            ),
            // Add pin mode dropdown
            SizedBox(height: 20),
            Row(
              children: [
                Text('Pin Mode:'),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: selectedPinMode, // Bind selectedPinMode to the dropdown value
                  onChanged: (String? value) {
                    setState(() {
                      selectedPinMode = value!;
                    });
                  },
                  items: pinModes.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
            // Show only min and max range settings for Radial Gauge
            if (item.type == 'Radial Gauge')
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Minimum Range:'),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.minRange.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              minRange = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Maximum Range:'),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.maxRange.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              maxRange = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            // Show min and max range settings for Slider
            if (item.type == 'Slider')
              Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Minimum Value:'),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.minRange.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              minRange = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Text('Maximum Value:'),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          initialValue: item.maxRange.toString(),
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            setState(() {
                              maxRange = double.parse(value);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            // Show pin selection for all widget types
            SizedBox(height: 20),
            Row(
              children: [
                Text('Select Pin:'),
                SizedBox(width: 10),
                Expanded(
                  child: TextFormField(
                    initialValue: selectedPin != null ? selectedPin.toString() : '',
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {
                        if (value.isNotEmpty) {
                          int pin = int.parse(value);
                          // Limit pin range from 1 to 14
                          if (pin < 1) {
                            selectedPin = 1;
                          } else if (pin > 14) {
                            selectedPin = 14;
                          } else {
                            selectedPin = pin;
                          }
                        } else {
                          selectedPin = null;
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              bool isPinAlreadyAssigned = _items.any((item) => item.selectedPin == selectedPin && item.type != 'Display');
              if (!isPinAlreadyAssigned) {
                setState(() {
                  item.title = titleController.text;
                  if (item.type == 'Radial Gauge') {
                    item.minRange = minRange;
                    item.maxRange = maxRange;
                  }
                  if (item.type == 'Slider') {
                    item.minRange = _minSliderValue;
                    item.maxRange = _maxSliderValue;
                  }
                  item.selectedPin = selectedPin;
                });
                _sendpin(selectedPin ?? 0, selectedPinMode); // Send pin number and mode
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Pin already assigned to another item')),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class ItemModel {
  late String type;
  late String title;
  late double minRange;
  late double maxRange;
  late double value; // Added to hold the value for Display items
  int? selectedPin; // Updated to allow null value

  ItemModel({required this.type, this.title = "", this.minRange = 0, this.maxRange = 100, this.value = 0, this.selectedPin});
}

