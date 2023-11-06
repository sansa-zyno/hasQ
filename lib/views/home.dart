import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:quizapp2/admob_service.dart';
import 'package:quizapp2/services/database.dart';
import 'package:quizapp2/views/quiz_play.dart';
import 'package:quizapp2/helper/authenticate.dart';
import 'package:quizapp2/widget/widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Stream quizStream;
  DatabaseService databaseService = new DatabaseService();

  Widget quizList() {
    return Container(
        /*decoration: BoxDecoration(
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.bottomLeft,
            end: Alignment.topRight,
            // Add one stop for each color. Stops should increase from 0 to 1
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              Colors.grey.withOpacity(0.8),
              Colors.grey.withOpacity(0.6),
              Colors.grey.withOpacity(0.6),
              Colors.grey.withOpacity(0.4),
              Colors.grey.withOpacity(0.07),
              Colors.grey.withOpacity(0.05),
              Colors.grey.withOpacity(0.025),
            ],
          ),
        ),*/
        height: MediaQuery.of(context).size.height / 1.1,
        child: StreamBuilder(
          stream: quizStream,
          builder: (context, snapshot) {
            return snapshot.data == null
                ? Container()
                : ListView.separated(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      return QuizTile(
                          imageUrl: snapshot.data.docs[index]['quizImgUrl'],
                          title: snapshot.data.docs[index]['quizTitle'],
                          description: snapshot.data.docs[index]['quizDesc'],
                          id: snapshot.data.docs[index].id);
                    },
                    separatorBuilder: (ctx, index) => Divider(
                      thickness: 8,
                    ),
                  );
          },
        ));
  }

  @override
  void initState() {
    super.initState();
    databaseService.getQuizData().then((value) {
      quizStream = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        title: Center(child: AppLogo()),
        brightness: Brightness.light,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                Future.delayed(Duration(seconds: 5), () {
                  final FirebaseAuth _auth = FirebaseAuth.instance;
                  _auth.signOut();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => Authenticate()),
                      (route) => false);
                });
              }),
          SizedBox(width: 10),
        ],
        //brightness: Brightness.li,
      ),
      body: quizList(),
      /*bottomNavigationBar: Container(
        height: 50,
        child: AdWidget(
          key: UniqueKey(),
          ad: AdmobService.createBannerAd()..load(),
        ),
      ),*/
    );
  }
}

class QuizTile extends StatelessWidget {
  final String imageUrl, title, id, description;

  QuizTile({
    @required this.title,
    @required this.imageUrl,
    @required this.description,
    @required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => QuizPlay(id)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(2, 2))
        ]),
        height: 200,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    imageUrl,
                  ),
                  fit: BoxFit.cover,
                ),
              ),
              width: MediaQuery.of(context).size.width - 20,
              //color: Colors.black26,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                          fontSize: 21,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      description,
                      style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "10 Questions",
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
