import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp2/admob_service.dart';
import 'package:quizapp2/helper/constants.dart';
import 'package:quizapp2/models/user.dart';
import 'package:quizapp2/services/auth.dart';
import 'package:quizapp2/widget/widget.dart';

import 'home.dart';

class SignIn extends StatefulWidget {
  final Function toogleView;

  SignIn({this.toogleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  final _scacffoldKey = GlobalKey<ScaffoldState>();
  bool _loading = false;

  TextEditingController emailEditingController = new TextEditingController();
  TextEditingController passwordEditingController = new TextEditingController();

  getInfoAndSignIn() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });
      final res = await _authService.signInEmailAndPass(
          emailEditingController.text, passwordEditingController.text);
      if (res.runtimeType == UserModel) {
        Constants.saveUserLoggedInSharedPreference(true);
        //AdmobService.showInterstitialAd();
        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else {
        setState(() {
          _loading = false;
        });
        var message = "An error has occured, please check your credentials.";
        if (res.message != null) {
          message = res.message;
        }
        _scacffoldKey.currentState.showSnackBar(SnackBar(
            content: Text(
          message,
        )));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.white));
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.indigo,
              Colors.orange,
              Colors.purple,
            ]),
      ),
      child: Scaffold(
        key: _scacffoldKey,
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(child: AppLogo()),
          brightness: Brightness.light,
          centerTitle: true,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          /*flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [Colors.purple, Colors.red]),
            ),
          ),*/
          //brightness: Brightness.li,
        ),
        body: Container(
          /*decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/digitization.jpg"),
              fit: BoxFit.cover,
            ),
          ),*/
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: _loading
              ? Container(
                  child: Center(child: CircularProgressIndicator()),
                )
              : SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height / 1.1,
                    child: Column(
                      children: [
                        Spacer(),
                        Form(
                          key: _formKey,
                          child: Container(
                            child: Column(
                              children: [
                                TextFormField(
                                  validator: (val) => val.isEmpty
                                      ? "Enter your email address"
                                      : null,
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  controller: emailEditingController,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  validator: (val) => val.isEmpty
                                      ? "Enter your password"
                                      : null,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                  ),
                                  controller: passwordEditingController,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    getInfoAndSignIn();
                                  },
                                  child: Container(
                                    alignment: Alignment.center,
                                    width:
                                        MediaQuery.of(context).size.width / 2,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 10),
                                    decoration: BoxDecoration(
                                        gradient: LinearGradient(colors: [
                                          Colors.red,
                                          Colors.orange,
                                          Colors.indigo
                                        ]),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                          fontSize: 16, color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Don\'t have an account? ',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 17)),
                                    GestureDetector(
                                      onTap: () {
                                        widget.toogleView();
                                      },
                                      child: ShaderMask(
                                        blendMode: BlendMode.srcIn,
                                        shaderCallback: (rect) =>
                                            LinearGradient(
                                                begin: Alignment.topLeft,
                                                end: Alignment.bottomRight,
                                                colors: [
                                              Colors.indigoAccent,
                                              Colors.orange
                                            ]).createShader(rect),
                                        child: Text('Sign Up',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                decoration:
                                                    TextDecoration.underline,
                                                fontSize: 17)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
