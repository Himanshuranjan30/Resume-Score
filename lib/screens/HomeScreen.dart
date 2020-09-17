import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:resumereview/shared/loader.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  File file;
  bool isdocselected = false;
  bool isuploaded=false;
  bool isloading=false;
  String docurl;
  DocumentReference docref;
  final firestoreInstance = Firestore.instance;
  final GlobalKey _LoaderDialog = new GlobalKey();

  Future savePdf() async {
    StorageReference storageReference;
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseUser user = await _auth.currentUser();
    String uid = user.uid.toString();
    print(uid);
    storageReference = FirebaseStorage.instance.ref().child(uid);
    final StorageUploadTask uploadTask = storageReference.putFile(file);
    final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);

    docurl = (await downloadUrl.ref.getDownloadURL());
    await firestoreInstance.collection('Resumes').document(uid).setData(
      {
        'score': 'Scoring under Process...',
        'pdf': docurl.toString(),
        'feedback': 'Feedback under Process,Please hold tight!',
      },
    ).then((result)=>
    setState((){
      isuploaded=true;
    })
    
    );
  }


  Widget build(BuildContext context) {
    return isloading==true?Container(
      height: 50,
      width: 50,
      child: SpinKitSquareCircle(
  color: Colors.blue,
  size: 50.0,
  
),
    ): Scaffold(
      body: Column(
        children: <Widget>[
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
                        'Upload your Resume',
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
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Column(
              children: <Widget>[
                cardWidget(context, 'assets/pdf.png', 'Upload pdf', '*.pdf',
                    '*Size below 1 mb', Colors.green, 'pdf'),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                ),
                cardWidget(context, 'assets/jpg.png', 'Upload Image',
                    '*.jpg/png', '*Size below 0.5mb', Colors.green, 'jpg'),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                ),
                cardWidget(context, 'assets/doc.png', 'Upload Word Document',
                    '*.docx', '*Size below 1 mb', Colors.green, 'doc'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: RaisedButton(
              color: Colors.indigo[700],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 60.0, right: 60.0, top: 15.0, bottom: 15.0),
                child: Text(
                  'Upload',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              onPressed: () async {
                 setState(() {
                   isloading=true;
                 });
                await savePdf();
                setState(() {
                  isloading=false;
                });
                
               AwesomeDialog(
            context: context,
            animType: AnimType.SCALE,
            dialogType: DialogType.SUCCES,
            body: Center(child: Text(
                    'Resume Uploaded',
                    style: TextStyle(fontStyle: FontStyle.italic),
                  ),),
            title: 'Success',
            desc:   '',
            btnOkOnPress: null,
                 )..show();
                
              },
              highlightColor: Colors.blue,
            ),
          ),
          
        ],
      ),
    );
  }

  Widget cardWidget(BuildContext context, String image, String title,
      String subtitle, String desc, Color color, String type) {
    return Material(
      elevation: 2.0,
      borderRadius: BorderRadius.circular(18.0),
      child: Container(
        width: MediaQuery.of(context).size.width - 30.0,
        height: 130.0,
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
                        title,
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
                      subtitle: Text(
                        subtitle,
                        style: TextStyle(color: Colors.grey, fontSize: 12.0),
                      ),
                      trailing: Container(
                        width: 80.0,
                        height: 25.0,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: isdocselected ? Colors.grey : Colors.blue),
                        child: GestureDetector(
                          onTap: () async {
                            file = await FilePicker.getFile(
                              type: FileType.custom,
                              allowedExtensions: [type],
                            );
                            setState(() {
                              if(file!=null)
                                 isdocselected = true;
                            });
                          },
                          child: Center(
                            child: Text(
                              isdocselected ? 'Selected' : 'Select',
                              style: TextStyle(
                                  color: Colors.black, fontSize: 12.0),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 12.0, right: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            desc,
                            style: TextStyle(
                                decoration: TextDecoration.underline,
                                color: color,
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
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
