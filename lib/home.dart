import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'garbage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'map.dart';
import 'schedule.dart';
import 'profile.dart';
import 'tip.dart';



final FirebaseAuth auth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home> {

  var email;
  var username;
  var id;
  FirebaseUser user;

  Future<String> getData() async {
    user = await FirebaseAuth.instance.currentUser();
    final String uid = user.uid.toString();
    id = uid;
    username = user.displayName;
    email = user.email;

  }
  void initState() {
    super.initState();
    getData();
  }

  int currentPage = 0;


  Future<void> _signOut() async {
    await auth.signOut();
  }

  List<Widget> options = <Widget>[
    MainPage(),
    MapSample(),
    SchedulePage(),
    ProfilePage(),
  ];



  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        drawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor: Colors.white,
          ),
          child: Drawer(
            child: ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                UserAccountsDrawerHeader(
                  decoration: BoxDecoration(color: Colors.blueGrey),
                  accountEmail: email!= null ? Text(email,style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),):Text(""),

                  //accountEmail:  buildBody(context),
                  //Text("yujielim08@gmail.com",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),),
                  accountName: username!=null ? Text(username,style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white)):Text(""),
                  currentAccountPicture: CircleAvatar(
                    child: username!=null ? Text(username[0]): Text(""),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.blueGrey,),
                  title: Text("About Us"),
                  onTap: (){
                    showDialog(
                      context: context,
                      builder: (BuildContext context){
                        return new AlertDialog(
                          title: new Text("About Us"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("We are from Multimedia University Malacca Campus. This system is created for the subject Project Business and Management. Hope you will like this application!",
                                  style: TextStyle(fontFamily: "Poppins", fontSize: 15),),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("There are 7 of us in the team, Lim Yu Jie (Leader), Chong You Li (Designer), Luwe Yee Jia (Designer), Ong Yuan Qin (Technical Expert), Wong Cong Zhi (Technical Expert), Kendy Wong (Researcher), Tan Yi Fei(Business Analyst).",
                                  style: TextStyle(fontFamily: "Poppins", fontSize: 13),),
                              ),
                            ],
                          ),
                          actions: <Widget>[
                            FlatButton(
                              child: Text('OK'),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            )
                          ],
                        );
                      }

                    );

                  },
                ),

                ListTile(
                  leading: Icon(Icons.logout,color: Colors.blueGrey),
                  title: Text("Logout"),
                  onTap: (){
                    _signOut();
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> MyApp()));
                  },
                )
              ],
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              title: Text("My e-Cycle",style: TextStyle(fontFamily: 'Vidaloka',fontSize: 25,fontWeight: FontWeight.bold),),

          ),
        ),

        bottomNavigationBar: FancyBottomNavigation(
          activeIconColor: Colors.black,
          inactiveIconColor: Colors.black54,
          textColor: Colors.black,
          barBackgroundColor: Colors.lightBlueAccent,
          tabs: [
            TabData(iconData: Icons.home, title: "Home"),
            TabData(iconData: Icons.location_on, title: "Location"),
            TabData(iconData: Icons.calendar_today, title: "Schedule"),
            TabData(iconData: Icons.account_circle, title: "Profile"),
          ],
          onTabChangedListener: (position) {
            print(position);
            setState(() {
              currentPage = position;
            });
          },
        ),
        body: Center(
            child: options.elementAt(currentPage)
        )
    );
  }

}


class MainPage extends StatefulWidget{
  MainPage({Key key}) : super(key: key);
  @override
  _MainPage createState() => _MainPage();
}

class _MainPage extends State<MainPage>{
  var list1 = ["Residual Waste","Biodegradable kitchen waste", "Recyclable Waste", "Hazardous Waste"];

  void initState() {
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(
          children:<Widget>[
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12.0),
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("GARBAGE CLASSIFICATION", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.grey[600]),),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    color: Colors.indigoAccent,
                    elevation: 10,
                    child: Column(
                      children: [
                          Padding(padding: EdgeInsets.all(8.0),
                            child: new ListTile(
                              leading: Image.asset("assets/images/dry.jpg"),
                              title:Text(list1[0],style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "Poppins",)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Text("Dry Garbage",style: TextStyle(color: Colors.white)),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> GarbagePage(title:"Dry Waste",name:"dry",image: "assets/images/dry.jpg",)));
                              },
                            ),
                          )
                      ],
                    )

                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.indigoAccent,
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0),
                            child: new ListTile(
                              leading: Image.asset("assets/images/wet.jpg"),
                              title:Text(list1[1],style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "Poppins",)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Text("Wet Garbage",style: TextStyle(color: Colors.white)),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> GarbagePage(title:"Wet Waste",name:"wet",image: "assets/images/wet.jpg",)));
                              },
                            ),
                          )
                        ],
                      )

                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.indigoAccent,
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0),
                            child: new ListTile(
                              leading: Image.asset("assets/images/recycle.jpg"),
                              title:Text(list1[2],style: TextStyle(fontSize: 18, color: Colors.white,fontFamily: "Poppins",)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Text("Recyclable Garbage",style: TextStyle(color: Colors.white)),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> GarbagePage(title:"Recyclable Waste",name:"recycle",image: "assets/images/recycle.jpg",)));
                              },
                            ),
                          )
                        ],
                      )

                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.indigoAccent,
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0),
                            child: new ListTile(
                              leading: Image.asset("assets/images/harm.png"),
                              title:Text(list1[3],style: TextStyle(fontSize: 18, fontFamily: "Poppins",color: Colors.white)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Text("Harmful Garbage",style: TextStyle(color: Colors.white)),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> GarbagePage(title:"Hazardous Waste",name:"hazardous",image: "assets/images/harm.png",)));
                              },
                            ),
                          )
                        ],
                      )

                  ),
                  Padding(padding: EdgeInsets.all(18.0)),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(

                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("3R TIPS & PRACTICE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,color: Colors.grey[600]),),
                        ],
                      ),
                    ],
                  ),
                  Padding(padding: EdgeInsets.all(10.0)),
                  Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      color: Colors.deepPurpleAccent,
                      elevation: 10,
                      child: Column(
                        children: [
                          Padding(padding: EdgeInsets.all(8.0),
                            child: new ListTile(
                              leading: Image.asset("assets/images/video.jpg"),
                              title:Text("Recycle Practice in House", style: TextStyle(fontSize: 18, fontFamily: "Poppins",color: Colors.white)),
                              subtitle: Padding(
                                padding: const EdgeInsets.only(top:10.0),
                                child: Text("Get Started From Today!",style: TextStyle(fontSize: 12,color: Colors.white)),
                              ),
                              onTap: () {
                                Navigator.push(context, MaterialPageRoute(builder: (context)=> TipPage()));
                              },
                            ),
                          )
                        ],
                      )
                  ),
                  Padding(padding: EdgeInsets.all(20.0)),

                ],
              ),
            ),
          ]
      )



    );
  }
}
