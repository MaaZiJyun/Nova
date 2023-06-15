import 'package:nova/src/models/message_model.dart';
import 'package:nova/src/models/user_model.dart';

abstract class IMessageService {
  Future<bool> send(MessageModel msg);
  Stream<MessageModel> messages({required UserModel activeUser});
  dispose();
}
