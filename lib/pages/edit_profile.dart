import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image/image.dart' as im;
import 'package:uuid/uuid.dart';

import 'package:cs310/UserHelper.dart';
import 'package:cs310/classes/customUser.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:cs310/pages/profile.dart';
import 'package:cs310/pages/settings.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';



class EditProfile extends StatefulWidget {

  const EditProfile({Key key, this.currentUser}): super(key: key);

  final customUser currentUser;


  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {


  Map<String,dynamic> newData ;


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordController2 = TextEditingController();
  final TextEditingController _bioController = TextEditingController();

  bool showPassword = false;

  File myfile;
  bool uploadingProgress = false;
  String profilePictureID = Uuid().v4();

  String cropString(String source){
    int last_n = source.lastIndexOf("\n");
    if(last_n == -1){
      return source;
    }
    else{
      if(last_n != source.length-1){
        return source;
      }
      else{

        while(last_n == source.length-1){
          print("source is now:   length: " + source.length.toString() + "    last_n: " + last_n.toString());
          print(source);
          source = source.substring(0,source.length-1);
          last_n = source.lastIndexOf("\n");
        }

      }
    }
    return source;
  }


  void showCustomDialog(BuildContext context) => showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(child: Text("Change Profile Picture",style: TextStyle(fontSize: 20),)),
                Divider(thickness: 1,),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        primary: Colors.purple[200]
                    ),
                    child: Text("Capture Photo",style: TextStyle(fontSize: 20,color: Colors.black),),
                    onPressed: TakePhoto

                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.purple[200]
                  ),
                  child: Text("Select From Gallery",style: TextStyle(fontSize: 20,color: Colors.black)),
                  onPressed: ChooseGallery,

                ),
                Divider(height: 8,thickness: 3, color: Colors.black,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.white
                  ),
                  child: Text("Cancel",style: TextStyle(fontSize: 20, color: Colors.black),),
                  onPressed: () => Navigator.pop(context),

                ),


              ],
            ),
          ),
        );
      });


  TakePhoto() async {
    Navigator.pop(context);
    File pickedFile = await ImagePicker.pickImage(
      source: ImageSource.camera,
      maxHeight: 675,
      maxWidth: 960,
    );
    setState(() {
      myfile = pickedFile;
    });

  }

  ChooseGallery() async {
    Navigator.pop(context);
    File chosenFile = await ImagePicker.pickImage(
        source: ImageSource.gallery
    );
    setState(() {
      myfile = chosenFile;
    });

  }



  clearImage() {
    setState(() {
      myfile = null;
    });
  }

  compressImage() async {
    final tempDir = await getTemporaryDirectory();
    final tempPath = tempDir.path;
    im.Image Imagefile = im.decodeImage(myfile.readAsBytesSync());
    final compressedImageFile = File('$tempPath/profilePicture_$profilePictureID.jpg')..writeAsBytesSync(im.encodeJpg(Imagefile, quality: 85));

    setState(() {
      myfile = compressedImageFile;
    });
  }

  Future<String> uploadImage(imageFile) async {

    UploadTask uploadTask = storageRef.child("profilePicture_$profilePictureID.jpg").putFile(imageFile);
    TaskSnapshot storageSnap = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnap.ref.getDownloadURL();

    return downloadUrl;
  }

  SubmitPost() async {
    setState(() {
      uploadingProgress = true;
    });
    await compressImage();

    String mediaUrl = await uploadImage(myfile);

    //now we have mediaURL, we need to change the corresponding info in firestore usersRef
    await usersRef.doc(widget.currentUser.userID).update({
      "photoURL": mediaUrl
    });

    setState(() {
      myfile = null;
      uploadingProgress = false;
    });
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) =>
          HomePage(currentUserID: widget.currentUser.userID),
    ));
  }

  Scaffold buildApprovingScreen(){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: clearImage),
        title: Text(
          "Set Profile Picture",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          FlatButton(
            onPressed: uploadingProgress ? null : () => SubmitPost(),
            child: Container(
              child: Icon(
                Icons.send_rounded,
                size: 35,
              ),
            ),
          )
        ],
      ),
      body: ListView(
        children: <Widget>[
          uploadingProgress ? LinearProgressIndicator() : Text(""),
          Container(
            height: 400.0,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        fit: BoxFit.cover,
                        image: FileImage(myfile),
                      )),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }



  @override
  void initState() {
    newData = {
      "userID": widget.currentUser.userID,
      "username": widget.currentUser.username,
      "email": widget.currentUser.email,
      "photoURL": widget.currentUser.photo_URL,
      "bio": widget.currentUser.bio,
      "followings": widget.currentUser.followings_count,
      "followers": widget.currentUser.followers_count,
      "rate": widget.currentUser.rate,

      "public": widget.currentUser.public,
    };

    _bioController.text = widget.currentUser.bio;
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    return myfile == null ? Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 1,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.deepPurple,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.settings,
              color: Colors.deepPurple,
            ),
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (BuildContext context) => Settings(currentUser: widget.currentUser)));
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
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit Profile",
                      style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                    ),
                  ],
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
                                  widget.currentUser.photo_URL,
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
                              color: Colors.deepPurple,
                            ),
                            child: GestureDetector(
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                              onTap: (){
                                showCustomDialog(context);
                              },
                            ),
                          )),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),




                TextFormField(

                  keyboardType: TextInputType.multiline,
                  maxLines: 10,
                  controller: _bioController,
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
                    if(value.length < 3)
                      return "Bio too short!";
                    else if(value.length > 200)
                      return "Bio too long!";

                    newData["bio"] = cropString(value);

                    return null;
                  },

                ),
                SizedBox(height: 10,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    RaisedButton(
                      onPressed: ()async{
                        if (_formKey.currentState.validate()) {
                          await updateUserById(Uid: widget.currentUser.userID, data:  newData);

                          SnackBar snackbar = SnackBar(
                            content: Text("Successfully Updated!"),);
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);

                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (BuildContext context) =>
                                HomePage(currentUserID: widget.currentUser.userID),
                          ));

                        }
                      },
                      color: Colors.deepPurple,
                      padding: EdgeInsets.symmetric(horizontal: 50),
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      child: Text(
                        "SAVE",
                        style: GoogleFonts.poppins(
                            fontSize: 18,
                            letterSpacing: 2.2,
                            color: Colors.white),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    )
        : buildApprovingScreen();
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
