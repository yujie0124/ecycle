import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home.dart';

final FirebaseAuth auth = FirebaseAuth.instance;


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My eCycle',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        hintColor: Color(0xFFC0F0E8),
        primaryColor: Color(0xFF81D4FA),
        canvasColor: Colors.transparent,
      ),
      home: new StreamBuilder(
        stream: auth.onAuthStateChanged,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Home();
            //return LoginRegister();

          }
          return LoginRegister();
        },
      ),
      routes: <String, WidgetBuilder>{
        '/home': (BuildContext context) => new Home(),
        '/login': (BuildContext context) => new LoginRegister()
      },
    );
  }
}


class LoginRegister extends StatefulWidget {
  //UserInfo user;
  LoginRegister({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  PersistentBottomSheetController _sheetController;
  String _email;
  String _password;
  String _displayName;
  bool _loading = false;
  bool _autoValidate = false;
  String errorMsg = "";

  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Color primaryColor = Theme.of(context).primaryColor;

    //GO logo widget
    Widget logo() {
      return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 230,
          child: Stack(
            children: <Widget>[
              Positioned(
                  child: Container(
                    child: Align(
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white),
                        width: 150,
                        height: 150,
                      ),
                    ),
                    height: 154,
                  )),
              Positioned(
                child: Container(
                    child: Align(
                      child: Container(
                        child: Image.asset('assets/images/25164.png'),
                        width: 110,
                        height: 110,
                      ),
                      alignment: Alignment.center,
                    ),
                  height: 140,
                ),
              ),

              Positioned(
                width: MediaQuery.of(context).size.width * 0.15,
                height: MediaQuery.of(context).size.width * 0.15,
                bottom: MediaQuery.of(context).size.height * 0.046,
                right: MediaQuery.of(context).size.width * 0.22,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              ),
              Positioned(
                width: MediaQuery.of(context).size.width * 0.08,
                height: MediaQuery.of(context).size.width * 0.08,
                bottom: 0,
                right: MediaQuery.of(context).size.width * 0.32,
                child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                ),
              )
            ],
          ),
        ),
      );
    }

    Future<void> resetPassword(String email) async {
      await auth.sendPasswordResetEmail(email: email);
    }

    //button widgets
    Widget filledButton(String text, Color splashColor, Color highlightColor,
        Color fillColor, Color textColor, void function()) {
      return RaisedButton(
        highlightElevation: 1.0,
        splashColor: splashColor,
        highlightColor: highlightColor,
        elevation: 3.0,
        color: fillColor,
        shape: RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(30.0)),
        child: Text(
          text,
          style: TextStyle(
              fontFamily: 'Vidaloka',fontWeight: FontWeight.bold, color: textColor, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }

    outlineButton(void function()) {
      return RaisedButton(
        elevation: 3.0,
        //highlightedBorderColor: Colors.white,
        //borderSide: BorderSide(color: Colors.white, width: 2.0),
        highlightElevation: 1.0,
        splashColor: Colors.white,
        highlightColor: Theme.of(context).primaryColor,
        color: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          side: new BorderSide(color: Theme.of(context).primaryColor,width: 2.0),
          borderRadius: new BorderRadius.circular(30.0),
        ),
        child: Text(
          "REGISTER",
          style: TextStyle(
              fontFamily: 'Vidaloka',fontWeight: FontWeight.bold, color: Colors.white, fontSize: 20),
        ),
        onPressed: () {
          function();
        },
      );
    }


    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> LoginRegister()));
      },
    );


    void _validateLoginInput() async {
      final FormState form = _formKey.currentState;
      if (_formKey.currentState.validate()) {
        form.save();
        _sheetController.setState(() {
          _loading = true;
        });
        try {
          FirebaseUser user = await FirebaseAuth.instance
              .signInWithEmailAndPassword(email: _email, password: _password);
          if (user.isEmailVerified){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> Home()));
          }
          else{
            _sheetController.setState(() {
              _loading = false;
            });
            try {
              user.sendEmailVerification();
              user.reload();
              showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Verification of email"),
                  content: Text("You have not verified with this email address. A verification email will be sent to this email address. Please verify it. After verifying, please login again. Thank you!"),
                  actions: [
                    okButton,
                  ],
                );
              });

            } catch (e) {
              print("An error occured while trying to send email verification");
              print(e.message);
            }


          }

        } catch (error) {
          switch (error.code) {
            case "ERROR_USER_NOT_FOUND":
              {
                _sheetController.setState(() {
                  errorMsg =
                  "There is no user with such entries. Please try again.";

                  _loading = false;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          child: Text(errorMsg),
                        ),
                      );
                    });
              }
              break;
            case "ERROR_WRONG_PASSWORD":
              {
                _sheetController.setState(() {
                  errorMsg = "Password doesn\'t match your email.";
                  _loading = false;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          child: Text(errorMsg),
                        ),
                      );
                    });
              }
              break;
            default:
              {
                _sheetController.setState(() {
                  errorMsg = "";
                });
              }
          }
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    void _validateRegisterInput() async {
      final FormState form = _formKey.currentState;
      if (_formKey.currentState.validate()) {
        form.save();
        _sheetController.setState(() {
          _loading = true;
        });
        try {
          FirebaseUser user = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
              // ignore: missing_return
              email: _email, password: _password).then((user) {
                user.sendEmailVerification();
                user.reload();
                _sheetController.setState(() {
                  _loading = false;
                });

                  UserUpdateInfo userUpdateInfo = new UserUpdateInfo();
                  userUpdateInfo.displayName = _displayName;
                  user.updateProfile(userUpdateInfo).then((onValue) {
                    //Navigator.of(context).pushReplacementNamed('/home');
                    Firestore.instance.collection('users').document().setData(
                        {'email': _email, 'displayName': _displayName,'password':_password}).then((onValue) {
                      _sheetController.setState(()
                      {
                        _loading = false;
                      });
                    });
                  });

          });

          showDialog(context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Verification of email"),
                  content: Text("A verification email will be sent to this email address. Please verify it and login. Thank you!"),
                  actions: [
                    okButton,
                  ],
                );
              });

        } catch (error) {
          switch (error.code) {
            case "ERROR_EMAIL_ALREADY_IN_USE":
              {
                _sheetController.setState(() {
                  errorMsg = "This email is already in use.";
                  _loading = false;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          child: Text(errorMsg),
                        ),
                      );
                    });
              }
              break;
            case "ERROR_WEAK_PASSWORD":
              {
                _sheetController.setState(() {
                  errorMsg = "The password must be 6 characters long or more.";
                  _loading = false;
                });
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        content: Container(
                          child: Text(errorMsg),
                        ),
                      );
                    });
              }
              break;
            default:
              {
                _sheetController.setState(() {
                  errorMsg = "";
                });
              }
          }
        }
      } else {
        setState(() {
          _autoValidate = true;
        });
      }
    }

    String emailValidator(String value) {
      Pattern pattern =
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
      RegExp regex = new RegExp(pattern);
      if (value.isEmpty) return '*Required';
      if (!regex.hasMatch(value))
        return '*Enter a valid email';
      else
        return null;
    }


    void loginSheet() {
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                      child: Form(
                        key: _formKey,
                        autovalidate: _autoValidate,
                        child: Column(
                          children: <Widget>[
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: 140,
                              child: Stack(
                                children: <Widget>[
                                  Positioned(
                                    child: Align(
                                      child: Container(
                                        width: 130,
                                        height: 130,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Theme.of(context).primaryColor),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                  Positioned(
                                    child: Container(
                                      child: Text(
                                        "LOGIN",
                                        style: TextStyle(
                                          fontFamily: 'Audiowide',
                                          fontSize: 38,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      alignment: Alignment.center,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20, top: 60),
                                child: CustomTextField(
                                  onSaved: (input) {
                                    _email = input;
                                  },
                                  validator: emailValidator,
                                  icon: Icon(Icons.email),
                                  hint: "EMAIL",
                                )),
                            Padding(
                                padding: EdgeInsets.only(bottom: 20),
                                child: CustomTextField(
                                  icon: Icon(Icons.lock),
                                  obsecure: true,
                                  onSaved: (input) => _password = input,
                                  validator: (input) =>
                                  input.isEmpty ? "*Required" : null,
                                  hint: "PASSWORD",
                                )),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: 20,
                                  right: 20,
                                  bottom: MediaQuery.of(context).viewInsets.bottom),
                              child: _loading == true
                                  ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryColor),
                              )
                                  : Container(
                                child: filledButton(
                                    "LOGIN",
                                    Colors.white,
                                    primaryColor,
                                    primaryColor,
                                    Colors.white,
                                    _validateLoginInput),
                                height: 50,
                                width: MediaQuery.of(context).size.width,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    void registerSheet() {
      _sheetController = _scaffoldKey.currentState
          .showBottomSheet<void>((BuildContext context) {
        return DecoratedBox(
          decoration: BoxDecoration(color: Theme.of(context).canvasColor),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40.0),
                topRight: Radius.circular(40.0)),
            child: Container(
              child: ListView(
                children: <Widget>[
                  Container(
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          left: 10,
                          top: 10,
                          child: IconButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            icon: Icon(
                              Icons.close,
                              size: 30.0,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    height: 50,
                    width: 50,
                  ),
                  SingleChildScrollView(
                      child: Form(
                        child: Column(children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 140,
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  child: Align(
                                    child: Container(
                                      width: 130,
                                      height: 130,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Theme.of(context).primaryColor),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Positioned(
                                  child: Container(
                                    padding: EdgeInsets.only(bottom: 25, right: 40),
                                    child: Text(
                                      "REGI",
                                      style: TextStyle(
                                        fontFamily: 'Audiowide',
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                                Positioned(
                                  child: Align(
                                    child: Container(
                                      padding: EdgeInsets.only(top: 40, left: 28),
                                      width: 130,
                                      child: Text(
                                        "STER",
                                        style: TextStyle(
                                          fontFamily: 'Audiowide',
                                          fontSize: 31,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    alignment: Alignment.center,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                                top: 60,
                              ),
                              child: CustomTextField(
                                icon: Icon(Icons.account_circle),
                                hint: "USERNAME",
                                validator: (input) =>
                                input.isEmpty ? "*Required" : null,
                                onSaved: (input) => _displayName = input,
                              )),
                          Padding(
                              padding: EdgeInsets.only(
                                bottom: 20,
                              ),
                              child: CustomTextField(
                                icon: Icon(Icons.email),
                                hint: "EMAIL",
                                onSaved: (input) {
                                  _email = input;
                                },
                                validator: emailValidator,
                              )),
                          Padding(
                              padding: EdgeInsets.only(bottom: 20),
                              child: CustomTextField(
                                icon: Icon(Icons.lock),
                                obsecure: true,
                                onSaved: (input) => _password = input,
                                validator: (input) =>
                                input.isEmpty ? "*Required" : null,
                                hint: "PASSWORD",
                              )),
                          Padding(
                            padding: EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: _loading
                                ? CircularProgressIndicator(
                              valueColor: new AlwaysStoppedAnimation<Color>(
                                  primaryColor),
                            )
                                : Container(
                              child: filledButton(
                                  "REGISTER",
                                  Colors.white,
                                  primaryColor,
                                  primaryColor,
                                  Colors.white,
                                  _validateRegisterInput),
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                        ]),
                        key: _formKey,
                        autovalidate: _autoValidate,
                      )),
                ],
              ),
              height: MediaQuery.of(context).size.height / 1.1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white,
            ),
          ),
        );
      });
    }

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        key: _scaffoldKey,
        backgroundColor: Theme.of(context).primaryColor,
        body: Column(
          children: <Widget>[
            logo(),
            Container(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: Text(
                      "MY E-CYCLE",
                      style: TextStyle(
                        fontFamily: 'AbrilFatface',
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ),
            Padding(
              child: Container(
                child: filledButton("LOGIN", primaryColor, Colors.white,
                    Colors.white, primaryColor, loginSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.05,
                  left: 20,
                  right: 20,
                  bottom: 10
              ),
            ),
            Padding(
              child: Container(
                child: outlineButton(registerSheet),
                height: 50,
              ),
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
            ),
            Expanded(
              child: Align(
                child: ClipPath(
                  child: Container(
                    color: Colors.white,
                    height: 300,
                  ),
                  clipper: BottomWaveClipper(),
                ),
                alignment: Alignment.bottomCenter,
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.stretch,
        ));
  }
}



class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.icon,
        this.hint,
        this.obsecure = false,
        this.validator,
        this.onSaved});
  final FormFieldSetter<String> onSaved;
  final Icon icon;
  final String hint;
  final bool obsecure;
  final FormFieldValidator<String> validator;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 20),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        autofocus: true,
        obscureText: obsecure,
        style: TextStyle(
          fontSize: 20,
        ),
        decoration: InputDecoration(
            hintStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 18,color: Colors.lightBlueAccent),
            hintText: hint,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 2,
              ),
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: BorderSide(
                color: Theme.of(context).primaryColor,
                width: 3,
              ),
            ),
            prefixIcon: Padding(
              child: IconTheme(
                data: IconThemeData(color: Theme.of(context).primaryColor),
                child: icon,
              ),
              padding: EdgeInsets.only(left: 30, right: 10),
            )),
      ),
    );
  }
}

class BottomWaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.moveTo(size.width, 0.0);
    path.lineTo(size.width, size.height);
    path.lineTo(0.0, size.height);
    path.lineTo(0.0, size.height + 5);
    var secondControlPoint = Offset(size.width - (size.width / 6), size.height);
    var secondEndPoint = Offset(size.width, 0.0);
    path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
        secondEndPoint.dx, secondEndPoint.dy);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}


