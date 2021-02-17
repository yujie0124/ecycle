import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:csv/csv.dart';


class GarbagePage extends StatefulWidget{
  var title;
  var name;
  var image;
  GarbagePage({Key key,@required this.title, @required this.name,@required this.image}): super(key:key);
  @override
  State<StatefulWidget> createState() => _GarbagePage();
}

class _GarbagePage extends State<GarbagePage>{
  List<List<dynamic>> data = [];
  var example = List();
  var desc;



  void loadAsset(name) async {
    final data2 = await rootBundle.loadString('data/dry.csv');
    List<List<dynamic>> csvTable = CsvToListConverter().convert(data2);
    data = csvTable;
    setState(() {
    });
    example.clear();
    for (var i = 1; i< data.length ; i++){
      if(name == data[i][0]){
        example.add(data[i]);
      }
    }
    print(example.length);
  }

  Widget expCard(name){
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
                                SizedBox(width:150,
                                    child: Row(children:<Widget> [
                                      Flexible(child: Text(example[index][1].toString(),maxLines: 4,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16,height: 1.5,fontFamily: "Vidaloka")))
                                    ])),

                              ]
                          ),
                        ),

                        Padding(
                          padding: EdgeInsets.only(
                            top: 1.0, left: 8.0, right: 3.0, bottom: 1.0),
                          child: SizedBox(height: 110, width: 140,
                              child: Image.network(
                                  example[index][2].toString(), width: 140,
                                  height: 110,
                                  alignment: Alignment.centerRight,
                                  fit: BoxFit.fill)
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
  @override
  void initState() {
    super.initState();
    example.clear();
    loadAsset(widget.name);

    if(widget.name == "dry"){
      desc = "Dry materials such as timber offcuts, sawdust, textiles and plastics can be processed into "
          "alternative fuels that replace fossil fuels in industrial furnaces.";
    }
    else if(widget.name == "wet")
    {
        desc = "Biodegradable kitchen waste like fruit or vegetable peels, tea leaves, coffee powder, egg shells, "
            "meat and bones, food scraps, also leaves and flowers. Can be composted.";
    }
    else if(widget.name == "recycle")
    {
      desc = "Recycling, recovery and reprocessing of waste materials for use in new products. The basic phases in recycling are the collection of waste materials, "
          "their processing or manufacture into new products, and the purchase of those products, which may then themselves be recycled.";
    }
    else{
      desc = "Hazardous wastes are those that may contain toxic substances generated from industrial, hospital, some types of household wastes. "
          "These wastes could be corrosive, inflammable, explosive, or react when exposed to other materials.";
    }

  }


  @override
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.title, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.indigoAccent,
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
                      child: Image.asset(widget.image,width:140,height:140,alignment: Alignment.centerRight,fit: BoxFit.fill)),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(widget.title,style: TextStyle(fontSize: 19,fontWeight: FontWeight.bold, fontFamily: "AbrilFatface")),
                    ),
                    SizedBox(width:150,
                        child: Row(children:<Widget> [
                          Flexible(child: Text(desc,maxLines: 10,style: TextStyle(fontSize: 13,height: 1.5)))
                        ])),

                  ],
                )
              ],
            ),
            ListTile(title: Text('Examples: ', style: TextStyle(fontSize:18),),dense: true),
            expCard(widget.name),
          ],
        ),
      ),
    );
  }
}
