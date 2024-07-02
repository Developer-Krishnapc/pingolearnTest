import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../presentation/shared/model/user_state.dart';
import '../exceptions/network_exception.dart';

part 'internet_connectivity_provider.g.dart';

@Riverpod(keepAlive: true)
class InternetConnectionState extends _$InternetConnectionState {
  InternetConnectionState() {
    observe();
  }

  @override
  UserState<bool> build() {
    return UserState(data: true);
  }

  Future<void> observe() async {
    final data = await Connectivity().checkConnectivity();
    await isNetworkAvailable(data);
    Connectivity().onConnectivityChanged.listen(isNetworkAvailable);
  }

  Future<void> isNetworkAvailable(ConnectivityResult event) async {
    await Future.delayed(const Duration(seconds: 1));
    final newEvent = await Connectivity().checkConnectivity();

    final types = [
      ConnectivityResult.wifi,
      ConnectivityResult.ethernet,
      ConnectivityResult.mobile,
      ConnectivityResult.none,
    ];
    var available = types.contains(newEvent);
    if (available) {
      try {
        final result = await InternetAddress.lookup('google.com')
            .timeout(const Duration(seconds: 5));
        available = result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } on SocketException catch (_) {
        available = false; // Handle network-related errors
      } on TimeoutException catch (_) {
        available = false; // Handle timeout errors
      } catch (e) {
        print('Unexpected error: $e');
        available = false;
      }
    }
    if (state.data != available) {
      state = state.copyWith(data: available);
    }
  }

  Future<void> getCurrentConnectivityStatus() async {
    final data = await Connectivity().checkConnectivity();
    await isNetworkAvailable(data);
  }
}
