import 'package:flutter_test/flutter_test.dart';
import 'package:nova/src/models/message_model.dart';
import 'package:nova/src/models/user_model.dart';
import 'package:nova/src/services/message/message_service_impl.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

import 'helpers.dart';

void main() {
  RethinkDb r = RethinkDb();
  late Connection connection;
  late MessageService sut;

  setUp(() async {
    connection = await r.connect(host: '127.0.0.1', port: 28015);
    await createDb(r, connection);

    sut = MessageService(r, connection);
  });

  tearDown(() async {
    // it will clean the data from database
    sut.dispose();
    await cleanDb(r, connection);
  });

  final user = UserModel.fromJson({
    'id': '1234',
    'active': true,
    'last_seen': DateTime.now(),
    'photo_url': 'wawa',
    'username': 'wawa',
  });

  final user2 = UserModel.fromJson({
    'id': '1111',
    'active': true,
    'last_seen': DateTime.now(),
    'photo_url': 'asas',
    'username': 'asas',
  });

  test('sent message successfully', () async {
    MessageModel msg = MessageModel(
      from: user.id!,
      to: '3456',
      timestamp: DateTime.now(),
      content: 'this is a message',
    );

    final res = await sut.send(msg);
    expect(res, true);
  });
}
