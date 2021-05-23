import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310/UserHelper.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {

  const RegisterScreen({Key key, this.analytics, this.observer}): super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}
class RegisterScreenState extends State<RegisterScreen> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  bool _success;
  String _userEmail;
  String _username;

  @override
  void initState() {
    // TODO: implement initState
    _success=null;
    _userEmail = null;
    Analytics_SetCurrentScreen();

    super.initState();
  }


  Future _register() async {

    final User user = (await _auth.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,)).user;


    if (user != null) {
      await user.updateProfile(
          displayName: _username,
          photoURL: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo4-U2alMPHVKZmVnO1THON7H6vUahxP23xw&usqp=CAU"
      );

      await user.reload();
      var Userx = _auth.currentUser;
      setState(() {


        createUser(Userx);

        _success = true;
        _userEmail = Userx.email;
      });

    } else {
      print("fail");

      setState(() {
        _success = false;
      });
    }
  }

  Future<void> Analytics_SetCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "Register Screen", screenClassOverride: "register");
  }


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          title: Text("REGISTER"),
          centerTitle: true,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.deepPurple,
                Colors.red,
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Username",
                      hintStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      )
                    ),

                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      setState(() {
                        _username = value;
                      });
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Email",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20),
                    ),

                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5,),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Password",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 5,),
                  TextFormField(
                    cursorColor: Colors.purple,
                    controller: _passwordController2,
                    obscureText: true,
                    decoration: InputDecoration(

                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      hintText: "Password Again",
                      hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 20),
                    ),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please enter some text';
                      }
                      else if(_passwordController.text != _passwordController2.text)
                      {
                        return "Passwords do not match!";
                      }
                      return null;
                    },
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    alignment: Alignment.center,
                    child: RaisedButton(

                      color: Colors.white,
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          await _register();

                          //wait to fetch user data then go to homepage..


                          Navigator.pushReplacementNamed(context, "/welcomescreen");
                        }
                      },
                      child: const Text('Submit'),
                    ),
                  ),
                  Container(
                    alignment: Alignment.center,
                    child: Text(_success == null
                        ? ''
                        : (_success
                        ? 'Successfully registered ' + _userEmail
                        : 'Registration failed')),
                  )
                ],
              ),

            ),
          ),
        )
    );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}