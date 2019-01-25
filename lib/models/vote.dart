import 'package:meta/meta.dart';

class Vote {

  final String key;
  final DateTime time;
  final int val;

  Vote({
    @required this.key,
    @required this.time,
    @required this.val,
  });

}
