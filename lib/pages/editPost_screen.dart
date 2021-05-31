import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cs310/initial_routes/homepage.dart';
import 'package:flutter/material.dart';
import "package:cs310/classes/customUser.dart";
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class EditPost extends StatefulWidget {

  final customUser currentUser;
  final Map<String,String> data;

  EditPost({this.currentUser,this.data});

  @override
  _EditPostState createState() => _EditPostState();
}

class _EditPostState extends State<EditPost>{


  TextEditingController descriptionController = TextEditingController();
  TextEditingController locationController = TextEditingController();


  bool uploadingProgress = false;


  SubmitEdit() async {
    setState(() {
      uploadingProgress = true;
    });

    //update post in the firestore
    DocumentSnapshot snapshot = await postsRef
        .doc(widget.currentUser.userID)
        .collection("user_posts")
        .doc(widget.data["postID"]).get();
    if(snapshot.exists){
      snapshot.reference .update({
        "description": descriptionController.text,
        "location": locationController.text
      });
    }

    setState(() {
      uploadingProgress = false;
    });

    SnackBar snackbar = SnackBar(
      content: Text("Successfully Updated Post!"),);
    ScaffoldMessenger.of(context).showSnackBar(snackbar);

  }

  Scaffold CaptionScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Edit Your Post",
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actions: [
          FlatButton(
            onPressed: uploadingProgress ? null : () => SubmitEdit(),
            child: Container(
              child: Icon(
                Icons.check,
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
                        fit: BoxFit.contain,
                        image: CachedNetworkImageProvider(widget.data["mediaURL"]),
                      )),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage:
              CachedNetworkImageProvider(widget.currentUser.photo_URL),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                    hintText: descriptionController.text, border: InputBorder.none),
              ),
            ),
          ),
          Divider(),

          Container(
            padding: EdgeInsets.symmetric(horizontal: 12,vertical:0),
            child: Row(
              children: [
                Expanded(
                  flex: 5,
                  child: TextField(
                    controller: locationController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(
                          Icons.location_pin,
                          size :40,
                          color :Colors.grey),
                      //suffixIcon:
                      hintText: "Add Location?",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Ink(
                    decoration: const ShapeDecoration(
                      color: Colors.green,
                      shape: CircleBorder(
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.my_location),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () async {
                        getCurrentLocation();
                      },
                    ),
                  ),
                ),

              ],
            ),
          ),



        ],
      ),
    );
  }

  getCurrentLocation() async {

    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }



    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);

    Placemark placemark = placemarks[0];
    String completeAddress =
        '${placemark.subThoroughfare} ${placemark.thoroughfare}, ${placemark.subLocality} ${placemark.locality}, ${placemark.subAdministrativeArea}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}';

    print(completeAddress);
    String formattedAddress = "${placemark.locality}, ${placemark.country}";
    locationController.text = formattedAddress;
  }


  @override
  void initState() {
    // TODO: implement initState
    descriptionController.text = widget.data["description"];
    locationController.text = widget.data["location"];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return  CaptionScreen() ;
  }
}