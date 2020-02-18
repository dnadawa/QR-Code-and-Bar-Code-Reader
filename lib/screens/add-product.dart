import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snappgo/screens/home.dart';
import 'package:snappgo/widgets/toast.dart';

class AddProduct extends StatefulWidget {
    final String id;

  const AddProduct({Key key, this.id}) : super(key: key);
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {


  CollectionReference collectionReference = Firestore.instance.collection('products');
  CollectionReference waitingList = Firestore.instance.collection('pending');
  bool isChecked = false;
  TextEditingController title = TextEditingController();
  TextEditingController desc = TextEditingController();
  String imgurl;
  String email;
  String uname;

  getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    email = prefs.getString('email');
    uname = prefs.getString('username');
  }


  submitData(BuildContext context) async {
      try{
        await collectionReference.document(widget.id).setData({
          'id': widget.id,
          'title': title.text,
          'description': desc.text,
          'image': imgurl,
          'user': email,
          'username': uname,
          'hideName': isChecked,
          'liked_users': [],
          'disliked_users': [],
          'likes': 0,
          'dislikes': 0,
          'approved': false
        });

//        await waitingList.document(widget.id).setData({
//          'id': widget.id,
//          'title': title.text,
//          'image':imgurl,
//          'description': desc.text,
//          'user': email,
//          'username': uname,
//          'hideName': isChecked,
//          'approved': false
//        });

        ToastBar(text: 'Successful!',color: Colors.green).show();
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => Home()),
        );
      }
      catch(E){
        ToastBar(text: 'Something Went Wrong',color: Colors.red).show();
      }
  }

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    try{
      StorageReference ref = FirebaseStorage.instance.ref().child("/$email/${basename(image.path)}");
      StorageUploadTask uploadTask = ref.putFile(image);
      final StorageTaskSnapshot downloadUrl = (await uploadTask.onComplete);
      imgurl = (await downloadUrl.ref.getDownloadURL());
      print("url is $imgurl");
    }
    catch(e){
      print(e);
      ToastBar(text: 'Something Went Wrong',color: Colors.red).show();
    }
  }

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/homeback.jpg'),fit: BoxFit.fitHeight)),
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top:20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Please add this new product',style: GoogleFonts.dosis(fontSize: 60,height: 1,color: Colors.white,fontWeight: FontWeight.w400),textAlign: TextAlign.center,),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('ID - ${widget.id}',style:  TextStyle(fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text('Upload a Photograph',style:  TextStyle(fontSize: 22,color: Colors.white,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
                  ),

                  GestureDetector(
                      onTap: ()=>getImage(),
                      child: CircleAvatar(backgroundColor: Colors.white,child: Icon(Icons.add_a_photo,size: 35,),radius: 35,)),

                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text('Title',style:  TextStyle(fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      controller: title,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 0)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 0)),
                      ),
                    ),
                  ),


                  Text('Description',style:  TextStyle(fontSize: 22,color: Colors.white),textAlign: TextAlign.center,),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: TextField(
                      maxLines: null,
                      controller: desc,
                      decoration: InputDecoration(
                        fillColor: Colors.white,
                        filled: true,
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 0)),
                        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(20),borderSide: BorderSide(width: 0)),
                      ),
                    ),
                  ),

                  Row(
                    children: <Widget>[
                      Checkbox(
                        value: isChecked,
                        onChanged: (value) {
                          setState(() {
                            isChecked = value;
                          });
                          },
                      ),

                      Text('Keep Me Anonymous',style: TextStyle(color: Colors.white,fontSize: 16),)

                    ],
                  ),

                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    child: SizedBox(
                      width: double.infinity,
                      child: RaisedButton(
                          onPressed: ()=>submitData(context),
                          shape:RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          color: Color(0xff5C6BC0),
                          textColor: Colors.white,
                          padding: EdgeInsets.all(10),
                          child: Text('Submit',style: TextStyle(fontSize: 20),)
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
