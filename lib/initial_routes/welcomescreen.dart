import "package:cs310/initial_routes/homepage.dart";
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import "package:flutter/material.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_svg/flutter_svg.dart';
import "package:google_fonts/google_fonts.dart";


class WelcomeScreen extends StatefulWidget {

  const WelcomeScreen({Key key, this.analytics, this.observer}): super(key: key);

  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

  final FirebaseAuth myauth = FirebaseAuth.instance;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String mail;
  String pass;
  bool _success = false;


  void _signInWithEmailAndPassword() async {
    final User user = (await myauth.signInWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    )).user;

    if (user != null) {
      setState(() {
        _success = true;
        mail = user.email;

      });
    } else {
      setState(() {
        print("fail");
        _success = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    if(myauth.currentUser != null)
      {
        return HomePage(documentId: myauth.currentUser.uid, analytics: widget.analytics, observer: widget.observer);
      }
    else
      {


        return SafeArea(
          child: Scaffold(
            body:Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/background5.png"),
                      fit: BoxFit.cover
                  )
              ),
              child: Center(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  width: 300,
                  height: 340,
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("SIGN IN",style: GoogleFonts.ptSans(fontSize: 24),)
                            ],
                          ),
                          Divider(
                            thickness: 1,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 12,),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  style: TextStyle(color:Colors.black),
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                        height: 0
                                    ),
                                    errorBorder:OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    ),
                                    enabledBorder:OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    focusedBorder:OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    prefixIcon: Icon(Icons.email,color: Colors.grey,),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                                    hintText: 'E-mail',
                                    //labelText: 'Username',

                                  ),
                                  keyboardType: TextInputType.emailAddress,

                                  validator: (value) {
                                    if(value.isEmpty) {
                                      return 'Please enter your e-mail';
                                    }
                                    if(!EmailValidator.validate(value)) {
                                      return 'The e-mail address is not valid';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    mail = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  style: TextStyle(color:Colors.black),
                                  decoration: InputDecoration(
                                    errorStyle: TextStyle(
                                      height: 0
                                    ),
                                    errorBorder:OutlineInputBorder(
                                      borderSide: BorderSide.none
                                    ),
                                    enabledBorder:OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide: BorderSide.none
                                    ),
                                    focusedBorder:OutlineInputBorder(
                                      borderSide: const BorderSide(color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(25.0),
                                    ),
                                    prefixIcon: Icon(Icons.vpn_key_sharp, color: Colors.grey,),
                                    fillColor: Colors.white,
                                    filled: true,
                                    hintText: 'Password',
                                    hintStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                                    //labelText: 'Username',

                                  ),
                                  keyboardType: TextInputType.text,
                                  obscureText: true,
                                  enableSuggestions: false,
                                  autocorrect: false,

                                  validator: (value) {
                                    if(value.isEmpty) {
                                      return 'Please enter your password';
                                    }
                                    if(value.length < 8) {
                                      return 'Password must be at least 8 characters';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    pass = value;
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: OutlinedButton(
                                  onPressed: () async {

                                    if(_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(content: Text('Logging in')));


                                      dynamic result = await myauth.signInWithEmailAndPassword(email: mail, password: pass);

                                      if(result == null) {
                                        print('Login failed');
                                      }
                                      else {
                                        print('User logged in');
                                      }


                                    }

                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'LOGIN',
                                      style:  GoogleFonts.poppins(
                                          color: Colors.white,
                                        fontSize: 17
                                      ),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.deepPurple,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8,),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 1,
                                child: OutlinedButton(
                                  onPressed: () {
                                  },

                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                                    child: Text(
                                      'CREATE NEW ACCOUNT',
                                      style: GoogleFonts.poppins(
                                          color: Colors.deepPurple,
                                          fontSize: 17
                                      ),
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: Colors.grey[100]
                                  ),
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
            ),
          ),
        );
      }


  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
