import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/gen/assets.gen.dart';
import '../../theme/config/app_color.dart';

final toggleFabProvider = StateProvider<bool>((ref) {
  return false;
});

class ExpandableFabWidget extends StatelessWidget {
  const ExpandableFabWidget({super.key, required this.actionList});
  final List<VoidCallback> actionList;

  @override
  Widget build(BuildContext context) {
    return ExpandableFab(
      distance: 60,
      children: [
        ActionButton(
          onPressed: () => actionList[0].call(),
          icon: Assets.svg.scanIcon.svg(),
        ),
        ActionButton(
          onPressed: () => actionList[1].call(),
          icon: const Icon(Icons.edit),
        ),
      ],
    );
  }
}

@immutable
class ExpandableFab extends ConsumerStatefulWidget {
  const ExpandableFab({
    super.key,
    this.initialOpen,
    required this.distance,
    required this.children,
  });

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  ConsumerState<ExpandableFab> createState() => _ExpandableFabState();
}

class _ExpandableFabState extends ConsumerState<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;
  ProviderSubscription? _toggleFabSubscription;

  @override
  void initState() {
    _toggleFabSubscription =
        ref.listenManual<bool>(toggleFabProvider, (previous, next) {
      if (previous != next) {
        _toggle();
      }
    });
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 180,
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56,
      height: 56,
      child: Center(
        child: Material(
          color: AppColor.black,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4,
          child: InkWell(
            onTap: () {
              ref.read(toggleFabProvider.notifier).state =
                  !ref.read(toggleFabProvider);
            },
            child: const Padding(
              padding: EdgeInsets.all(8),
              child: Icon(
                Icons.close,
                color: AppColor.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 0.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance * (i + 1),
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            heroTag: 'Scan-QR',
            onPressed: _toggle,
            shape: const CircleBorder(),
            backgroundColor: AppColor.black,
            child: const Icon(
              Icons.add,
              color: AppColor.white,
            ),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  });

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends ConsumerWidget {
  const ActionButton({
    super.key,
    this.onPressed,
    required this.icon,
  });

  final VoidCallback? onPressed;
  final Widget icon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: AppColor.lightPrimary,
      elevation: 4,
      child: IconButton(
        onPressed: () {
          ref.read(toggleFabProvider.notifier).state =
              !ref.read(toggleFabProvider);
          onPressed?.call();
        },
        icon: icon,
        color: AppColor.white,
      ),
    );
  }
}
