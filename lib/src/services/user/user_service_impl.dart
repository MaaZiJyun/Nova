import 'package:nova/src/models/user_model.dart';
import 'package:nova/src/services/user/user_service_constract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class UserService implements IUserService {
  final Connection _con;
  final RethinkDb rdb;
  UserService(this.rdb, this._con);
  @override
  Future<UserModel> connect(UserModel userModel) async {
    var record = userModel.toJson();
    if (userModel.id != null) record['id'] = userModel.id;
    final json = await rdb.table('users').insert(record, {
      'conflict': 'update',
      'return_changes': true,
    }).run(_con);

    return UserModel.fromJson(json['changes'].first['new_val']);
  }

  @override
  Future<void> disconnect(UserModel userModel) {
    // TODO: implement disconnect
    throw UnimplementedError();
  }

  @override
  Future<List<UserModel>> online() async {
    Cursor users = await rdb.table('users').filter({'active': true}).run(_con);
    final userList = await users.toList();
    return userList.map((item) => UserModel.fromJson(item)).toList();
  }
}
