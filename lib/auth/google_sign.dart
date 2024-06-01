import 'package:envifund_moblie_application/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';

class GoogleSignIn extends StatefulWidget {
  const GoogleSignIn({super.key});

  @override
  State<GoogleSignIn> createState() => _GoogleSignInState();
}

class _GoogleSignInState extends State<GoogleSignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Google Sign In"),
      ),
      body:
      Container(
decoration: BoxDecoration(
  gradient: linearGradient
),

        child: user==null?_googleSignInButton():_userInfo() ,
      )



    );
  }

  Widget _googleSignInButton(){
return  Center(
  child: SizedBox(
    height: 50,
    child: SignInButton(
      Buttons.google, text: "Sign Up With Google",
      onPressed: (){
handleGoogleSignIn();
      },
    ),
  ),
);
  }


  Widget _userInfo(){
    return SizedBox(
width:  MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
Container(
  width: 100,
  height: 100,
  decoration: BoxDecoration(
    image: DecorationImage(image: NetworkImage(user!.photoURL!))
  ),
),
          Text(user!.email!),
          Text(user!.displayName?? "Name")
        ],
      ),
    );
  }

  void handleGoogleSignIn(){
    try{
GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
_auth.signInWithProvider(_googleAuthProvider);
    }catch(error){
      print(error);
    }
  }
}
