import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gumby_project/models/vote.dart';

class VoteRepo {
  final CollectionReference votes = Firestore.instance.collection('votes');

  Future<List<Vote>> getVotes() async {
    DateTime today = DateTime.now();
    DateTime oneWeekAgo = today.subtract(Duration(days: 7));
    Query query = votes.where('createdAt',
        isGreaterThanOrEqualTo: oneWeekAgo.millisecondsSinceEpoch);
    return query
        .getDocuments()
        .then((snapshot) => snapshot.documents.map(Vote.fromDoc).toList());
  }

  Future<Vote> castVote(String key, int val) {
    Vote v = Vote(
      sector: key,
      value: val,
      createdAt: DateTime.now(),
    );
    return votes.add({
      'sector': key,
      'value': val,
      'createdAt': DateTime
          .now()
          .millisecondsSinceEpoch,
    }).then((_) => v);
  }
}
