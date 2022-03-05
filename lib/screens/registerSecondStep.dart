import 'package:CovidTracker/DAL/user.dart';
import 'package:CovidTracker/resources/background.dart';
import 'package:CovidTracker/resources/conn.dart';
import 'package:intl/intl.dart';
import 'package:CovidTracker/resources/color.dart';
import 'package:CovidTracker/resources/errorMessage.dart';
import 'package:CovidTracker/resources/infoText.dart';
import 'package:CovidTracker/resources/loading.dart';
import 'package:CovidTracker/resources/logo.dart';
import 'package:CovidTracker/resources/submitButton.dart';
import 'package:CovidTracker/screens/home.dart';
import 'package:CovidTracker/screens/register.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../DAL/authService.dart';
import '../DAL/database.dart';
import '../DAL/utilisateur.dart';
import 'acceuil.dart';
import 'bienvenue.dart';
import 'landing.dart';
import 'login.dart';

class registerSecondStep extends StatefulWidget {
  late String fullName;
  late int age;
  late String gender;
  late DateTime dateCtl;

  registerSecondStep(this.fullName, this.age, this.gender,this.dateCtl);

  @override
  _registerState createState() => _registerState(fullName, age, gender,dateCtl);
}

class _registerState extends State<registerSecondStep> {
  late String fullName;
  late int age;
  late String gender;
  DateTime dateCtl;
  final AuthService _auth = AuthService();

  _registerState(this.fullName, this.age, this.gender, this.dateCtl);

