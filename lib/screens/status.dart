import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumereview/screens/signin.dart';

import 'package:resumereview/services/auth.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class Status extends StatefulWidget {
  @override
  _StatusState createState() => _StatusState();
}

class _StatusState extends State<Status> {
  String uid;
  Future returnuid() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();

    uid = user.uid;
  }

  final AuthService _auth = AuthService();
  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  bool isDocExists = false;
  checkdoc(String id) async {
    DocumentSnapshot docSnapshot =
        await Firestore.instance.collection('Resumes').document(id).get();
    setState(() {
      isDocExists = docSnapshot.exists ? true : false;
    });
  }
// Load from assets

  @override
  Widget build(BuildContext context) {
    returnuid();
    checkdoc(uid);
    return Scaffold(
      body: Center(
        child: Column(children: [
          Column(
            children: [
              Stack(
                children: <Widget>[
                  ClipPath(
                    clipper: BlueClipper(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 600.0,
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: BlackClipper(),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 600.0,
                      decoration: BoxDecoration(
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 80.0,
                    left: 25.0,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            height: 50,
                            width: 50,
                            child: Image.asset('assets/profile.png')),
                        Padding(
                          padding: const EdgeInsets.only(top: 30.0),
                          child: Text(
                            'Resume Status',
                            style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 20.0,
                                fontStyle: FontStyle.italic,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 182.0,
                    left: 314.0,
                    child: Material(
                      elevation: 2.0,
                      borderRadius: BorderRadius.circular(40.0),
                      child: Container(
                        width: 45.0,
                        height: 45.0,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: Colors.black,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.more,
                            color: Colors.white,
                            size: 18.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
          SizedBox(height: 40),
          isDocExists
              ? StreamBuilder(
                  stream: Firestore.instance
                      .collection('Resumes')
                      .document(uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    print(isDocExists);
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    } else {
                      print(snapshot.data['feedback']);
                      print(snapshot.data['pdf']);
                      return Container(
                          child: Column(
                        children: [
                          Image.asset(
                            'assets/pdf.png',
                            height: 50,
                            width: 50,
                          ),
                          SizedBox(height: 3),
                          FlatButton.icon(
                            onPressed: () => _launchURL(snapshot.data['pdf']),
                            icon: Icon(Icons.file_download),
                            label: Text('Show Resume'),
                            color: Colors.blueAccent,
                          ),
                          SizedBox(height: 5),
                          cardWidget(context, 'assets/score.png', 'Score',
                              snapshot.data['score']),
                          SizedBox(height: 8),
                          cardWidget(context, 'assets/feedback.png', 'Feedback',
                              snapshot.data['feedback']),
                          SizedBox(height: 40),
                          FlatButton.icon(
                            onPressed: () => launch(
                                'https://novoresume.com/resume-templates',
                                forceWebView: true),
                            icon: Icon(Icons.show_chart),
                            label: Text(
                                'Check out some Professional Resumes here'),
                            color: Colors.blueAccent,
                          ),
                        ],
                      ));
                    }
                  })
              : Center(
                  child: Column(
                  children: [
                    Image.asset('assets/pdf.png', height: 100),
                    SizedBox(height: 30),
                    Text('No resume uploaded!',
                        style: GoogleFonts.abel(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    Text('Please Upload one to get it reviewed.',
                        style: GoogleFonts.abel(
                            fontSize: 25, fontWeight: FontWeight.bold)),
                    SizedBox(height: 150),
                    Card(
                        child: Column(
                      children: [
                        Text(
                          'Instructions for Uploading a Resume:',
                          style: GoogleFonts.aBeeZee(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '-Upload only 1 resume at a time.',
                          style: GoogleFonts.aBeeZee(),
                        ),
                        Text(
                          '-Change Resume by Uploading the new document again',
                          style: GoogleFonts.aBeeZee(),
                        ),
                        Text(
                          '-Your Resume will be Reviewed within 2 days.',
                          style: GoogleFonts.aBeeZee(),
                        ),
                        Text(
                          '-The Review is automated.',
                          style: GoogleFonts.aBeeZee(),
                        ),
                        Text(
                          '-Crossed reviewed by one of our Career Professionals',
                          style: GoogleFonts.aBeeZee(),
                        ),
                      ],
                    )),
                  ],
                )),
          FlatButton.icon(
              onPressed: () => {
                    
                    _auth.signOutGoogle(),
                     Navigator.of(context, rootNavigator: true).pushReplacement(
            MaterialPageRoute(builder: (context) => SignIn()))
                  },
              icon: Icon(Icons.exit_to_app),
              label: Text('Sign Out and Exit'))
        ]),
      ),
    );
  }
}

class BlueClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2 + 85.0, size.height);

    var firstControlPoint = Offset(size.width / 2 + 140.0, size.height - 105.0);
    var firstEndPoint = Offset(size.width - 1.0, size.height);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class BlackClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0.0, size.height);
    path.lineTo(size.width / 2 - 30.0, size.height);

    var firstControlPoint =
        Offset(size.width / 2 + 175.0, size.height / 2 - 30.0);
    var firstEndPoint = Offset(size.width / 2, 0.0);
    path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
        firstEndPoint.dx, firstEndPoint.dy);

    path.lineTo(size.width / 2 + 75.0, size.height / 2 - 30.0);

    path.lineTo(size.width / 2, 0.0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

Widget cardWidget(
    BuildContext context, String image, String param, String value) {
  return Material(
    elevation: 2.0,
    borderRadius: BorderRadius.circular(18.0),
    child: Container(
      width: MediaQuery.of(context).size.width - 30.0,
      height: 100.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.0),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTile(
                    title: Text(
                      param + ':' + ' ' + value,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0),
                    ),
                    leading: Container(
                      width: 40.0,
                      height: 40.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          border: Border.all(color: Colors.black, width: 1),
                          image: DecorationImage(image: AssetImage(image))),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 5.0,
              height: 45.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
