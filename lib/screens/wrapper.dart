
import 'package:flutter/material.dart';
import 'package:resumereview/provider/user.dart';
import 'package:resumereview/screens/signin.dart';
import 'package:provider/provider.dart';



class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
    // return either the Home or Authenticate widget
        final user = Provider.of<User>(context);
    print(user);
    
    // return either the Home or Authenticate widget
    return SignIn();

  }
}