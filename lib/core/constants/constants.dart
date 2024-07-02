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
    baseUrl: '${const String.fromEnvironment('BASE_URL')}',
  );

  final Flavor flavor;
  final String baseUrl;

  //news
  static const String allNews = 'everything';

  static const String topHeadlines = 'top-headlines';
}
