import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:smart_stadium/utils/validator.dart';

class LogInPage extends StatefulWidget {

  LogInPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _LogInPageState createState() => _LogInPageState();
}

class _LogInPageState extends State<LogInPage> {

  String _email, _password;
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
                    padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
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
                              onSaved: (input) => _email = input,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                              validator: Validator().validateEmail,
                              decoration: InputDecoration(
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
                              onSaved: (input) => _password = input,
                              style: TextStyle(
                                color: Colors.amber,
                                fontSize: 18,
                              ),
                              obscureText: true,
                              validator: Validator().validatePassword,
                              decoration: InputDecoration(
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
                        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
                        child: Text('Log in',
                          style: TextStyle(
                            fontSize: 20,
                          ),),
                      ),
                      shape: const StadiumBorder(),
                      color: Theme.of(context).primaryColor,
                      textColor: Colors.white,
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
    );
  }

  Future<void> _logIn() async {
    final formState = _formKey.currentState;
    if (formState.validate())
    {
      try {
        formState.save();
        // FirebaseUser user;
        try {
          Toast.show('Log in button clicked', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          // user = await FirebaseAuth.instance.signInWithEmailAndPassword(email: _email, password: _password);
          // Toast.show('Logged in', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);
          // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(user: user)));
        } on Exception catch (e) {
          Toast.show('$e', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.CENTER);
        }
      }
      catch (e) {
        print(e.message);
      }
    }
  }

  void _pushSignUp() {

    Toast.show('Sign up button cicked', context, duration: Toast.LENGTH_SHORT, gravity:  Toast.BOTTOM);

    // Navigator.of(context).push(
    //     new MaterialPageRoute(builder: (BuildContext context) {
    //       return new Scaffold(
    //         body: SignUpPage(),
    //       );
    //     })
    // );
  }

}