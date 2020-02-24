import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:snappgo/widgets/button.dart';
import 'package:snappgo/widgets/inputfield.dart';
import 'package:snappgo/widgets/toast.dart';
import 'package:snappgo/widgets/white-text.dart';

class SignUp extends StatelessWidget {

  TextEditingController uname = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  CollectionReference collectionReference = Firestore.instance.collection('users');

  signUp() async {
    if(email.text!='' && password.text!='' && uname.text!=''){
      try{
        AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
            email: email.text, password: password.text);
        FirebaseUser user = result.user;
        print(user.uid);

        await collectionReference.document(user.uid).setData({
          'name': uname.text,
          'email': email.text,
        });
        uname.clear();
        email.clear();
        password.clear();
        ToastBar(color: Colors.green,text: 'Signed Up Successfully!').show();
      }
      catch(E){
        ToastBar(color: Colors.red,text: 'Something Went Wrong!').show();
        print(E);
      }
    }else{
      ToastBar(color: Colors.red,text: 'Please Fill all the Fields!').show();
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(image: AssetImage('images/homeback.jpg'),fit: BoxFit.fitHeight)
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50,0,40,0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              WhiteText(text: 'Create your account',size: 30,),
              InputField(hint: 'Username',controller: uname,),
              InputField(hint: 'Email',type: TextInputType.emailAddress,controller: email,),
              InputField(hint: 'Password',ispassword:true,controller: password,),
              Padding(
                padding: const EdgeInsets.only(top: 70),
                child: Button(onclick: ()=>signUp(),
                    text: 'Sign Up'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
