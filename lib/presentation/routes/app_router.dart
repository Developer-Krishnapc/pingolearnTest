import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/services/remote_config/update_page.dart';
import '../../domain/model/document_model.dart';
import '../auth/login.dart';
import '../auth/registration_page.dart';
import '../design/add_design_page.dart';
import '../design/edit_design_page.dart';
import '../enquiry/add_enquiry_page.dart';
import '../enquiry/enquiry_page.dart';
import '../hanger/add_hanger_page.dart';
import '../hanger/edit_hanger_page.dart';
import '../hanger/hanger_page.dart';
import '../home/home.dart';
import '../internet_connectivity/no_internet_page.dart';
import '../main_page/main_page.dart';
import '../more/more_page.dart';
import '../notifications/notification_page.dart';
import '../printer/printer_page.dart';
import '../profile/edit_profile.dart';
import '../profile/profile_page.dart';

import '../shared/components/pdf_view_page.dart';
import '../splash/image_list_page.dart';
import '../splash/splash.dart';
import '../test_pages/second_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends _$AppRouter {
  AppRouter(this._ref);

  final Ref _ref;
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: SplashRoute.page, initial: true),
        AutoRoute(page: LoginRoute.page),
        AutoRoute(page: NoInternetRoute.page),
        AutoRoute(page: SecondRoute.page),
        AutoRoute(page: UpdateRoute.page),
        AutoRoute(page: AddSampleRoute.page),
        AutoRoute(page: EditDesignRoute.page),
        AutoRoute(page: EnquiryRoute.page),
        AutoRoute(page: AddEnquiryRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: AddHangerRoute.page),
        AutoRoute(page: EditHangerRoute.page),
        AutoRoute(page: AddEnquiryRoute.page),
        AutoRoute(page: NotificationRoute.page),
        AutoRoute(page: EditProfileRoute.page),
        AutoRoute(page: PrinterRoute.page),
        AutoRoute(page: PdfViewRoute.page),
        AutoRoute(page: ImageListRoute.page),
        AutoRoute(page: RegistrationRoute.page),
        AutoRoute(
          page: MainRoute.page,
          children: [
            AutoRoute(
              page: HomeRoute.page,
            ),
            AutoRoute(
              page: HangerRoute.page,
            ),
            AutoRoute(
              page: EnquiryRoute.page,
            ),
            AutoRoute(
              page: MoreRoute.page,
            ),
          ],
        ),
      ];
}
