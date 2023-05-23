import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:physics_notes/components/subjectCard.dart';
import 'package:physics_notes/constants/colors.dart';
import 'package:physics_notes/functions/goToScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physics_notes/models/subject.dart';
import 'package:physics_notes/screens/addTest.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.adminMode}) : super(key: key);

  final bool adminMode;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final colors = DarkTheme;
  late final bool adminMode = widget.adminMode;

  int settingsLastTap = DateTime.now().millisecondsSinceEpoch;
  int settingsConsecutiveTaps = 0;

  String headerTitle = "";

  @override
  void initState() {
    headerTitle = adminMode ? "Admin Mode" : "Физика";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: GestureDetector(
          onTap: () {
            int now = DateTime.now().millisecondsSinceEpoch;
            if (now - settingsLastTap < 1000) {
              settingsConsecutiveTaps++;
              if (settingsConsecutiveTaps > 4) {
                goToScreenAsReplacement(
                    HomePage(adminMode: !adminMode), context);
              }
            } else {
              settingsConsecutiveTaps = 0;
            }
            settingsLastTap = now;
          },
          child: Text(
            headerTitle,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        actions: adminMode
            ? [
                IconButton(
                    onPressed: _addTest,
                    icon: const Icon(
                      Icons.add_rounded,
                      color: Colors.white,
                    ))
              ]
            : null,
        centerTitle: true,
        backgroundColor: colors.header,
      ),
      backgroundColor: colors.background,
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notes')
            .orderBy("index")
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot doc = snapshot.data!.docs[index];
                  Map docJson = {
                    "name": doc["name"],
                    "images": doc["images"],
                    "docID": doc["docID"]
                  };
                  Subject subject = Subject.fromJson(docJson);
                  return renderSubjectCard(
                      subject.title,
                      subject.images,
                      subject.images.isEmpty ? null : subject.images.first,
                      context,
                      adminMode);
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }

  _addTest() {
    goToScreen(AddTestPage(), context);
  }
}
