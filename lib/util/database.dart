import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:harvest/util/util.dart';
import 'package:location/location.dart';



class DatabaseService {

  String errorMsg;
  final String uid ;

  DatabaseService({this.uid});

  final FirebaseAuth auth                  = FirebaseAuth.instance ;
  final CollectionReference clients        = FirebaseFirestore.instance.collection('Clients');
  final CollectionReference phones         = FirebaseFirestore.instance.collection('Phones');
  final CollectionReference fruits         = FirebaseFirestore.instance.collection('Fruits');
  final CollectionReference vegetables     = FirebaseFirestore.instance.collection('Vegetables');
  final CollectionReference seafood        = FirebaseFirestore.instance.collection('fish');
  final CollectionReference meatAndChicken = FirebaseFirestore.instance.collection('Meat and chicken');
  final CollectionReference milk           = FirebaseFirestore.instance.collection('Milk');
  final CollectionReference productPosts   = FirebaseFirestore.instance.collection('ProductPosts');



  Future createNewClient({String name ,phone,accType,cCode,uid}) async {
    return await clients.doc(uid).set({
      'Name'    :name,
      'Phone'   : phone ,
      'CCode'   : cCode,
      'AccType' : accType.toString(),
      'UID'     : uid,
    });
  }

  Future addProductPost({String nameAR ,nameEN , url ,vendorUID ,price ,currency,type,postUID}) async {

    final pos = await Location().getLocation();
    GeoFirePoint point = GeoFirePoint(pos.latitude,pos.longitude);

    await clients.doc(vendorUID).update({
      'posts' : FieldValue.arrayUnion(['$vendorUID$nameEN'])
    });

    return await productPosts.doc('$vendorUID$nameEN').set({
      'nameAR'   :nameAR,
      'nameEN'   :nameEN,
      'url'      :url,
      'VendorUID':vendorUID,
      'price'    :price,
      'currency' :currency,
      'type'     :type,
      'postUID': postUID,
      'postLocation' : point.data ,
    });
  }

  Future updateMyLocation() async {
    final pos = await Location().getLocation();
    GeoFirePoint point = GeoFirePoint(pos.latitude,pos.longitude);
    return await clients.doc(uid).update({
      'Location' : point.data ,
    });
  }

  Future signOut() async {
    await auth.signOut();
  }

  Stream<User> get userState {
    return auth.authStateChanges() ;
  }



//To check If a phone is registered or not ****************************************
  Future addPhone({String phone,cCode})async{
    return await phones.doc(phone).set({
      'Phones': phone ,
      'CCode' : cCode,
    });
  }
  Future<bool> alreadyRegistered ({String phone})async {
    final docs =  await phones.where('Phones' , isEqualTo: phone ).get();
    if(docs.size == 0 ){
      return false ;
    }else return true ;
  }

// get all Products as future and as stream ***************************************
  Future<List<Product>> getFruits() async {
    List<Product> fruitsList = [];
    final products =  await fruits.get();
    products.docs.forEach((doc) {
      fruitsList.add(
        Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url:    doc.get('url'),
        )
      );
    });
    return fruitsList;
  }
  Stream<List<Product>> get fruitsStream  {
    List<Product> fruitList = [] ;
    return fruits.snapshots().map((snapshot) {
        snapshot.docs.forEach((doc) {
        return fruitList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          ),
        );
      });
        return fruitList;
    });
  }

  Future<List<Product>> getVegetables() async {
    List<Product> vegetablesList = [];
    final products =  await vegetables.get();
    products.docs.forEach((doc) {
      vegetablesList.add(
        Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url:    doc.get('url'),
        )
      );
    });
    return vegetablesList;
  }
  Stream<List<Product>> get vegetablesStream  {
    List<Product> vegetablesList = [] ;
    return vegetables.snapshots().map((snapshot) {
      snapshot.docs.forEach((doc) {
        return vegetablesList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          ),
        );
      });
      return vegetablesList ;
    });
  }

  Future<List<Product>> getSeafood() async {
    List<Product> seafoodList = [];
    final products =  await seafood.get();
    products.docs.forEach((doc) {
      seafoodList.add(
        Product(
          nameAR: doc.get('nameAR'),
          nameEN: doc.get('nameEN'),
          url:    doc.get('url'),
        )
      );
    });
    return seafoodList;
  }
  Stream<List<Product>> get seafoodStream  {
    List<Product> seafoodList = [] ;
    return seafood.snapshots().map((snapshot) {
      snapshot.docs.forEach((doc) {
        return seafoodList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          ),
        );
      });
      return seafoodList ;
    });
  }

  Future<List<Product>> getMilk() async {
    List<Product> milkList = [];
    final products =  await milk.get();
    products.docs.forEach((doc) {
      milkList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          )
      );
    });
    return milkList;
  }
  Stream<List<Product>> get milkStream  {
    List<Product> milkList = [] ;
    return milk.snapshots().map((snapshot) {
      snapshot.docs.forEach((doc) {
        return milkList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          ),
        );
      });
      return milkList ;
    });
  }

  Future<List<Product>> getMeatChicken() async {
    List<Product> meatChickenList = [];
    final products =  await meatAndChicken.get();
    products.docs.forEach((doc) {
      meatChickenList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          )
      );
    });
    return meatChickenList;
  }
  Stream<List<Product>> get meatChickenStream  {
    List<Product> meatChickenList = [] ;
    return meatAndChicken.snapshots().map((snapshot) {
      snapshot.docs.forEach((doc) {
        return meatChickenList.add(
          Product(
            nameAR: doc.get('nameAR'),
            nameEN: doc.get('nameEN'),
            url:    doc.get('url'),
          ),
        );
      });
      return meatChickenList ;
    });
  }
//********************************************************************************

//to get the posts uid from the current user doc *********************************
  Stream<List> get getPostsUID  {
    return clients.doc(uid).snapshots().map((snapshot) {
      return snapshot.get('posts');
    });
  }

//to get posts  from productPosts collection     *********************************
  Stream<Posts> get getPostedProducts  {
    return productPosts.doc(uid).snapshots().map((snapshot) {
      return Posts(
        nameAR: snapshot.get('nameAR'),
        nameEN: snapshot.get('nameEN'),
        url: snapshot.get('url'),
        price: snapshot.get('price'),
        vendorUID: snapshot.get('VendorUID'),
        currency: snapshot.get('currency'),
        type: snapshot.get('type'),
        postUID: snapshot.get('postUID')
      );
    });
  }

  Future deletePost(postUID)async{
    await productPosts.doc(postUID).delete();
    return await clients.doc(uid).update({
      'posts': FieldValue.arrayRemove([postUID])
    });
  }

// getting the account type to display the correct version of The app *************
  Future<Users> getAccType(String uid)async {
    final doc =  await clients.doc(uid).get() ;
    return Users(accType: doc.get('AccType')) ;
  }




}
