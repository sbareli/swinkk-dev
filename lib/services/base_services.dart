import '../models/index.dart';

abstract class BaseServices {
  BaseServices();

  Future<User?>? loginFacebook({String? token}) => null;

  Future<User>? loginSMS({String? token}) => null;

  Future<User?>? loginApple({String? token}) => null;

  Future<User?>? loginGoogle({String? token}) => null;

  Future<User?>? getUserInfo(cookie) => null;

  Future<User?>? login({
    username,
    password,
  }) =>
      null;
}
