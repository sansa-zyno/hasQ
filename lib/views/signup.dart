import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quizapp2/helper/constants.dart';
import 'package:quizapp2/models/user.dart';
import 'package:quizapp2/services/auth.dart';
import 'package:quizapp2/services/database.dart';
import 'package:quizapp2/views/home.dart';
import 'package:quizapp2/widget/widget.dart';

class SignUp extends StatefulWidget {
  final Function toogleView;

  SignUp({this.toogleView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  AuthService authService = new AuthService();
  DatabaseService databaseService = new DatabaseService();
  final _formKey = GlobalKey<FormState>();

  // text feild
  bool _loading = false;
  String email = '', password = '', name = "";

  @override
  Widget build(BuildContext context) {
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
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Center(child: AppLogo()),
          brightness: Brightness.light,
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          //brightness: Brightness.li,
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 24),
          decoration: BoxDecoration(
              /*image: DecorationImage(
              image: AssetImage("assets/digitization.jpg"),
              fit: BoxFit.cover,
            ),*/
              //gradient: LinearGradient(colors: [Colors.purple, Colors.red]),
              ),
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
                                  validator: (val) =>
                                      val.isEmpty ? "Enter a Name" : null,
                                  decoration: InputDecoration(
                                    hintText: "Name",
                                  ),
                                  onChanged: (val) {
                                    name = val;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                TextFormField(
                                  validator: (val) => validateEmail(email)
                                      ? null
                                      : "Enter correct email",
                                  decoration: InputDecoration(
                                    hintText: "Email",
                                  ),
                                  onChanged: (val) {
                                    email = val;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                TextFormField(
                                  obscureText: true,
                                  validator: (val) => val.length < 6
                                      ? "Password must be 6+ characters"
                                      : null,
                                  decoration: InputDecoration(
                                    hintText: "Password",
                                    fillColor: Colors.red,
                                  ),
                                  onChanged: (val) {
                                    password = val;
                                  },
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            getInfoAndSignUp(context);
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width / 2,
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.red,
                                  Colors.orange,
                                  Colors.indigo
                                ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                              "Sign Up",
                              style:
                                  TextStyle(fontSize: 16, color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Already have and account? ',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 17)),
                            GestureDetector(
                              onTap: () {
                                widget.toogleView();
                              },
                              child: ShaderMask(
                                blendMode: BlendMode.srcIn,
                                shaderCallback: (rect) => LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Colors.indigoAccent,
                                      Colors.orange
                                    ]).createShader(rect),
                                child: Text('Sign In',
                                    style: TextStyle(
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                        fontSize: 17)),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }

  getInfoAndSignUp(contex) async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _loading = true;
      });

      final res = await authService.signUpWithEmailAndPassword(email, password);
      if (res.runtimeType == UserModel) {
        Map<String, String> userInfo = {
          "userName": name,
          "email": email,
        };

        databaseService.addUserData(userInfo);

        Constants.saveUserLoggedInSharedPreference(true);

        Navigator.pushAndRemoveUntil(context,
            MaterialPageRoute(builder: (context) => Home()), (route) => false);
      } else {
        setState(() {
          _loading = false;
        });
        if (res == "account-exists-with-different-credential") {
          await showDialog(
              context: contex,
              builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.red[400],
                        )),
                    title: Text("Email already in use"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.red[400]),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
        } else if (res == 'weak-password') {
          await showDialog(
              context: contex,
              builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.red[400],
                        )),
                    title: Text("Weak Password"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.red[400]),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
        } else if (res == 'invalid-email') {
          await showDialog(
              context: contex,
              builder: (ctx) => AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                        side: BorderSide(
                          color: Colors.red[400],
                        )),
                    title: Text("Invalid Email"),
                    actions: <Widget>[
                      FlatButton(
                        child: Text(
                          "OK",
                          style: TextStyle(color: Colors.red[400]),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      )
                    ],
                  ));
        }
      }
    }
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}
