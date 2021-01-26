
import 'package:cloud_firestore/cloud_firestore.dart';

class UserInfo{
   String name;
   String mobileNumber ;
   String email;
   String password;
   DocumentReference reference;

  UserInfo(this.name, this.mobileNumber, this.email, this.password, this.reference,);

  UserInfo.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map["name"],
        mobileNumber = map["mobileNumber"],
        email = map["email"],
        password = map["password"];


  UserInfo.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  //@override
  //String toString() => "Record<$name:$password>";
}