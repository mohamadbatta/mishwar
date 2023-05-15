import 'package:firebase_database/firebase_database.dart';

class Driver {
  String fullName = '';
  String email = '';
  String phone = '';
  String id = '';
  String carModel = '';
  String carColor = '';
  String vehicleNumber = '';

  Driver.fromSnapshot(DatabaseEvent databaseEvent){
    id = databaseEvent.snapshot.key!;
    phone = (databaseEvent.snapshot.value as Map)['phone'].toString();
    email = (databaseEvent.snapshot.value as Map)['email'].toString();
    fullName = (databaseEvent.snapshot.value as Map)['name'].toString();
    carModel =
        (databaseEvent.snapshot.value as Map)['vehicle_details']['car_model']
            .toString();
    carColor =
        (databaseEvent.snapshot.value as Map)['vehicle_details']['car_color']
            .toString();
    vehicleNumber = (databaseEvent.snapshot
        .value as Map)['vehicle_details']['vehicle_number'].toString();
  }

  Driver

      ({

    required

    this

        .
    id

    ,

    required

    this

        .
    phone

    ,

    required

    this

        .
    fullName

    ,

    required

    this

        .
    email

    ,


    required

    this

        .
    carColor

    ,

    required

    this

        .
    carModel

    ,

    required

    this

        .
    vehicleNumber

    ,
  });


}






