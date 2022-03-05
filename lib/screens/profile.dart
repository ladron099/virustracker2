import 'package:CovidTracker/resources/infoBox.dart';
import 'package:CovidTracker/resources/submitButton.dart';
import 'package:CovidTracker/resources/switchState.dart';
import 'package:CovidTracker/screens/acceuil.dart';
import 'package:CovidTracker/screens/declareScreen.dart';
import 'package:CovidTracker/screens/maintenance.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_gradient_text/simple_gradient_text.dart';
import '../DAL/authService.dart';
import '../DAL/utilisateur.dart';
import '../resources/color.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../resources/conn.dart';
import 'landing.dart';
import 'package:url_launcher/url_launcher.dart';


class profileScreen extends StatefulWidget {
  const profileScreen({Key? key}) : super(key: key);

  @override
  State<profileScreen> createState() => _profileScreenState();
}

class _profileScreenState extends State<profileScreen> {

  final AuthService _auth = AuthService();
  String email='';
  String fullname='';
  String dateNais='';

  TextEditingController dateinput = TextEditingController();


  _getusername()async{
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      fullname = (prefs.getString('fullname') ?? '');
      email=(prefs.getString('email') ?? '');
      dateNais=(prefs.getString('birthDate') ?? '');
    });
  }


  bool active=false;
  _betch() async {
    final firebaseUser = await FirebaseAuth.instance.currentUser;
    if (firebaseUser != null) {
      await FirebaseFirestore.instance
          .collection('adminActions')
          .doc('maintenance')
          .get()
          .then((ds) {
        setState(() {
          active=ds.get('activated');
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    _betch();
    _getusername();
    Widget wrapContent=Text('');
    if(!active)
      wrapContent=Center(
          child: Scaffold(
              appBar: AppBar(
                centerTitle: true,
                title: Text(
                  "Profile",
                  style: TextStyle(
                    color: ybcolor,
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                backgroundColor: Colors.white,
                elevation: 0,
                leading: IconButton(
                  splashRadius: 1,
                  icon: Icon(
                    Icons.close,
                  ),
                  onPressed: () => Navigator.pop(context),
                  color: ybcolor,
                ),
              ),
              resizeToAvoidBottomInset: false,
              backgroundColor: Colors.white,
              body: Center(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom:h*0.030),
                      child: SizedBox(
                        height: 115,
                        width: 115,
                        child: Stack(
                          clipBehavior: Clip.none,
                          fit: StackFit.expand,
                          children: [
                            CircleAvatar(
                              backgroundImage: AssetImage("assets/images/icon.png"),
                            ),
                            Positioned(
                                bottom: 0,
                                right: -25,
                                child: RawMaterialButton(
                                  onPressed: () {},
                                  elevation: 2.0,
                                  fillColor: ybcolor,
                                  child: Icon(Icons.edit, color: Colors.white, size: 20,),
                                  shape: CircleBorder(),
                                )),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(h*0.065, h*0.030, h*0.020, h*0.020),
                      child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                        children:[ Text(
                          'Informations personelles',
                          style: TextStyle(
                            color: ybcolor,
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize:14,
                          ),
                        ),
                      ]),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(h*0.040,0,h*0.040,0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.15),
                                  spreadRadius: 5,
                                  blurRadius: 10,
                                  offset: Offset(0, 0), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                               Padding(
                                 padding: EdgeInsets.fromLTRB(h*0.030, h*0.020, h*0.020, 0),
                                 child: Text(
                                      'Nom Complet',
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        color: ybcolor,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize:13,
                                      ),
                                    ),
                               ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(h*0.020, h*0.010, h*0.020, h*0.0),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ybcolor.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(h*0.010),
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                        cursorColor: ybcolor,
                                        initialValue: '$fullname',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(h*0.01, h*0.0, h*0.020, h*0.020),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                /////////----------------------END OF FIRST INPUT----------/////////
                                Padding(
                                  padding: EdgeInsets.fromLTRB(h*0.030, h*0.020, h*0.020, 0),
                                  child: Text(
                                    'Email',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: ybcolor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize:13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(h*0.020, h*0.010, h*0.020, h*0.020),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ybcolor.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(h*0.010),
                                      child: TextFormField(
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                        cursorColor: ybcolor,
                                        initialValue: '$email',
                                        decoration: InputDecoration(
                                          contentPadding: EdgeInsets.fromLTRB(h*0.01, h*0.0, h*0.020, h*0.020),
                                          border: InputBorder.none,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                ///--------END OF SECOND INPUT---///////
                                Padding(
                                  padding: EdgeInsets.fromLTRB(h*0.030, 0, h*0.020, 0),
                                  child: Text(
                                    'Date de naissance',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: ybcolor,
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      fontSize:13,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(h*0.020, h*0.010, h*0.020, h*0.020),
                                  child: Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.grey[100],
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: ybcolor.withOpacity(0.2),
                                          spreadRadius: 2,
                                          blurRadius: 10,
                                          offset: Offset(0, 0),
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(h*0.010),
                                      child: TextFormField(

                                        readOnly: true,
                                        style: TextStyle(
                                          fontFamily: 'Montserrat',
                                          color: Colors.grey[700],
                                          fontSize: 15,
                                        ),
                                        showCursor: false,
                                        enableInteractiveSelection: false,
                                         controller: dateinput,
                                        decoration: InputDecoration(
                                          hintText: dateNais,
                                          contentPadding: EdgeInsets.fromLTRB(h*0.01, h*0.0, h*0.020, h*0.015),
                                          border: InputBorder.none,
                                        ),
                                        onTap: () async {
                                          DateTime? date = DateTime(1900);
                                          date = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(2100));
                                          var retrievedDate =
                                              "${date?.day}-${date?.month}-${date?.year}";
                                          setState(() {
                                            dateinput.text="$retrievedDate";
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(padding: EdgeInsets.all(30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              gradient: gradientcolor,
                              borderRadius: new BorderRadius.circular(50.0),
                            ),
                            child: MaterialButton(
                              highlightColor: ybcolor,
                              shape: StadiumBorder(),
                              textColor: Colors.white,
                              child: Text('Enregistrer',
                                style:
                                TextStyle(
                                  fontFamily: 'Montserrat',
                                  fontWeight: FontWeight.w100,
                                ),
                              ),
                              onPressed: () {},
                            ),
                          ),
                          OutlineGradientButton(
                            child: GradientText(
                              'Annuler',
                              style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.w100,
                              ),
                              textAlign: TextAlign.center,
                              colors: [ybcolor2, ybcolor],
                            ),
                            gradient: gradientcolor,
                            strokeWidth: 2,
                            radius: Radius.circular(25),
                            padding: EdgeInsets.symmetric(horizontal: h*0.024, vertical: h*0.017),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(h*0.050),
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Text(
                          'Copyright © VIRUS TRACKER 2021-2022',
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.3),
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            fontSize:10,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )
          ));
    else wrapContent=maintenance();
    final use = Provider.of<utilisateur?>(context);
    if (use != null) {
      return SafeArea(child: conn(clas: wrapContent));
    } else
      return landing();
  }
}
