import 'package:flutter/material.dart';
import "package:cs310/pages/edit_profile.dart";
import "package:firebase_auth/firebase_auth.dart";
import 'package:cs310/UserHelper.dart';
import "package:cs310/classes/customUser.dart";

final User FirebaseUser = FirebaseAuth.instance.currentUser;
customUser myuser;


class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  var mydata;


  loadData() async{
    mydata = await getuserById(Uid: FirebaseUser.uid);
  }
  @override
  void initState() {
    loadData();
    myuser = customUser(mydata);
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    //print(mydata);
    setState(() {
      myuser = customUser(mydata);

    });


    return Stack(
          children: <Widget>[
            SizedBox.expand(
              child: Image.asset("assets/applogo.jpeg", fit: BoxFit.contain,),
            ),

            DraggableScrollableSheet(
              minChildSize: 0.1,
              initialChildSize: 0.22,
              builder: (context, scrollController){
                return SingleChildScrollView(
                  controller: scrollController,
                  child: Container(
                    constraints: BoxConstraints(minHeight: MediaQuery.of(context).size.height),
                    color: Colors.white,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        //for user profile header
                        Container(
                          padding : EdgeInsets.only(left: 32, right: 32, top: 32),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              SizedBox(
                                  height: 100,
                                  width: 100,
                                  child: ClipOval(
                                    child: Image.asset("assets/user.jpeg", fit: BoxFit.cover,),
                                  )
                              ),

                              SizedBox(width: 16,),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(myuser.username, style: TextStyle(color: Colors.grey[800], fontFamily: "Roboto",
                                        fontSize: 16, fontWeight: FontWeight.w700
                                    ),),

                                  ],
                                ),
                              ),
                              FlatButton.icon(
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile()));
                                  },
                                  icon: Icon(Icons.edit),label:Text("Edit"))
                            ],
                          ),
                        ),



                        SizedBox(height: 16,),
                        Container(
                          padding: EdgeInsets.all(32),
                          color: Colors.greenAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.check_box, color: Colors.black, size: 30,),
                                      SizedBox(width: 4,),
                                      Text(myuser.followings_count.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto", fontSize: 24
                                      ),)
                                    ],
                                  ),

                                  Text("Following", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto", fontSize: 15
                                  ),)
                                ],
                              ),

                              Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(Icons.favorite, color: Colors.black, size: 30,),
                                      SizedBox(width: 4,),
                                      Text(myuser.followings_count.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto", fontSize: 24
                                      ),)
                                    ],
                                  ),

                                  Text("Followers", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto", fontSize: 15
                                  ),)
                                ],
                              ),

                              Column(
                                children: <Widget>[
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: <Widget>[

                                      SizedBox(width: 4,),
                                      Text(myuser.rate.toString(), style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                          fontFamily: "Roboto", fontSize: 24
                                      ),)
                                    ],
                                  ),

                                  Text("Rating", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold,
                                      fontFamily: "Roboto", fontSize: 15
                                  ),)
                                ],
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: 16,),
                        //container for about me

                        Container(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          child: Column(
                            children: <Widget>[
                              Text("Bio", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                  fontFamily: "Roboto", fontSize: 18
                              ),),

                              SizedBox(height: 8,),
                              Text(
                                  myuser.bio.toString(),
                                style: TextStyle(fontFamily: "Roboto", fontSize: 15),
                              ),

                            ],
                          ),
                        ),

                        SizedBox(height: 16,),
                        //Container for clients

                        Container(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          child: Column(
                            children: <Widget>[
                              Text("comments:", style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w700,
                                  fontFamily: "Roboto", fontSize: 18
                              ),),

                              SizedBox(height: 8,),
                              //for list of clients


                            ],
                          ),
                        ),

                        SizedBox(height: 16,),

                        //Container for reviews

                        Container(
                          padding: EdgeInsets.only(left: 32, right: 32),
                          child: Column(
                            children: <Widget>[



                              Container(
                                width: MediaQuery.of(context).size.width-64,
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text("Post $index", style: TextStyle(color: Colors.greenAccent, fontSize: 18, fontFamily: "Roboto",
                                                fontWeight: FontWeight.w700
                                            )),

                                            Row(
                                              children: <Widget>[
                                                Icon(Icons.star, color: Colors.orangeAccent,),
                                                Icon(Icons.star, color: Colors.orangeAccent,),
                                                Icon(Icons.star, color: Colors.orangeAccent,),
                                              ],
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: 8,),

                                        Text("Bariş hoca give us 100 ", style: TextStyle(color: Colors.grey[800], fontSize: 14, fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400
                                        )),
                                        SizedBox(height: 16,),
                                      ],
                                    );
                                  },
                                  itemCount: 8,
                                  shrinkWrap: true,
                                  controller: ScrollController(keepScrollOffset: false),
                                ),
                              )
                            ],
                          ),
                        )


                      ],
                    ),

                  ),
                );
              },
            )
          ],
        );

  }
}

