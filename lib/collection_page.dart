import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_card/flip_card.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp());

class CollectionPage extends StatelessWidget {
  String passData;
  CollectionPage({Key key, @required this.passData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2,
        title: Text(
          passData,
          style: TextStyle(
              fontFamily: 'Nunito Regular',
              fontSize: 23.0
          ),
        ),
        leading: BackButton(
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: MyHomePage(passData: passData),
    );
  }
}

class MyHomePage extends StatefulWidget {
  String passData;
  MyHomePage({Key key, @required this.passData}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(passData);
}

class _MyHomePageState extends State<MyHomePage> {
  String passData;
  _MyHomePageState(this.passData);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance.collection(passData).orderBy('front',descending: false).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildBody(context, snapshot.data.docs);
          }
        });
  }

  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          return GridView.count(
            shrinkWrap: true,
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            children: List.generate(
              snapshot.length,
                  (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: FlipCard(
                  direction: FlipDirection.HORIZONTAL,
                  front: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.lightBlueAccent,
                    ),
                    child: Center(
                      child: Text(
                        GetGrid.fromSnapshot(snapshot[index]).front,
                        style: TextStyle(
                          fontSize: 25.0,
                          color: Colors.white,
                          fontFamily: 'Nunito Regular',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  back: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.amberAccent,
                    ),
                    child: Center(
                      child: Text(
                        GetGrid.fromSnapshot(snapshot[index]).back,
                        style: TextStyle(
                          fontSize: 30.0,
                          fontFamily: 'Nunito Regular',
                        ),
                      ),
                    ),
                  ),
                ),

              ),
            ),
          );
        });
  }
}

class GetGrid {
  String back;
  String front;
  DocumentReference reference;

  GetGrid.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["back"] != null),
        assert(map["front"] != null),
        front = map["front"],
        back = map["back"];

  GetGrid.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}