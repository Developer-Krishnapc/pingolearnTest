import 'flavor.dart';

class Constants {
  Constants._({
    required this.flavor,
    required this.baseUrl,
  });

  static final Constants instance = Constants._(
    flavor: Flavor.values.firstWhere(
      (element) => element.name == const String.fromEnvironment('FLAVOR'),
    ),
    baseUrl: '${const String.fromEnvironment('BASE_URL')}:8000/api/',
  );

  final Flavor flavor;
  final String baseUrl;

  //Auth
  static const String generateToken = 'auth/generate-token';
  static const String refreshToken = 'auth/refresh-token';

  //User
  static const String getUser = 'user/get-user-from-access-token';
  static const String userList = 'user/';
  static const String getUserById = 'user/{id}';
  static const String createUser = 'user/create';
  static const String updateUserById = 'user/update-user/{userId}';
  static const String updateUserProfileImageById =
      'user/upload-profile-img/{userId}';

  //Roles
  static const String roleList = 'user/roles';

  //Home
  static const String homeStats = 'hangers/stats';

  //Design
  static const String designList = 'samples/list-sample';
  static const String addDesign = 'samples/create-sample';
  static const String updateDesign = 'samples/update-sample/{sampleId}';
  static const String removeDesignImage =
      'samples/remove-sample-image/{sampleId}/{documentId}';
  static const String exportDesign = 'samples/export-sample';
  static const String designById = 'samples/get-sample/{sampleId}';

  static const String deleteDesign = 'samples/delete-sample/{sampleId}';

  //Collection
  static const String updateCollectionStatus =
      'collections/change-status/{collectionId}';
  static const String collectionList = 'collections/list-collection';
  static const String addCollection = 'collections/create-collection';
  static const String updateCollection =
      'collections/update-collection/{collectionId}';
  static const String removeCollectionImage =
      'collections/remove-collection-image/{collectionId}/{documentId}';
  static const String collectionDropdownList =
      'collections/collection-dropdown?is_staff={isStaff}';

  //Hanger
  static const String hangerList = 'hangers/list-hanger';
  static const String exportHanger = 'hangers/export-hanger';
  static const String exportHangerPDF = 'hangers/export-pdf';
  static const String hangerById = 'hangers/get-hanger/{hangerId}';
  static const String addHanger = 'hangers/create-hanger';
  static const String updateHanger = 'hangers/update-hanger/{hangerId}';
  static const String deleteHanger = 'hangers/delete-hanger/{hangerId}';
  static const String hangerDropdownList = 'hangers/hanger-dropdown';
  static const String removeHangerImage =
      'hangers/remove-hanger-image/{hangerId}/{documentId}';

  //Enquiry
  static const String exportEnquiry = 'enquiries/export-enquiry';
  static const String enquiryStats = 'enquiries/enquiry-stats';
  static const String addEnquiry = 'enquiries/create-enquiry';
  static const String enquiryList = 'enquiries/list-enquiry';
  static const String deleteEnquiry = 'enquiries/delete-enquiry/{enquiryId}';
  static const String enquiryItemList =
      'enquiries/list-enquiry-items/{enquiryId}';
  static const String deleteEnquiryItem =
      'enquiries/delete-enquiry-item/{enquiryItemId}';

  static const String updateEnquiryItemStatus =
      'enquiries/update-enquiry-item/{enquiryItemId}';

  static const String addEnquiryItem =
      'enquiries/create-enquiry-item/{enquiryId}';

  static const String updateEnquiryStatus =
      'enquiries/update-enquiry/{enquiryId}';

  //Notification
  static const String updateFirebaseToken = 'fcm-token/save';
  static const String getNotificationList = 'notifications/list-notification';
  static const String getNotificationCount = 'notifications/count-notification';
  static const String updateNotificationRead =
      'notifications/mark-read-notification/{userId}';

  //Predefined
  static const String predefinedList = 'predefined/by-type-and-code';
  // static const String markAsRead = 'operator/readNotification';
}
