import 'package:cs310/initial_routes/homepage.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


final FirebaseAuth _auth = FirebaseAuth.instance;

class LoginScreen extends StatefulWidget {

  const LoginScreen({Key key, this.analytics, this.observer}): super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  @override
  State<StatefulWidget> createState() => LoginScreenState();
}


class LoginScreenState extends State<LoginScreen> {



  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _success;
  String _userEmail;
  String _userID;

  void _signInWithEmailAndPassword() async {
    final User user = (await _auth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.email;
        _userID = user.uid;


      });
    } else {
      setState(() {
        print("fail");
        _success = false;
      });
    }
  }

  Future<void> Analytics_SetCurrentScreen() async{
    await widget.analytics.setCurrentScreen(screenName: "Login Screen", screenClassOverride: "loginscreen");
  }

  @override
  Widget build(BuildContext context) {
    Analytics_SetCurrentScreen();
    return Scaffold(
      appBar: AppBar(
        title: Text("LOGIN"),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: const Text('Test sign in with email and password'),
                padding: const EdgeInsets.all(16),
                alignment: Alignment.center,
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText:  "Email",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration:  InputDecoration(
                  enabledBorder: OutlineInputBorder(

                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  hintText: "Password",
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                alignment: Alignment.center,
                child: RaisedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      await _signInWithEmailAndPassword();

                      //wait to fetch user data then go to homepage..
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) =>
                              HomePage(documentId: _userID, analytics: widget.analytics, observer: widget.observer,),
                      ));
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  _success == null
                      ? ''
                      :
                      'Successfully signed in',
                  style: TextStyle(color: Colors.green),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

}
