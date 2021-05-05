import 'package:cs310/UserHelper.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/pages/settings.dart';
import 'package:flutter/material.dart';
import "package:cs310/initial_routes/homepage.dart";


class EditProfile extends StatefulWidget {

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  Map<String,dynamic> newData = {
    "userID": currentUser.userID,
    "username": currentUser.username,
    "email": currentUser.email,
    "photoURL": currentUser.photo_URL,
    "bio": currentUser.bio,
    "followings": currentUser.followings_count,
    "followers": currentUser.followers_count,
    "rate": currentUser.rate,
  };

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool showPassword = false;




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.green,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings()));
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Edit Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                          border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor),
                          boxShadow: [
                            BoxShadow(
                                spreadRadius: 2,
                                blurRadius: 10,
                                color: Colors.black.withOpacity(0.1),
                                offset: Offset(0, 10))
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRo4-U2alMPHVKZmVnO1THON7H6vUahxP23xw&usqp=CAU",
                              ))),
                    ),
                    Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.greenAccent,
                          ),
                          child: Icon(
                            Icons.edit,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),




              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "New Username",
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    )
                ),

                validator: (String value) {

                  print(5);

                  if (value.isEmpty) {
                    newData["username"] = currentUser.username;
                    print(1);
                  }
                  //_username = value;
                  //CHANGE USERNAME IN THE DATABASE

                    newData["username"] = value.toString();
                    print(2);


                  return null;
                },
              ),
              SizedBox(height: 10,),

              /*
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "New Password",
                  hintStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 20),
                ),
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10,),
              TextFormField(
                cursorColor: Colors.purple,
                controller: _passwordController2,
                obscureText: true,
                decoration: InputDecoration(

                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  labelText: "New Password Again",
                  hintStyle: TextStyle(
                      color: Colors.black,
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
              SizedBox(height: 15,),
              TextFormField(
                controller: _usernameController,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    labelText: "New Bio",
                    hintStyle: TextStyle(
                        color: Colors.black,
                        fontSize: 15
                    )
                ),

                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  setState(() {
                    //_username = value;
                  });
                  return null;
                },
              ),
              SizedBox(
                height: 15,
              ),
              */
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  RaisedButton(
                    onPressed:  (){
                      updateUserById(Uid: currentUser.userID, data: newData);
                      print(3);
                    },
                    color: Colors.greenAccent,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Text(
                      "SAVE",
                      style: TextStyle(
                          fontSize: 14,
                          letterSpacing: 2.2,
                          color: Colors.black),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    _passwordController.dispose();
    _passwordController2.dispose();
    _usernameController.dispose();
    super.dispose();
  }
}