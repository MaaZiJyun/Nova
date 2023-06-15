import 'dart:async';

import 'package:nova/src/models/message_model.dart';
import 'package:nova/src/models/user_model.dart';
import 'package:nova/src/services/message/message_service_constract.dart';
import 'package:rethink_db_ns/rethink_db_ns.dart';

class MessageService implements IMessageService {
  final Connection _con;
  final RethinkDb rdb;
  final _controller = StreamController<MessageModel>.broadcast();
  StreamSubscription? _changefeed;

  MessageService(this.rdb, this._con);

  @override
  dispose() {
    _changefeed?.cancel();
    _controller.close();
  }

  @override
  Stream<MessageModel> messages({required UserModel activeUser}) {
    _startReceivingMessages(activeUser);
    return _controller.stream;
  }

  @override
  Future<bool> send(MessageModel msg) async {
    Map record = await rdb.table('messages').insert(msg.toJson()).run(_con);
    return record['inserted'] == 1;
  }

  _startReceivingMessages(UserModel activeUser) {
    _changefeed = rdb
        .table('messages')
        .filter({'to': activeUser.id})
        .changes({'include_initial': true})
        .run(_con)
        .asStream()
        .cast<Feed>()
        .listen((event) {
          event
              .forEach((feedData) {
                if (feedData['new_val'] == null) return;
                final message = _messageFromFeed(feedData);
                _controller.sink.add(message);
                _removeDeliverredMessage(message);
              })
              .catchError((err) => print(err))
              .onError((error, stackTrace) => print(error));
        });
  }

  MessageModel _messageFromFeed(feedData) {
    return MessageModel.fromJson(feedData['new_val']);
  }

  void _removeDeliverredMessage(MessageModel message) {
    rdb
        .table('messages')
        .get(message.id)
        .delete({'return_changes': false}).run(_con);
  }
}
