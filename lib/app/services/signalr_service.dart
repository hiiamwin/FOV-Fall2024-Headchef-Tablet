import 'dart:async';
import 'package:logger/logger.dart';
import 'package:signalr_netcore/signalr_client.dart';

class SignalRService {
  static final SignalRService _instance = SignalRService._internal();

  factory SignalRService() {
    return _instance;
  }

  SignalRService._internal() {
    _hubConnection = HubConnectionBuilder()
        .withUrl("http://vktrng.ddns.net:8080/notification-hub")
        .withAutomaticReconnect(
            retryDelays: [2000, 5000, 10000, 20000]).build();
    _hubConnection.on("ReceiveNewOrder", _handleNewOrder);
  }

  late HubConnection _hubConnection;
  final StreamController<String> _orderController = StreamController<String>();
  Logger logger = Logger();

  Stream<String> get orderStream => _orderController.stream;

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
    print("Disconnected from SignalR");
  }
}
