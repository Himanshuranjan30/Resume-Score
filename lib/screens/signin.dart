import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:resumereview/services/auth.dart';
import 'package:resumereview/services/delayed_animation.dart';
import 'package:avatar_glow/avatar_glow.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> with SingleTickerProviderStateMixin {
  final AuthService _auth = AuthService();
  final int delayedAmount = 500;
  double _scale;
  AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 200,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  handleLogin() async {
    FirebaseUser user = await _auth.signInWithGoogle();
    Navigator.of(context).pushNamed('/dashboard');
  }

  bool isauth = false;
  @override
  Widget build(BuildContext context) {
    final color = Colors.white;
    _scale = 1 - _controller.value;
    return Scaffold(
        backgroundColor: Colors.blueAccent,
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 40),
              AvatarGlow(
                endRadius: 90,
                duration: Duration(seconds: 2),
                glowColor: Colors.white24,
                repeat: true,
                repeatPauseDuration: Duration(seconds: 2),
                startDelay: Duration(seconds: 1),
                child: Material(
                    elevation: 8.0,
                    shape: CircleBorder(),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey[100],
                      child: FlutterLogo(
                        size: 50.0,
                      ),
                      radius: 50.0,
                    )),
              ),
              DelayedAnimation(
                child: Text(
                  "Hi There",
                  style: GoogleFonts.abel(fontSize: 35,fontWeight:FontWeight.bold,color: Colors.white)
                ),
                delay: delayedAmount + 100,
              ),
              DelayedAnimation(
                child: Text(
                  "I'm Resume Reviewer",
                  style: GoogleFonts.abel(fontSize: 35,fontWeight:FontWeight.bold,color: Colors.white),
                ),
                delay: delayedAmount + 200,
              ),
              SizedBox(
                height: 30.0,
              ),
              DelayedAnimation(
                child: Text(
                  "Your New Personal",
                  style: GoogleFonts.abel(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.white),
                ),
                delay: delayedAmount + 300,
              ),
              DelayedAnimation(
                child: Text(
                  "Career Companion",
                  style: GoogleFonts.abel(fontSize: 20,fontWeight:FontWeight.bold,color: Colors.white),
                ),
                delay: delayedAmount + 300,
              ),
              SizedBox(
                height: 100.0,
              ),
              DelayedAnimation(
                child: GestureDetector(
                  onTapDown: _onTapDown,
                  onTapUp: _onTapUp,
                  child: Transform.scale(
                    scale: _scale,
                    child: _animatedButtonUI,
                  ),
                ),
                delay: delayedAmount + 4000,
              ),
              SizedBox(
                height: 50.0,
              ),
            ],
          ),
        ));
  }

  Widget get _animatedButtonUI => Column(children:[
    Text('Login',style:TextStyle(fontStyle:FontStyle.normal,fontWeight: FontWeight.bold,color: Colors.white)),
    SizedBox(height:20)
    ,GestureDetector(child: Image.asset('assets/google.jpg',height: 50,width: 50,),onTap:()=> handleLogin(),)]);

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  void _onTapUp(TapUpDetails details) {
    _controller.reverse();
  }
}
