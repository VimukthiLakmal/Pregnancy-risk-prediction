import 'package:cloud_firestore/cloud_firestore.dart';

class Data {
  final DateTime date;
  final String id;
  final String name;
  Data({
    required this.date,
    required this.id,
    required this.name
  });

  factory Data.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot,
      [SnapshotOptions? options]) {
    final data = snapshot.data()!;
    return Data(
      date: data['date'].toDate(),
      id: snapshot.id,
      name:data['name']
    );
  }

  Map<String, Object?> toFirestore() {
    return {
      "date": Timestamp.fromDate(date),
      "name":name
    };
  }
}
