import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:smart_stadium/utils/validator.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../home.dart';

class LogInPage extends StatefulWidget {

  LogInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: ListView(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[

                // Logo
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50.0, bottom: 50.0),
                    child: Image.asset(
                      'assets/images/stadium_icon.png',
                      width: 150,
                      height: 150,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                Container(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        // Email
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                              validator: Validator().validateEmail,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).hintColor)
                                ),
                                hintText: 'E-mail',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color: Theme.of(context).hintColor,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  color:Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _passwordController,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                              obscureText: !showPassword,
                              validator: Validator().validatePassword,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).hintColor)
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor),
                                  onPressed: (){
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 15,
                                  color:Colors.redAccent,
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 18,
                                  color:Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Log-in button
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: RaisedButton(
                      onPressed: _logIn,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: Text('Log in',
                          style: TextStyle(
                            fontSize: 18,
                          ),),
                      ),
                      shape: const StadiumBorder(),
                      color: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).backgroundColor,
                      splashColor: Colors.amberAccent,
                    ),
                  ),
                ),

                // Sign-up button
                FlatButton(
                  onPressed: _pushSignUp,
                  child: Text(
                    'No account yet? Click to sign up',
                    style: TextStyle(
                      decoration: TextDecoration.underline,
                      color: Theme.of(context).hintColor,
                    ),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    ),
    );
  }

  Future<void> _logIn() async {
    final formState = _formKey.currentState;
    if (formState.validate())
    {
      try {
        formState.save();
        try {
          UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text
          );
          Toast.show('Logged in', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'user-not-found'){
            Toast.show('No user found for that email', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          } else if (e.code == 'wrong-password'){
            Toast.show('Wrong password', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          } else {
            Toast.show('$e', context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
          }
        }
      }
      catch (e) {
        print(e.message);
      }
    }
  }

  void _pushSignUp() {

    Navigator.of(context).pushNamed('/signup');
  }

}