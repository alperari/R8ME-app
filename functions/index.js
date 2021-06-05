const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();


exports.onFollow_Add_Posts_To_Timeline = functions.firestore
  .document("/followers_table/{userID}/myFollowers/{followerID}")
  .onCreate(async (snapshot, context) => {

    const userID = context.params.userID;
    const followerID = context.params.followerID;

    console.log(followerID, "started following", userID);

    // 1) Create followed users posts ref
    const followedUserPostsRef = admin
      .firestore()
      .collection("posts")
      .doc(userID)
      .collection("user_posts");

    // 2) Create following user's timeline ref
    const FollowerTimelinePostsRef = admin
      .firestore()
      .collection("timeline")
      .doc(followerID)
      .collection("timelinePosts");

    // 3) Get followed users posts
    const querySnapshot = await followedUserPostsRef.get();

    // 4) Add each followedUser post to followerUser's timeline
    querySnapshot.forEach((doc) => {
      if (doc.exists) {
        const postID = doc.id;
        const postData = doc.data();
        FollowerTimelinePostsRef.doc(postID).set(postData);
      }
    });
  });


exports.onUnfollow_Remove_Posts_From_Timeline = functions.firestore
 .document("/followers_table/{userID}/myFollowers/{followerID}")
 .onDelete(async (snapshot, context) => {

   const userID = context.params.userID;
   const followerID = context.params.followerID;

    console.log(followerID,"stopped following",userID);

   const FollowerTimelinePostsRef = admin
     .firestore()
     .collection("timeline")
     .doc(followerID)
     .collection("timelinePosts")
     .where("ownerID", "==", userID);

   const querySnapshot = await FollowerTimelinePostsRef.get();
   querySnapshot.forEach((doc) => {
     if (doc.exists) {
       doc.ref.delete();
     }
   });
 });



 exports.onCreatePost_Add_Post_To_Timeline = functions.firestore
   .document("/posts/{userID}/user_posts/{postID}")
   .onCreate(async (snapshot, context) => {
     const postCreated = snapshot.data();
     const userID = context.params.userID;
     const postID = context.params.postID;

     // 1) Get all the followers of the user who made the post
     const userFollowersRef = admin
       .firestore()
       .collection("followers_table")
       .doc(userID)
       .collection("myFollowers");

     const querySnapshot = await userFollowersRef.get();


     // 2) Add new post to each follower's timeline
     querySnapshot.forEach((doc) => {
       const followerID = doc.id;

       admin
         .firestore()
         .collection("timeline")
         .doc(followerID)
         .collection("timelinePosts")
         .doc(postID)
         .set(postCreated);
     });
   });


   exports.onUpdatePost_Update_Post_In_Timeline = functions.firestore
     .document("/posts/{userID}/user_posts/{postID}")
     .onUpdate(async (change, context) => {
       const postUpdated = change.after.data();
       const userID = context.params.userID;
       const postID = context.params.postID;

       // 1) Get all the followers of the user who made the post
       const userFollowersRef = admin
         .firestore()
         .collection("followers_table")
         .doc(userID)
         .collection("myFollowers");

       const querySnapshot = await userFollowersRef.get();
       // 2) Update each post in each follower's timeline
       querySnapshot.forEach((doc) => {
         const followerID = doc.id;

         admin
           .firestore()
           .collection("timeline")
           .doc(followerID)
           .collection("timelinePosts")
           .doc(postID)
           .get()
           .then((doc) => {
             if (doc.exists) {
               doc.ref.update(postUpdated);
             }
           });
       });
     });

   exports.onDeletePost_Remove_Post_From_Timeline = functions.firestore
     .document("/posts/{userID}/user_posts/{postID}")
     .onDelete(async (snapshot, context) => {
       const userID = context.params.userID;
       const postID = context.params.postID;

       // 1) Get all the followers of the user who made the post
       const userFollowersRef = admin
         .firestore()
         .collection("followers_table")
         .doc(userID)
         .collection("myFollowers");

       const querySnapshot = await userFollowersRef.get();


       // 2) Delete each post in each follower's timeline
       querySnapshot.forEach((doc) => {
         const followerID = doc.id;

         admin
           .firestore()
           .collection("timeline")
           .doc(followerID)
           .collection("timelinePosts")
           .doc(postID)
           .get()
           .then((doc) => {
             if (doc.exists) {
               doc.ref.delete;
             }
           });
       });
     });


//update user's rate on change of posts' like and dislike counts
exports.onChangeLike_updateUserRate = functions.firestore
     .document("posts/{userID}/user_posts/{postID}")
     .onUpdate(async (change,context)=>{
      
      const userID = context.params.userID;
      const postID = context.params.postID;

      const postBefore = change.before.data();
      const postAfter = change.after.data();
      
      const usersRef = admin
       .firestore()
       .collection("users");

      const beforeLikeCount = postBefore["likeCount"];
      const beforeDislikeCount = postBefore["dislikeCount"];

      const afterLikeCount = postAfter["likeCount"];
      const afterDislikeCount = postAfter["dislikeCount"];


      var likes=0;
      var dislikes=0;

      const querySnapshot = await admin
        .firestore()
        .collection("posts")
        .doc(userID)
        .collection("user_posts")
        .get();

      querySnapshot.forEach((doc)=>{
        likes += doc.data()["likeCount"];
        dislikes += doc.data()["dislikeCount"];
      });
      
      var rate = likes/(likes+dislikes);


      if(beforeLikeCount != afterLikeCount || 
        beforeDislikeCount != afterDislikeCount){
          //count all likes and dislikes
          usersRef.doc(userID).update({
            "rate": rate
          });
          console.log("updated user", userID, "with rate with",rate);
      }


     });