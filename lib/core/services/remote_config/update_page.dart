import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';

import '../../../presentation/shared/providers/app_content.dart';
import '../../../presentation/theme/config/app_color.dart';
import '../../utils/app_utils.dart';

@RoutePage()
class UpdatePage extends ConsumerStatefulWidget {
  const UpdatePage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UpdatePageState();
}

class _UpdatePageState extends ConsumerState<UpdatePage> {
  @override
  Widget build(BuildContext context) {
    final url = ref.read(
      appContentProvider.select((value) => value.updatePageData.lottieUrl),
    );

    final socialMediaDetails =
        ref.read(appContentProvider.select((value) => value.socialMedia));
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 0,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (url.isNotEmpty)
              LottieBuilder.network(
                url,
              ),
            const Gap(20),
            const Text(
              'New Update Available',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Gap(20),
            const Text(
              'To use this app, download the latest version',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const Gap(30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => AppUtils.lauchStore(
                      playStoreAppId: socialMediaDetails.androidId,
                      iosId: socialMediaDetails.iOSAppId,
                    ),
                    style: OutlinedButton.styleFrom(
                      elevation: 0,
                      side: const BorderSide(
                        color: AppColor.primary,
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'More info',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.primary,
                      ),
                    ),
                  ),
                ),
                const Gap(10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => AppUtils.lauchStore(
                      playStoreAppId: socialMediaDetails.androidId,
                      iosId: socialMediaDetails.iOSAppId,
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      backgroundColor: AppColor.primary,
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      'Update',
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColor.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
