import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/internet_connectivity_provider.dart';
import 'no_internet_page.dart';

class InternetStateWrapper extends ConsumerStatefulWidget {
  const InternetStateWrapper({super.key, required this.child});
  final Widget child;

  @override
  ConsumerState<InternetStateWrapper> createState() =>
      _InternetStateWrapperState();
}

class _InternetStateWrapperState extends ConsumerState<InternetStateWrapper> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final internetState = ref.watch(internetConnectionStateProvider);
    if (internetState.data == false) {
      return const NoInternetPage();
    }
    return widget.child;
  }
}
