import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/authentication_service.dart';
import '../firebase/user.dart';

class LoginRegister extends StatefulWidget {
  @override
  _LoginRegisterState createState() => _LoginRegisterState();
}

class _LoginRegisterState extends State<LoginRegister> {
  OurUser _currentUser = OurUser();
  String _password;

  bool signUp = false;

  @override
  Widget build(BuildContext context) {
    if (signUp)
      return _signUp();
    else
      return _signIn();
  }

  Widget _signUp() {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue[300],
                      Colors.indigo[600],
                      Colors.purple[900],
                    ],
                  ),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.height / 10.1,
                      color: Colors.blue[200],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 28.43,
                          right: MediaQuery.of(context).size.height / 28.43),
                      child: Text(
                        'Sign Up',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height / 50.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 14.7),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20.2,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 227.5,
                        left: MediaQuery.of(context).size.height / 56.875,
                        right: 56.875,
                        bottom: MediaQuery.of(context).size.height / 227.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (String value) =>
                          _currentUser.fullName = value.trim(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Full Name',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20.2,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 227.5,
                        left: MediaQuery.of(context).size.height / 56.875,
                        right: 56.875,
                        bottom: MediaQuery.of(context).size.height / 227.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (String value) => _currentUser.email = value.trim(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20.2,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 227.5,
                        left: MediaQuery.of(context).size.height / 56.875,
                        right: 56.875,
                        bottom: MediaQuery.of(context).size.height / 227.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextField(
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (String value) => _password = value,
                      obscureText: true,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  InkWell(
                    onTap: () {
                      context
                          .read<AuthenticationService>()
                          .signUp(user: _currentUser, password: _password);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 20.2,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[300],
                              Colors.indigo[600],
                              Colors.purple[900],
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Sign Up'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Have an account? "),
                  Text(
                    "Login",
                    style: TextStyle(color: Color(0xff6bceff)),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  signUp = false;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _signIn() {
    return Scaffold(
      body: Container(
        child: ListView(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3.5,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.blue[300],
                      Colors.indigo[600],
                      Colors.purple[900],
                    ],
                  ),
                  borderRadius:
                      BorderRadius.only(bottomLeft: Radius.circular(90))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Spacer(),
                  Align(
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person,
                      size: MediaQuery.of(context).size.height / 10.1,
                      color: Colors.blue[200],
                    ),
                  ),
                  Spacer(),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height / 28.44,
                          right: MediaQuery.of(context).size.height / 28.44),
                      child: Text(
                        'Login',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize:
                                MediaQuery.of(context).size.height / 50.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 14.68),
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20.2,
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 227.5,
                        left: MediaQuery.of(context).size.height / 56.875,
                        right: 56.875,
                        bottom: MediaQuery.of(context).size.height / 227.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      onChanged: (String value) => _currentUser.email = value.trim(),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.person,
                          color: Colors.indigo[600],
                        ),
                        hintText: 'Email',
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width / 1.2,
                    height: MediaQuery.of(context).size.height / 20.2,
                    margin: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 28.44),
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 227.5,
                        left: MediaQuery.of(context).size.height / 56.875,
                        right: 56.875,
                        bottom: MediaQuery.of(context).size.height / 227.5),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 5)
                        ]),
                    child: TextFormField(
                      enableSuggestions: false,
                      autocorrect: false,
                      obscureText: true,
                      onChanged: (String value) => _password = value,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.vpn_key,
                          color: Colors.indigo[600],
                        ),
                        hintText: 'Password',
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 56.875,
                          right: MediaQuery.of(context).size.height / 28.44),
                      child: Text(
                        'Forgot Password ?',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                  Spacer(),
                  InkWell(
                    onTap: () {
                      context
                          .read<AuthenticationService>()
                          .signIn(user: _currentUser, password: _password);
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height / 20.2,
                      width: MediaQuery.of(context).size.width / 1.2,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.blue[300],
                              Colors.indigo[600],
                              Colors.purple[900],
                            ],
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(50))),
                      child: Center(
                        child: Text(
                          'Login'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            InkWell(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text("Don't have an account? "),
                  Text(
                    "Sign Up",
                    style: TextStyle(color: Color(0xff6bceff)),
                  ),
                ],
              ),
              onTap: () {
                setState(() {
                  signUp = true;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
