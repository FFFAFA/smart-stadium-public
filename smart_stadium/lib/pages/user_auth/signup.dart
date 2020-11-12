import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:smart_stadium/utils/validator.dart';

import '../home.dart';

class SignUpPage extends StatefulWidget {

  SignUpPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {

  TextEditingController _emailController = new TextEditingController();
  TextEditingController _passwordController = new TextEditingController();
  TextEditingController _confirmPasswordController = new TextEditingController();
  TextEditingController _usernameController = new TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
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

                        // Username
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _usernameController,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                              ),
                              validator: Validator().validateUsername,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).hintColor)
                                ),
                                hintText: 'Username',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 14,
                                  color:Colors.redAccent,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Email
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _emailController,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                              ),
                              validator: Validator().validateEmail,
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).hintColor)
                                ),
                                hintText: 'E-mail',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color: Theme.of(context).hintColor,
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 14,
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
                                fontSize: 16,
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
                                  fontSize: 14,
                                  color:Colors.redAccent,
                                ),
                                hintText: 'Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
                                  color:Theme.of(context).hintColor,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // Confirm Password
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 300,
                            child: TextFormField(
                              controller: _confirmPasswordController,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 16,
                              ),
                              obscureText: !showConfirmPassword,
                              validator: (value){
                                if(value.isEmpty){
                                  return "Please confirm your password";
                                } else if (value != _passwordController.text){
                                  return "Inconsistent passwords";
                                }
                                  return null;
                              },
                              decoration: InputDecoration(
                                enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Theme.of(context).hintColor)
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(showConfirmPassword ? Icons.visibility_off : Icons.visibility, color: Theme.of(context).hintColor),
                                  onPressed: (){
                                    setState(() {
                                      showConfirmPassword = !showConfirmPassword;
                                    });
                                  },
                                ),
                                errorStyle: TextStyle(
                                  fontSize: 14,
                                  color:Colors.redAccent,
                                ),
                                hintText: 'Confirm Password',
                                hintStyle: TextStyle(
                                  fontSize: 16,
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

                // Sign-up button
                Container(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: RaisedButton(
                      onPressed: _SignUp,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15),
                        child: Text('Sign up',
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

                // Return to log in button
                FlatButton(
                  onPressed: (){Navigator.of(context).pop();},
                  child: Text(
                    'Already have an account? Click to log in',
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
    );
  }

  Future<void> _SignUp() async {
    final formState = _formKey.currentState;
    if (formState.validate())
    {
      try {
        formState.save();
        try {
          UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
              email: _emailController.text,
              password: _passwordController.text
          );
          Toast.show('Automatically logged in', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          Navigator.of(context).pop();
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
        } on FirebaseAuthException catch (e) {
          if (e.code == 'email-already-in-use'){
            Toast.show('The account exists for that email', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          } else {
            print(e.message);
            Toast.show('$e', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
          }
        }
      }
      catch (e) {
        print(e.message);
      }
    }
  }


}