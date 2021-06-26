
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sqlite/Auth/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:page_transition/page_transition.dart';

import '../global.dart';
import 'home_page.dart';



class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

//To Toggle Password Text Visibility.
  bool _obscureText = true;
  String _username, _email, _password;

//For the loading state.
  bool _isSubmitting;

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  FirebaseAuth auth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: baseColor,
      key: _scaffoldKey,
      body:
      Center(
        child: Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.white.withOpacity(0.8),

            ),
            alignment: Alignment.center,
            height: 400,
            width: 300,
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _showTitle(),
                      _showUsernameInput(),
                      _showEmailInput(),
                      _showPasswordInput(),
                      _showFormActions()
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

//1
  _showTitle() {
    return Text(
      "Register",
      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
    );
  }

//2
  _showUsernameInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        onSaved: (val) => _username = val,
        validator: (val) => val.length < 6 ? "Username is too short." : null,
        decoration: InputDecoration(
            //border: OutlineInputBorder(),
            labelText: "Username",
            hintText: "Enter Valid Username",
            icon: Icon(
              Icons.face,
              color: Colors.grey,
              size: 18,
            )),
      ),
    );
  }

//3
  _showEmailInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        onSaved: (val) => _email = val,
        validator: (val) => !val.contains("@") ? "Invalid Email" : null,
        decoration: InputDecoration(
            //border: OutlineInputBorder(),
            labelText: "Email",
            hintText: "Enter Valid Email",
            icon: Icon(
              Icons.mail,
              color: Colors.grey,
              size: 18,
            )),
      ),
    );
  }

//4
  _showPasswordInput() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: TextFormField(
        onSaved: (val) => _password = val,
        validator: (val) => val.length < 6 ? "Password Is Too Short" : null,
        obscureText: _obscureText,
        decoration: InputDecoration(
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
              child:
              Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
            ),
            //border: OutlineInputBorder(),
            labelText: "Password",
            hintText: "Enter Valid Password",
            icon: Icon(
              Icons.lock,
              color: Colors.grey,
              size: 18,
            )),
      ),
    );
  }

//5
  _showFormActions() {
    return Padding(
      padding: EdgeInsets.only(top: 20),
      child: Column(
        children: [
          _isSubmitting == true
              ? CircularProgressIndicator(
            valueColor:
            AlwaysStoppedAnimation(Theme.of(context).primaryColor),
          )
              : RaisedButton(
              child: Text(
                "Submit",
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              elevation: 8.0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10))),
              color: Colors.orange,
              onPressed: _submit),
        ],
      ),
    );
  }

//6
  _submit() {
    final _form = _formKey.currentState;
    if (_form.validate()) {
      _form.save();
      //print("Email $_email, Password $_password, Username $_username");
      _registerUser();
    } else {
      print("Form is Invalid");
    }
  }

//7
  _registerUser() async {
    setState(() {
      _isSubmitting = true;
    });

    final logMessage = await context
        .read<AuthenticationService>()
        .signUp(email: _email, password: _password);
    _showSuccessSnack();
    Navigator.push(
      context,
      PageTransition(
        type: PageTransitionType.rightToLeft,
        child: HomePage(),
      ),
    );

    print(logMessage);

    if (logMessage == "Signed Up") {
      createUserInFirestore();
    } else {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

//When User "Signed Up", success snack will display.
  _showSuccessSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        "Succesfull",
        style: TextStyle(color: Colors.green),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
    _formKey.currentState.reset();
  }

//When FirebaseAuth Catches error, error snack will display.
  _showErrorSnack() {
    final snackbar = SnackBar(
      backgroundColor: Colors.black,
      content: Text(
        "Failed",
        style: TextStyle(color: Colors.red),
      ),
    );
    _scaffoldKey.currentState.showSnackBar(snackbar);
  }

  createUserInFirestore() async {
    context.read<AuthenticationService>().addUserToDB(
        uid: auth.currentUser.uid,
        username: _username,
        email: auth.currentUser.email,
        timestamp: timestamp);
  }
}
