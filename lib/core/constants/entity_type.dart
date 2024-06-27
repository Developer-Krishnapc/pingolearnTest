class EntityType {
  //ImageType
  static const String hangerImage = 'Hanger-Image';
  static const String designImage = 'Design-Image';

//ModuleType
  static const String hangerModule = 'Hanger';
  static const String designModule = 'Design';
  static const String collectionModule = 'Collection';
  static const String userModule = 'User';
  static const String enquiryModule = 'Enquiry';

  //access types
  static const String read = 'read';
  static const String create = 'create';
  static const String update = 'update';
  static const String delete = 'delete';

  //User
  static const String getUserById = 'user/{id}';

  //Notification
  static const String updateFirebaseToken = 'fcm/token/save';
  static const String getNotificationList = 'fcm/notification/list';
  static const String getNotificationCount = 'fcm/notification/count';
  // static const String markAsRead = 'operator/readNotification';

  //Enquiry
  static const String enquiryStatus = 'ENQUIRY-STATUS';

  //Roles
  static const String staffRole = 'ROLE_STAFF';
  static const String adminRole = 'ROLE_ADMIN';

  //Validation length for fields

  static const int hangerNameLen = 80;
  static const int collectionNameLen = 80;

  static const int millRefNoLen = 30;
  static const int buyRefConsLen = 30;
  static const int compoLen = 60;
  static const int consLen = 20;
  static const int weightLen = 15;
  static const int countLen = 60;
  static const int widthLen = 15;
}
