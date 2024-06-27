import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/gen/assets.gen.dart';

final navItemsProvider = Provider<List<NavData>>((ref) {
  return [
    NavData(
      label: 'Design',
      inactiveSvg: Assets.svg.home.path,
      activeSvg: Assets.svg.home.path,
    ),
    NavData(
      label: 'Hanger',
      inactiveSvg: Assets.svg.hangerIcon.path,
      activeSvg: Assets.svg.hangerIcon.path,
    ),
    NavData(
      label: 'Enquiry',
      inactiveSvg: Assets.svg.enquiryIcon.path,
      activeSvg: Assets.svg.enquiryIcon.path,
    ),
    NavData(
      label: 'More',
      inactiveSvg: Assets.svg.moreIcon.path,
      activeSvg: Assets.svg.moreIcon.path,
    ),
  ];
});

class NavData {
  NavData({
    required this.activeSvg,
    required this.label,
    required this.inactiveSvg,
  });
  final String activeSvg;
  final String inactiveSvg;
  final String label;
}
