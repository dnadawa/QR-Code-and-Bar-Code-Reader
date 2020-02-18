import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
import 'package:snappgo/screens/add-product.dart';
import 'package:snappgo/screens/product.dart';
import 'package:snappgo/widgets/toast.dart';

class Home extends StatelessWidget {

  CollectionReference collectionReference = Firestore.instance.collection('products');

  Future _scanQR(BuildContext context) async {
    try {
      String qrResult = await BarcodeScanner.scan();
      var sub = await Firestore.instance.collection('products').where('id',isEqualTo: qrResult).getDocuments();
      var products = sub.documents;
      if(products.isEmpty){
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => AddProduct(id: qrResult,)),
        );
      }
      else if(products[0].data['approved']==false){
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => AddProduct(id: qrResult,)),
        );
        print('exists');
      }

      else{
        Navigator.push(
          context,
          CupertinoPageRoute(builder: (context) => Products(id: qrResult,)),
        );
      }
      print(qrResult);



    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        ToastBar(text: 'Camera permission was denied',color: Colors.red).show();
          print("Camera permission was denied");
      } else {
        ToastBar(text: 'Something Went Wrong',color: Colors.red).show();
      }
    } on FormatException {
      print("You pressed the back button before scanning anything");
      ToastBar(text: 'You pressed the back button before scanning anything',color: Colors.red).show();
    } catch (ex) {
      ToastBar(text: 'Something Went Wrong',color: Colors.red).show();
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(image: DecorationImage(image: AssetImage('images/homeback.jpg'),fit: BoxFit.fitHeight)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Welcome',style: GoogleFonts.dosis(fontSize: 66,color: Colors.white),),
            Padding(
              padding: const EdgeInsets.fromLTRB(20,50,20,20),
              child: Text('Press “Scan” Button To Scan The Code',style:  TextStyle(fontSize: 32,color: Colors.white),textAlign: TextAlign.center,),
            ),
            Padding(
              padding: const EdgeInsets.all(40),
              child: SizedBox(
                width: double.infinity,
                child: RaisedButton(
                  onPressed: ()=>_scanQR(context),
                  shape:RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  color: Color(0xff5C6BC0),
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  child: Text('Scan',style: TextStyle(fontSize: 30),)
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
