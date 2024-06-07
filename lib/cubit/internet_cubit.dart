import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

part 'internet_state.dart';

class InternetCubit extends Cubit<InternetState> {
  StreamSubscription? _subscription;
  InternetCubit() : super(InternetInitial());

  void connected() {
    emit(ConnectedState(message: "Connected"));
  }

  void notConnected() {
    emit(NotConnectedState(message: "Not Connected"));
  }

  void checkConnection() {
    _subscription?.cancel();

    _subscription = Connectivity().onConnectivityChanged.listen(
        (List<ConnectivityResult>? results) {
      if (results == null || results.isEmpty) {
        notConnected();
        return;
      }

      final connectedTypes = {
        ConnectivityResult.mobile,
        ConnectivityResult.wifi,
        ConnectivityResult.ethernet,
        ConnectivityResult.vpn,
        ConnectivityResult.bluetooth,
        ConnectivityResult.other,
      };

      if (results.any(connectedTypes.contains)) {
        connected();
      } else {
        notConnected();
      }
    }, onError: (error) {
      notConnected();
    });
  }

  @override
  Future<void> close() {
    _subscription!.cancel();
    return super.close();
  }
}
