import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Products extends StatefulWidget {
  final String id;

  const Products({Key key, this.id}) : super(key: key);
  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {


  CollectionReference collectionReference = Firestore.instance.collection('products');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
        stream: collectionReference.where('id',isEqualTo: widget.id).snapshots(),
        builder: (context,snapshot){
          var list;
          if(!snapshot.hasData){
            return Center(child: CircularProgressIndicator(),);
          }
          list = snapshot.data.documents;


          var likes = list[0].data['likes'];
          var dislikes = list[0].data['dislikes'];
          return Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/homeback.jpg'),fit: BoxFit.fitHeight)),
            child: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(list!=null?list[0].data['title']:'Loading',style: GoogleFonts.dosis(fontSize: 60,height: 1,color: Colors.white,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),

                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(list[0].data['hideName']==true?'':list[0].data['username'],style:  TextStyle(fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
                    ),

                    Padding(
                      padding: const EdgeInsets.fromLTRB(30,10,30,20),
                      child: Image.network(list[0].data['image']),
                    ),

                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: RaisedButton(
                                  onPressed: () async {
                                    var email;
                                    var liked_users = List<String>.from(list[0].data['liked_users']);
                                    var disliked_users = List<String>.from(list[0].data['disliked_users']);
                                    int newLikes = likes;
                                    int newDislikes = dislikes;
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    email = prefs.getString('email');
                                    if(liked_users.contains(email)){
                                      newLikes = likes - 1;
                                      liked_users.remove(email);
                                      collectionReference.document(list[0].documentID).updateData({
                                        'liked_users': liked_users,
                                        'disliked_users': disliked_users,
                                        'likes': newLikes,
                                        'dislikes': newDislikes
                                      });
                                    }
                                    else if(disliked_users.contains(email)){
                                      newDislikes = dislikes - 1;
                                      disliked_users.remove(email);
                                      newLikes = likes + 1;
                                      liked_users.add(email);
                                      collectionReference.document(list[0].documentID).updateData({
                                        'liked_users': liked_users,
                                        'disliked_users': disliked_users,
                                        'likes': newLikes,
                                        'dislikes': newDislikes
                                      });
                                    }
                                    else{
                                      newLikes = likes + 1;
                                      liked_users.add(email);
                                      collectionReference.document(list[0].documentID).updateData({
                                        'liked_users': liked_users,
                                        'disliked_users': disliked_users,
                                        'likes': newLikes,
                                        'dislikes': newDislikes
                                      });

                                    }

                                    print(newLikes);
                                    print(liked_users);

                                  },
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: Colors.green,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  child: Text('Like\t($likes)',style: TextStyle(fontSize: 20),)
                              ),
                            ),
                          ),

                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: RaisedButton(
                                  onPressed: () async {
                                    var email;
                                    var liked_users = List<String>.from(list[0].data['liked_users']);
                                    var disliked_users = List<String>.from(list[0].data['disliked_users']);
                                    int newLikes = likes;
                                    int newDislikes = dislikes;
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    email = prefs.getString('email');
                                    if(disliked_users.contains(email)){
                                      newDislikes = dislikes - 1;
                                      disliked_users.remove(email);
                                      collectionReference.document(list[0].documentID).updateData({
                                        'liked_users': liked_users,
                                        'disliked_users': disliked_users,
                                        'likes': newLikes,
                                        'dislikes': newDislikes
                                      });

                                    }
                                    else if(liked_users.contains(email)){
                                      newLikes = likes - 1;
                                      liked_users.remove(email);
                                      newDislikes = dislikes + 1;
                                      disliked_users.add(email);
                                      collectionReference.document(list[0].documentID).updateData({
                                        'liked_users': liked_users,
                                        'disliked_users': disliked_users,
                                        'likes': newLikes,
                                        'dislikes': newDislikes
                                      });
                                    }
                                    else{
                                      newDislikes = dislikes + 1;
                                      disliked_users.add(email);
                                      collectionReference.document(list[0].documentID).updateData({
                                        'liked_users': liked_users,
                                        'disliked_users': disliked_users,
                                        'likes': newLikes,
                                        'dislikes': newDislikes
                                      });

                                    }
                                  },
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  color: Colors.red,
                                  textColor: Colors.white,
                                  padding: EdgeInsets.all(10),
                                  child: Text('Dislike\t($dislikes)',style: TextStyle(fontSize: 20),)
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 10,),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(list[0].data['description'],style:  TextStyle(fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
                    ),
                    SizedBox(height: 20,),

                    GestureDetector(
                      onTap: (){
                        Share.share('https://play.google.com/store/apps/details?id=com.digiwrecks.snappgo');
                      },
                      child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.share,size: 30,color: Theme.of(context).primaryColor,),
                        radius: 30,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );

        },
      ),
    );
  }
}
