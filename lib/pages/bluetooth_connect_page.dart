// ignore_for_file: avoid_print

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'themeData.dart';

class ReceivedData extends ChangeNotifier {
  String _data = '';
  final _dataStreamController = StreamController<String>.broadcast();
  SharedPreferences? posture;

  ReceivedData() {
    _initSharedPreferences();
    _dataStreamController.stream.listen((data) {
      print('Data added to stream: $data');
      _data = data;
      _saveDataToSharedPreferences();
    });
  }

  Future<void> _initSharedPreferences() async {
    posture = await SharedPreferences.getInstance();
  }

  Future<void> saveDisconnectedStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('postureData', '1');
    notifyListeners();
  }

  Future<void> _saveDataToSharedPreferences() async {
    await _initSharedPreferences();
    if (posture != null) {
      await posture!.setString('postureData', _data);
    }
    print('SharedPreferences in ReceivedData: $posture');
  }

  Stream<String> get dataStream => _dataStreamController.stream;

  set data(String newData) {
    _data = newData;
    _saveDataToSharedPreferences();
    notifyListeners();
  }
}

class BluetoothDevicesPage extends StatefulWidget {
  @override
  _BluetoothDevicesPageState createState() => _BluetoothDevicesPageState();
}

class BluetoothConnectionStatus extends ChangeNotifier {
  BluetoothDevice? _connectedDevice;
  Function? onConnectionSuccess;
  BluetoothDevice? get connectedDevice => _connectedDevice;
  final receivedData = ReceivedData();
  set connectedDevice(BluetoothDevice? device) {
    _connectedDevice = device;
    if (_connectedDevice != null) {
      _connectedDevice!.state.listen((state) {
        if (state == BluetoothDeviceState.disconnected) {
          receivedData.saveDisconnectedStatus();
        }
      });
    }
    notifyListeners();
  }

  bool get isDeviceConnected => _connectedDevice != null;

  Future<void> sendData(String data) async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    List<int> bytes = utf8.encode(data);

    // Discover all services
    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();

    BluetoothCharacteristic? writableCharacteristic;

    // Iterate over all services
    for (BluetoothService service in services) {
      // Iterate over all characteristics for each service
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // Check if the characteristic is writable
        if (characteristic.properties.write) {
          writableCharacteristic = characteristic;
          break;
        }
      }

      if (writableCharacteristic != null) {
        break;
      }
    }

    if (writableCharacteristic == null) {
      throw Exception('No writable characteristic found');
    }

    // Write data to the characteristic
    await writableCharacteristic.write(bytes);
  }

  Future<void> receiveData2() async {
    if (_connectedDevice == null) {
      throw Exception('No device connected');
    }

    // Discover all services
    List<BluetoothService> services =
        await _connectedDevice!.discoverServices();

    // Iterate over all services to find characteristics that support notification or indicate
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        // Check if the characteristic supports notify or indicate
        if (characteristic.properties.notify ||
            characteristic.properties.indicate) {
          // Set up the listener for notifications
          await characteristic.setNotifyValue(true);

          // Listen to the data stream
          characteristic.value.listen((value) {
            // Handle incoming data
            String receivedData = utf8.decode(value);
            print('Received data: $receivedData');

            // Save the received data
            ReceivedData().data = receivedData;
          });
        }
      }
    }
  }
}

class _BluetoothDevicesPageState extends State<BluetoothDevicesPage> {
  List<ScanResult> devices = [];
  BluetoothDevice? connectedDevice;

  @override
  void initState() {
    super.initState();
    scanForDevices();
  }

  bool isDeviceConnected() {
    return connectedDevice != null;
  }

  void scanForDevices() async {
    if (await FlutterBluePlus.isSupported == false) {
      print("Bluetooth not supported by this device");
      return;
    } else
      print("Bluetooth is supported by this device");

    // Wait for Bluetooth enabled & permission granted
    await FlutterBluePlus.adapterState
        .where((val) => val == BluetoothAdapterState.on)
        .first;

    // Start scanning w/ timeout
    await FlutterBluePlus.startScan(
        withServices: [], withNames: [], timeout: Duration(seconds: 15));
    print("!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Scanning for devices");

    // listen to scan results
    var subscription = FlutterBluePlus.onScanResults.listen((results) {
      if (results.isNotEmpty) {
        setState(() {
          devices = results;
        });
      }
    }, onError: (e) => print(e));

    // cleanup: cancel subscription when scanning stops
    FlutterBluePlus.cancelWhenScanComplete(subscription);

    // wait for scanning to stop
    await FlutterBluePlus.isScanning.where((val) => val == false).first;
  }

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<BluetoothConnectionStatus>(context);
    MyThemeColors currentColors = Provider.of<MyThemes>(context).currentColors;

    return Scaffold(
      backgroundColor: currentColors.background,
      body: Column(
        children: [
          Stack(
            children: <Widget>[
              Container(
                height: 150,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                      Provider.of<MyThemes>(context).currentColors.bluetooth,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      currentColors.background.withOpacity(1),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (connectionStatus.isDeviceConnected)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Card(
                color: currentColors.card,
                child: ListTile(
                  title: Text(
                    'Connected to ${connectionStatus.connectedDevice!.name}',
                    style: TextStyle(
                      color: currentColors.bodyText1,
                    ),
                  ),
                  trailing: ElevatedButton(
                    child: Text(
                      'Disconnect',
                      style: TextStyle(
                        color: currentColors.bodyText2,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(currentColors.button),
                    ),
                    onPressed: () async {
                      await connectionStatus.connectedDevice!.disconnect();
                      setState(() {
                        connectionStatus.connectedDevice = null;
                      });
                    },
                  ),
                ),
              ),
            ),
          SizedBox(height: 10.0),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                // Call the scanForDevices function
                scanForDevices();
              },
              color: currentColors.button,
              child: ListView.separated(
                physics:
                    const AlwaysScrollableScrollPhysics(), // Enable pull-to-refresh
                itemCount: devices.length,
                separatorBuilder: (context, index) => Divider(),
                itemBuilder: (context, index) {
                  if (connectionStatus.connectedDevice != null &&
                      devices[index].device ==
                          connectionStatus.connectedDevice) {
                    return Container();
                  }

                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Card(
                      color: currentColors.card2,
                      child: ListTile(
                        title: Text(devices[index].advertisementData.advName),
                        subtitle:
                            Text(devices[index].device.remoteId.toString()),
                        trailing: ElevatedButton(
                          child: Text(
                            'Connect',
                            style: TextStyle(color: currentColors.bodyText3),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              currentColors.button,
                            ),
                          ),
                          onPressed: () async {
                            await devices[index].device.connect();
                            setState(() {
                              connectionStatus.connectedDevice =
                                  devices[index].device;
                            });

                            DateTime now = DateTime.now();
                            int totalMinutes = now.hour * 60 + now.minute;
                            String data = 'C${totalMinutes}C';

                            try {
                              await connectionStatus.sendData(data);
                            } catch (e) {
                              print('Failed to send data: $e');
                            }
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
