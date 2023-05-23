import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:physics_notes/components/subjectCard.dart';
import 'package:physics_notes/constants/colors.dart';
import 'package:physics_notes/functions/goToScreen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:physics_notes/models/subject.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final colors = DarkTheme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          "Физика",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
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
                  Map docJson = {"name": doc["name"], "images": doc["images"]};
                  Subject subject = Subject.fromJson(docJson);
                  return renderSubjectCard(subject.title, subject.images,
                      subject.images.first, context);
                });
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
