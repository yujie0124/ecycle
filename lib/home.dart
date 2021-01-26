import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation/fancy_bottom_navigation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'map.dart';
import 'schedule.dart';
import 'profile.dart';

class Home extends StatefulWidget {
  //UserInfo user;
  Home({Key key}) : super(key: key);

  //final String title;

  @override
  _HomeState createState() => _HomeState();
}


class _HomeState extends State<Home>
{
  void initState() {
    super.initState();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  int currentPage = 0;


  Widget buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        //return buildList(context, snapshot.data.documents);
      },
    );
  }


  List<Widget> options = <Widget>[
    MainPage(),
    FindPage(),
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
                  accountEmail: Text("yujielim08@gmail.com",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white),),
                  accountName: Text("Lim Yu Jie",style: TextStyle(fontWeight:FontWeight.bold,color: Colors.white)),
                  currentAccountPicture: CircleAvatar(
                    child: Text("YJ"),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.home,color: Colors.blueGrey,),
                  title: Text("Home"),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.payment,color: Colors.blueGrey,),
                  title: Text("Bills"),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.account_circle,color: Colors.blueGrey,),
                  title: Text("Profile"),
                  onTap: (){},
                ),
                Divider(),
                ListTile(
                  leading: Icon(Icons.info, color: Colors.blueGrey,),
                  title: Text("About Us"),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.share, color: Colors.blueGrey,),
                  title: Text("Share with Friends"),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.rate_review,color: Colors.blueGrey),
                  title: Text("Rate and Review"),
                  onTap: (){},
                ),
                ListTile(
                  leading: Icon(Icons.flag,color: Colors.blueGrey),
                  title: Text("Privacy Policy"),
                  onTap: (){},
                ),
              ],
            ),
          ),
        ),
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(63.0),
          child: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              title: Text("My   e-Cycle",style: TextStyle(fontFamily: 'Monoton',fontWeight: FontWeight.bold),),
              actions: <Widget>[
                new IconButton(
                  icon: new Icon(Icons.new_releases),
                  onPressed: () {
                    //Navigator.push(context, MaterialPageRoute(builder: (context)=> NewsPage()));
                  },
                ),]
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Hey"),
      ),
    );
}
}
/*



class GetUserName extends StatelessWidget {
  final String documentId;

  GetUserName(this.documentId);

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return FutureBuilder<DocumentSnapshot>(
      future: users.doc(documentId).get(),
      builder:
          (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (snapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data = snapshot.data.data();
          return Text("Full Name: ${data['full_name']} ${data['last_name']}");
        }

        return Text("loading");
      },
    );
  }
}




 */