  user test = new user();
  late bool submit = false;
  bool _isObscure = true;
  bool _isObscure2 = true;
  TextEditingController username = TextEditingController();
  TextEditingController gmail = TextEditingController();
  TextEditingController pass1 = TextEditingController();
  TextEditingController pass2 = TextEditingController();
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    final isKeyboard = MediaQuery.of(context).viewInsets.bottom != 0;
    double h = MediaQuery.of(context).size.height;
    Widget wrapContent= Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          splashRadius: 1,
          icon: Icon(Icons.chevron_left_rounded,
            size: h*0.04,),
          onPressed: () => Navigator.pop(context),
          color: ybcolor,
        ),
      ),
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: h*0.010),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  logo()
                ],
              ),
            ),
            if (!isKeyboard)
              FractionallySizedBox(
                child: Padding(
                  padding: EdgeInsets.only(top: h*0.050),
                  child: Image.asset(
                    "assets/images/register.png",
                    fit: BoxFit.fitWidth,
                  ),
                ),
                widthFactor: 0.77,
              ),
            if (!isKeyboard)
              Padding(
                padding: EdgeInsets.only(top: h*0.03),
                child: infoText(
                  text: "Entrez vos informations",
                  size: h*0.017,
                ),
              ),
            Padding(padding: EdgeInsets.only(top: h*0.020)),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(h*0.035, h*0.005, h*0.035, 0),
                  child: TextField(
                    controller: username,
                    textAlign: TextAlign.center,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: 'Nom d\'utilisateur',
                      contentPadding: EdgeInsets.only(top: h*0.002, right: h*0.040),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.account_circle_outlined,
                        color: ybcolor,
                      ),
                      hintStyle: TextStyle(
                          fontSize: h*0.015,
                          fontFamily: 'Montserrat',
                          color: Colors.grey[400]),
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: ybcolor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: ybcolor, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (submit == true && username.text == "")
              errorMessage('Entrez un nom d\'utilisateur valide!'),
            if (submit == true && username.text.length <=4 && username.text != "")
              errorMessage('Le nom d\'utilisateur min 5 '),
            FractionallySizedBox(
              widthFactor: 0.95,
              child: Container(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(h*0.035, h*0.015, h*0.035, 0),
                  child: TextField(
                    controller: gmail,
                    textAlign: TextAlign.center,
                    autocorrect: true,
                    decoration: InputDecoration(
                      hintText: 'Entrez votre email',
                      contentPadding: EdgeInsets.only(right: h*0.010, left: h*0.030),
                      filled: true,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: ybcolor,
                      ),
                      hintStyle: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Montserrat',
                          color: Colors.grey[400]),
                      fillColor: Colors.white70,
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: ybcolor, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(50.0)),
                        borderSide: BorderSide(color: ybcolor, width: 2),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            if (submit == true &&
                !RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                    .hasMatch(gmail.text.trimRight()))
             errorMessage('${gmail.text}kkk'),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, h*0.015, 0, 0),
                child: TextField(
                  controller: pass1,
                  textAlign: TextAlign.center,
                  autocorrect: true,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    hintText: 'Entrez votre mot de passe',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: ybcolor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.only(top: h*0.002),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: ybcolor,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[400]),
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: ybcolor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: ybcolor, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            if (submit == true &&
                !RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$' )
                    .hasMatch(pass1.text) && pass1.text.length > 8 )
              errorMessage("Entrez un mot de passe valide"),
            if (submit == true && pass1.text.length > 50)
              errorMessage("Mot de passe long. max 50"),
            if (submit == true && pass1.text.length < 8)
              errorMessage("Mot de passe court. min 8"),
            FractionallySizedBox(
              widthFactor: 0.8,
              child: Padding(
                padding: EdgeInsets.fromLTRB(0, h*0.015, 0, 0),
                child: TextField(
                  controller: pass2,
                  textAlign: TextAlign.center,
                  autocorrect: true,
                  obscureText: _isObscure2,
                  decoration: InputDecoration(
                    hintText: 'Confirmez votre mot de passe',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isObscure2
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: ybcolor,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure2 = !_isObscure2;
                        });
                      },
                    ),
                    contentPadding: EdgeInsets.only(top: h*0.002),
                    filled: true,
                    prefixIcon: Icon(
                      Icons.lock_outline,
                      color: ybcolor,
                    ),
                    hintStyle: TextStyle(
                        fontSize: 13,
                        fontFamily: 'Montserrat',
                        color: Colors.grey[400]),
                    fillColor: Colors.white70,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: ybcolor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50.0)),
                      borderSide: BorderSide(color: ybcolor, width: 2),
                    ),
                  ),
                ),
              ),
            ),
            if (submit == true && pass2.text != pass1.text)
              errorMessage("Confirmez votre mot de passe"),
            SizedBox(
              height: h*0.030,
            ),
            FractionallySizedBox(
              widthFactor: 0.75,
              child: submitButton(
                text: "Créer votre compte",
                press: () async {
                  setState(() {
                    submit = true;
                  });
                  if (RegExp(r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$')
                      .hasMatch(pass1.text) &&
                      RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$")
                          .hasMatch(gmail.text.trimRight()) &&
                      username.text != ''&& username.text.length>5) {
                    test = new user();
                    test.setfullName = fullName;
                    test.setemail = gmail.text.trimRight();
                    test.setuserName = username.text.trimRight();
                    test.setage = age;
                    test.setgender = gender;
                    test.setpassword = pass1.text;

                    setState(() {
                      loading = true;
                    });
                    dynamic result = await _auth.registerWithEmailAndPassword(
                        test.getemail, test.getpassword);
                    print('${test.getemail}kk');print('${gmail.text}kk');
                    print(test.getpassword);
                    if(result!=null)  {
                      dynamic res = await databaseService(uid: result!.uid)
                          .updateUserDate(
                        test.getfullName,
                        test.getage,
                        test.getgender,
                        test.getuserName,
                        test.getpassword,
                        test.getemail,
                        false,
                        '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}',
                        '${dateCtl.year}-${dateCtl.month}-${dateCtl.day}',

                      );
                    }
                    else{
                      setState(() {
                        loading = false;
                        error = 'Il y\'a un compte avec cet email!';
                      });
                    }
                  }
                },
                color: ybcolor,
                textColor: Colors.white,
              ),
            ),
            Center(
              child: Text(
                error,
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
            Padding(
              padding:EdgeInsets.only(bottom:h*0.030),
              child: GestureDetector(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => login()));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Déja inscrit? ",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Connectez vous.',
                        style: TextStyle(
                          color: ybcolor,
                          fontFamily: 'Montserrat',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  )),
            ),
          ],
        ),
      ),
    );
    final use = Provider.of<utilisateur?>(context);
    if (use == null) if (loading)
      return Loading();
    else
      return SafeArea(
          child:conn(clas: wrapContent)
      );
    else
      return acceuilScreen();
  }
}
