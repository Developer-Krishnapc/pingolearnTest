import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/model/token.dart';

part 'token_provider.g.dart';

@Riverpod(keepAlive: true)
class TokenNotifier extends _$TokenNotifier {
  @override
  Token build() {
    return const Token();
  }

  // Future<void> updateToken(Token token) async {
  //   await ref.read(sharedPrefProvider).saveToken(token);
  //   state = token;
  // }
}
