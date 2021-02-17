import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';
import 'package:url_launcher/url_launcher.dart';

class TipPage extends StatefulWidget{
  TipPage({Key key}): super(key:key);
  @override
  State<StatefulWidget> createState() => _TipPage();
}

class _TipPage extends State<TipPage>{

  List<List<dynamic>> data = [];
  var example = List();

  void loadAsset() async {
    final data2 = await rootBundle.loadString('data/Tips.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data2);
    data = csvTable;
    setState(() {
    });
    example.clear();
    for (var i = 1; i< data.length ; i++){
      example.add(data[i]);
    }

    print(example.length);
  }

  Widget expCard(){
    print(example);
    return new Expanded(
      child: new ListView.builder(
        itemCount: example.length,
        itemBuilder: (context, index) {
          return Card(elevation: 5.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0)),
              clipBehavior: Clip.antiAlias,
              margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
              child: IntrinsicHeight(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Padding(padding: EdgeInsets.only(left: 10.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(width:300,
                                    child: Row(children:<Widget> [
                                      Flexible(child: Text(example[index][1].toString(),maxLines: 4,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,height: 1.5, fontFamily: "Vidaloka")))
                                    ])),
                                SizedBox(width:300,
                                    child: Row(children:<Widget> [
                                      Flexible(child: Text(example[index][2].toString(),maxLines: 10,style: TextStyle(fontSize: 13,height: 1.5)))
                                    ])),
                                SizedBox(width:300,
                                    child: Row(children:<Widget> [
                                      Flexible(child: Text(example[index][3].toString(),maxLines: 1,style: TextStyle(fontSize: 13,height: 1.5)))
                                    ])),
                                SizedBox(
                                  width:200,
                                  child: RaisedButton(
                                    textColor: Colors.white,
                                    color: Colors.deepPurple,
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text("Watch This Video"),
                                    onPressed: () async {
                                      var url = example[index][4].toString();

                                      if (await canLaunch(url)) {
                                        await launch(url, forceSafariVC: false);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                  ),
                                ),

                              ]
                          ),
                        ),


                      ]
                  )
              )
          );
        },
      ),
    );
  }


  void initState() {
    super.initState();
    example.clear();
    loadAsset();
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        title: Text("3R Practices Video", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(height: 150, width: 150,
                      child: Image.asset("assets/images/video.jpg",width:140,height:140,alignment: Alignment.centerRight,fit: BoxFit.fill)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text("3R Tips",style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold,fontFamily: "AbrilFatface")),
                    ),
                    SizedBox(width:150,
                        child: Row(children:<Widget> [
                          Flexible(child: Text("Here contains a lot of tutorial videos of practising 3R values in house!",maxLines: 10,style: TextStyle(fontSize: 13,height: 1.5)))
                        ])),

                  ],
                )
              ],
            ),
            ListTile(title: Text('Examples: ', style: TextStyle(fontSize:18),),dense: true),
            expCard(),
          ],
        ),
      ),
    );
  }

}