import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

class ProfilePage extends StatefulWidget {
  ProfilePage({Key key}) : super(key: key);

  @override
  _ProfilePage createState() => _ProfilePage();
}

class _ProfilePage extends State<ProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  FirebaseUser currentUser;
  var email;
  var username;
  var phone;
  var address;
  var newAddress;
  var newPhone;
  var newName;
  var docID;
  TextEditingController nc;
  TextEditingController pc;
  TextEditingController ac;
  var refreshkey = GlobalKey<RefreshIndicatorState>();


  Future<QuerySnapshot> getData() async {
    currentUser = await _auth.currentUser();
    if (currentUser != null) {
      await Firestore.instance
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .getDocuments().then((snapshot) {
        {
          if (snapshot.documents != null && snapshot.documents.length > 0) {
            snapshot.documents.forEach(
                  (document) {
                phone = document['phone'];
                email = document['email'];
                address = document['address'];
                username = document['displayName'];
                docID = document.documentID;
                print(docID);
              },
            );
          } else {
            print('No Documents Found');
          }
        }
      });
    }
    nc = new TextEditingController(text: username);
    pc = new TextEditingController(text: phone);
    ac = new TextEditingController(text: address);
  }

  Future<Null> refreshList() async {
    refreshkey.currentState?.show(atTop: true);
    await Future.delayed(Duration(seconds: 2));
    if (!mounted) return;
    setState(() {
      getData();
    });
  }

  void initState() {
    super.initState();
    getData();
    refreshList();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    nc.dispose();
    pc.dispose();
    ac.dispose();
    super.dispose();
  }


  Widget textfield({@required String hintText}){
    return Material(
      elevation: 4,
    shadowColor: Colors.blueAccent[400],
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      readOnly: true,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(
          letterSpacing: 2,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
        fillColor: Colors.white30,
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none
        )
      ),
  ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: refreshList,
        key: refreshkey,
        child: FutureBuilder(
            future: getData(),
            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return new LinearProgressIndicator();
                case ConnectionState.done:
                default:
                  if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                  else {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        CustomPaint(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                          ),
                          painter: HeaderCurverdContainer(),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.all(15),
                              child: Text("Profile",
                                style: TextStyle(
                                  fontSize: 35,
                                  letterSpacing: 1.5,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.all(10.0),
                              width: MediaQuery.of(context).size.width/2,
                              height: MediaQuery.of(context).size.width/2,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.white, width: 5),
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: AssetImage('assets/images/profile.png'),
                                  )
                              ),
                            ),
                          ],

                        ),

                        Padding(padding: EdgeInsets.only(bottom: 250,left: 184),
                          child: CircleAvatar(
                            backgroundColor:Colors.blue[700],
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onPressed: ()
                              {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Stack(
                                          overflow: Overflow.visible,
                                          children: <Widget>[
                                            Positioned(
                                              right: -40.0,
                                              top: -40.0,
                                              child: InkResponse(
                                                onTap: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: CircleAvatar(
                                                  child: Icon(Icons.close),
                                                  backgroundColor: Colors.blueGrey,
                                                ),
                                              ),
                                            ),
                                            Form(
                                              key: _formKey,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: nc,
                                                      onSaved: (String value) => newName,
                                                      decoration: InputDecoration(
                                                        icon: Icon(Icons.drive_file_rename_outline),
                                                        labelText: 'Username',
                                                          labelStyle: TextStyle(color: Colors.black,fontSize: 14)
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: pc,
                                                      onSaved: (String value) => newPhone,
                                                      decoration: InputDecoration(
                                                        icon: Icon(Icons.phone),
                                                        labelText: 'Phone',
                                                          labelStyle: TextStyle(color: Colors.black,fontSize: 14)
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: EdgeInsets.all(8.0),
                                                    child: TextFormField(
                                                      controller: ac,
                                                      onSaved: (String value) => newAddress,
                                                      decoration: InputDecoration(
                                                        icon: Icon(Icons.house),
                                                        labelText: 'Address',
                                                        labelStyle: TextStyle(color: Colors.black,fontSize: 14)
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(top:8.0),
                                                    child: RaisedButton(
                                                      onPressed: ()async{
                                                        newName = nc.text;
                                                        newPhone = pc.text;
                                                        newAddress = ac.text;
                                                            print(newAddress);
                                                            print(newPhone);
                                                            print(newName);
                                                        print('current user: $currentUser');

                                                        if (currentUser != null && this._formKey.currentState.validate()) {
                                                          _formKey.currentState.save(); // Save our form now.

                                                          Firestore.instance.collection("users").document(docID)
                                                              .setData({'address': newAddress, 'displayName': newName, 'email':currentUser.email, 'phone': newPhone});
                                                        }
                                                        Navigator.pop(context);
                                                            },
                                                      color: Colors.blue[800],
                                                      child: Center(
                                                        child: Text("Update",style: TextStyle(
                                                            fontSize: 15,
                                                            color: Colors.white
                                                        ),),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    });
                              },
                            ),
                          ),
                        ),
                         Padding(
                           padding: const EdgeInsets.only(top:250.0),
                           child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                  height: 295,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(horizontal: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      textfield(
                                        hintText: username,
                                      ),

                                      textfield(
                                        hintText: email,
                                      ),

                                      textfield(
                                        hintText: phone,
                                      ),

                                      textfield(
                                        hintText: address,
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: FloatingActionButton(
                                      elevation: 0.0,
                                      child: new Icon(Icons.refresh),
                                      backgroundColor: Colors.indigoAccent,
                                      onPressed: (){refreshList();}),
                                )
                              ],
                            ),
                         ),

                      ],
                    );
                  }
              }
            }
        ),
      )

    );
  }
}

class HeaderCurverdContainer extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint= Paint()..color=Colors.blue[700];
    Path path=Path()
      ..relativeLineTo(0, 150)
      ..quadraticBezierTo(size.width/2, 225, size.width, 150)
      ..relativeLineTo(0, -150)
      ..close();
    canvas.drawPath(path, paint);
  }
  @override
  bool shouldRepaint(CustomPainter oldDelegate)=>false;

}

class User {
  final String name;
  final String email;
  final String phone;
  final String address;

  User(this.name, this.email, this.phone, this.address);
}