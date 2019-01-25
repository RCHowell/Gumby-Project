import 'dart:math';

import 'package:gumby_project/models/vote.dart';

class VoteRepo {

  List<Vote> getVotes() {

    List<String> keys = ["A","B","C","D","E","F","G","H"];
    DateTime today = DateTime.now();
    DateTime oneWeekAgo = today.subtract(Duration(days: 7));
    Random random = Random();
    List<Vote> votes = List();

    // Generate 50 random data points
    for (int i = 0; i < 50; i++) {
      votes.add(Vote(
        key: keys[random.nextInt(keys.length)],
        val: (random.nextBool()) ? 1 : -1,
        time: today.subtract(Duration(days: random.nextInt(9))),
      ));
    }

    // Only return votes from the past week
    return votes.where((Vote v) => v.time.compareTo(oneWeekAgo) >= 0).toList();
  }

  Future<String> castVote(String key, int val) {
    return Future.delayed(Duration(milliseconds: 500), () {
      String type = (val == 1) ? "keep" : "reset";
      return  'You voted to $type sector $key';
    });
  }

}
