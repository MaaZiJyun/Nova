import 'package:flutter_test/flutter_test.dart';
import 'package:nova/src/models/user_model.dart';
import 'package:nova/src/services/user/user_service_impl.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main() {
  RethinkDb r = RethinkDb();
  late Connection connection;
  late UserService sut;

  setUp(() async {
    connection = await r.connect(host: "127.0.0.1", port: 28015);
    await createDb(r, connection);

    sut = UserService(r, connection);
  });

  tearDown(() async {
    await cleanDb(r, connection);
  });

  test('create a new user document in database', () async {
    final user = UserModel(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );
    final userWithId = await sut.connect(user);
    expect(userWithId.id, isNotEmpty);
  });

  test('get online users', () async {
    final user = UserModel(
      username: 'test',
      photoUrl: 'url',
      active: true,
      lastseen: DateTime.now(),
    );
    await sut.connect(user);
    final users = await sut.online();
    print(users.length);
    users.forEach(
      (e) => print(e.toJson()),
    );
    expect(users.length, 1);
  });
}
