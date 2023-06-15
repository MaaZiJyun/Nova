import 'package:nova/src/models/user_model.dart';

abstract class IUserService {
  Future<UserModel> connect(UserModel userModel);
  Future<List<UserModel>> online();
  Future<void> disconnect(UserModel userModel);
}
