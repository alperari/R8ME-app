import 'package:cs310/initial_routes/homepage.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cs310/UserHelper.dart';
import 'package:google_fonts/google_fonts.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class RegisterScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() => RegisterScreenState();
}
class RegisterScreenState extends State<RegisterScreen> {


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();

  String email;
  String username;
  String pass;
  String pass2;

  String exceptionMessage = "";




  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body:SingleChildScrollView(
          child: Container(
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
                      color: Colors.white.withOpacity(0.3),
                      spreadRadius: 5,
                      blurRadius: 10,
                      offset: Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                width: 300,
                height: 493,
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("SIGN UP",style: GoogleFonts.ptSans(fontSize: 24),)
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
                                  prefixIcon: Icon(Icons.person_pin_rounded,color: Colors.grey,),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                                  hintText: 'Username',
                                  //labelText: 'Username',

                                ),
                                keyboardType: TextInputType.emailAddress,

                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Please enter your username';
                                  }
                                  if(value.length < 3)
                                    return "Must be longer than 4 characters";
                                  return null;
                                },
                                onSaved: (String value) {
                                  username = value;
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
                                  email = value;
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
                                controller: _passwordController,
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
                                  if(value.length < 6) {
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
                                  hintText: 'Password Repeat',
                                  hintStyle: GoogleFonts.poppins(color: Colors.black, fontSize: 18),
                                  //labelText: 'Username',

                                ),
                                keyboardType: TextInputType.text,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,

                                validator: (value) {
                                  if(value.isEmpty) {
                                    return 'Please confirm your password';
                                  }
                                  if(value.length < 6) {
                                    return 'Password must be at least 8 characters';
                                  }
                                  if(_passwordController.text != value)
                                    return "Passwords must match!";
                                  return null;

                                },
                                onSaved: (String value) {
                                  pass2 = value;
                                },
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          child: Text(exceptionMessage, textAlign: TextAlign.center, style: GoogleFonts.fugazOne(fontSize: 16,color: Colors.deepPurple),),

                        ),
                        SizedBox(height: 8,),
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
                                        .showSnackBar(SnackBar(content: Text('SINGING UP...')));


                                    try{

                                      User user = (await _auth.createUserWithEmailAndPassword(
                                        email: email,
                                        password: pass,)).user;

                                      if (user != null) {
                                        await createUserFirestore(user, username);


                                        Navigator.of(context).push(MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              HomePage(currentUserID: user.uid),
                                        ));


                                      }

                                    }catch  (e) {
                                      if(e.code == "email-already-in-use"){
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(content: Text("EMAIL IS ALREADY IN USE!")));
                                        setState(() {
                                          exceptionMessage = "EMAIL IS ALREADY IN USE!";
                                        });
                                      }

                                    }



                                  }

                                },

                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 12.0),
                                  child: Text(
                                    'SIGN ME UP!',
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
                        TextButton(
                            onPressed: (){
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Already have an account? Login ->",
                              style:  GoogleFonts.poppins(
                                color: Colors.grey[700],
                                fontSize: 14
                            ),
                            ))
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
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}