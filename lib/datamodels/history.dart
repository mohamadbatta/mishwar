import 'package:firebase_database/firebase_database.dart';

class History{
  String pickup='';
  String destination='';
  String fares='';
  String status='';
  String createdAt='';
  String paymentMethod='';

  History({
    required this.pickup,
    required this.destination,
    required this.fares,
    required this.status,
    required this.createdAt,
    required this.paymentMethod,
  });

  History.fromSnapshot(DatabaseEvent databaseEvent){

    pickup=(databaseEvent.snapshot.value as Map)['pickup_address'].toString();
    destination=(databaseEvent.snapshot.value as Map)['destination_address'].toString();
    fares=(databaseEvent.snapshot.value as Map)['fares'].toString();
    createdAt=(databaseEvent.snapshot.value as Map)['created_at'].toString();
    status=(databaseEvent.snapshot.value as Map)['status'].toString();
    paymentMethod=(databaseEvent.snapshot.value as Map)['payment_methode'].toString();

  }

}