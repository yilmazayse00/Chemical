import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'collection_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        home: Scaffold(
          body: CreateCard(),
        )
    );
  }
}

class CreateCard extends StatefulWidget {
  @override
  _CreateCardState createState() => _CreateCardState();
}

class _CreateCardState extends State<CreateCard> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('asitvebazlar')
            .orderBy('name', descending: false)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return buildBody(context, snapshot.data.docs);
          }
        }
    );
  }

  Widget buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
    return ListView(
      children:
      snapshot.map<Widget>((data) => buildListItem(context, data)).toList(),
    );
  }

  buildListItem(BuildContext context, DocumentSnapshot data) {
    final row = GetCard.fromSnapshot(data);
    return Card(
      color: Colors.lightGreen,
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                CollectionPage(
                    passData: row.reference.id),
          ),
        ),
        child: Container(
          height: MediaQuery.of(context).size.height / 4,
          child: Center(
            child: Text(
              row.name,
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontFamily: 'Nunito Regular',
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetCard {
  String name;
  DocumentReference reference;

  GetCard.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map["name"] != null),
        name = map["name"];

  GetCard.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}