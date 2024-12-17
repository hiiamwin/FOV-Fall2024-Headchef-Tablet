import 'dart:async';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();
  List<int> customRetryDelays = List.generate(1000, (_) => 2000);
  late HubConnection _hubConnection;
  final StreamController<String> _orderController = StreamController<String>();
  final StreamController<bool> _reconnectingController =
      StreamController<bool>.broadcast();
  Logger logger = Logger();

  Stream<String> get orderStream => _orderController.stream;
  Stream<bool> get reconnectingStream => _reconnectingController.stream;

  factory SignalRService() {
    return _instance;
  }

  SignalRService._internal() {
    _hubConnection = HubConnectionBuilder()
        .withUrl("http://vktrng.ddns.net:8080/notification-hub")
        .withAutomaticReconnect()
        .build();

    _hubConnection.onclose(({error}) {
      print("Connection closed: \$error");
      _reconnectingController.add(false);
    });

    _hubConnection.onreconnecting(({error}) {
      print("Reconnecting: \$error");
      _reconnectingController.add(true);
    });

    _hubConnection.onreconnected(({connectionId}) {
      print("Reconnected: \$connectionId");
      _reconnectingController.add(false);
    });

    _hubConnection.on("ReceiveNewOrder", _handleNewOrder);
  }

  Future<void> connect(String employeeId, String role) async {
    await _hubConnection.start();
    print("Connected to SignalR");
    await _hubConnection.invoke("SendEmployeeId", args: [employeeId, role]);
  }

  void _handleNewOrder(List<Object?>? args) {
    if (args != null && args.isNotEmpty) {
      final headChefId = args[0].toString();
      print("New order received for Head Chef: $headChefId");
      _orderController.add(headChefId);
    }
  }

  void disconnect() {
    _hubConnection.stop();
    _orderController.close();
    _reconnectingController.close();
    print("Disconnected from SignalR");
  }
}
