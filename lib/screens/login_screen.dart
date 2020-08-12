import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/auth.dart';
import '../providers/news.dart';
import '../models/http_exception.dart';
import '../models/news_article.dart';

enum AuthMode { Signup, Login }

class LoginScreen extends StatefulWidget {
  static const routeName = '/login';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final Map<String, String> _fromData = {'email': null, 'password': null};

  var item;

  AnimationController _controller;
  Animation<double> _obacityAnimation;
  final GlobalKey<FormState> _formKey = GlobalKey();
  AuthMode _authMode = AuthMode.Login;
  Map<String, String> _authData = {
    'email': '',
    'password': '',
  };

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );
    // _heightAnimation = Tween<Size>(
    //         begin: Size(double.infinity, 260), end: Size(double.infinity, 320))
    //     .animate(CurvedAnimation(
    //   parent: _controller,
    //   curve: Curves.linear,
    // ));
    _obacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    //_heightAnimation.addListener(() => setState((){}));
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error Message'),
        content: Text(message),
        actions: <Widget>[
          FlatButton(
            child: Text('Okay'),
            onPressed: () => Navigator.of(ctx).pop(),
          )
        ],
      ),
    );
  }

  var _isLoading = false;
  final _passwordController = TextEditingController();

  Future<void> _submit() async {
    if (!_formKey.currentState.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState.save();
    setState(() {
      _isLoading = true;
    });
    try {
      if (_authMode == AuthMode.Login) {
        // Log user in
        await Provider.of<Auth>(context, listen: false)
            .signin(_authData['email'], _authData['password']);
        await item.setSavedStatusToTrue(item.id, Auth.token, Auth.userId);
        await Provider.of<News>(context, listen: false).getRecentNews();

        final pref = await SharedPreferences.getInstance();
        final userData = json.encode({
          'Email': _authData['email'],
          'Password': _authData['password'],
        });
        pref.setString('userLoginData', userData);

        Navigator.of(context).pop();
      } else {
        // Sign user up
        await Provider.of<Auth>(context, listen: false)
            .signup(_authData['email'], _authData['password']);

        final pref = await SharedPreferences.getInstance();
        final userData = json.encode({
          'Email': _authData['email'],
          'Password': _authData['password'],
        });
        pref.setString('userLoginData', userData);

        Navigator.of(context).pop('done');
      }
    } on HttpException catch (error) {
      var errorMessage = 'Unable to authenticate!';
      if (error.toString().contains('INVALID_EMAIL')) {
        errorMessage = 'This is an invalid email!';
      } else if (error.toString().contains('INVALID_PASSWORD')) {
        errorMessage = 'This is an invalid password!';
      } else if (error.toString().contains('EMAIL_NOT_FOUND')) {
        errorMessage = 'Email is not found!';
      } else if (error.toString().contains('EMAIL_EXISTS')) {
        errorMessage = 'This Email is already token!';
      }
      _showErrorDialog(errorMessage);
    } //catch(error){
    //   const errorMessage = 'An error has occured, please try again!';
    //   _showErrorDialog(errorMessage);
    // }

    setState(() {
      _isLoading = false;
    });
    //Navigator.of(context).pop();
  }

  void _switchAuthMode() {
    if (_authMode == AuthMode.Login) {
      setState(() {
        _authMode = AuthMode.Signup;
      });
      _controller.forward();
    } else {
      setState(() {
        _authMode = AuthMode.Login;
      });
      _controller.reverse();
    }
  }

  Widget _buildEmailTextField() {
    return TextFormField(
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty || !value.contains('@')) {
            return 'Invalid email!';
          }
          return null;
        },
        onSaved: (value) async {
          _authData['email'] = value;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.email,
              color: Colors.black,
            ),
            hintText: 'Email',
            hintStyle:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide:
                  BorderSide(width: 2, color: Theme.of(context).accentColor),
            )));
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
        obscureText: true,
        controller: _passwordController,
        validator: (value) {
          if (value.isEmpty || value.length < 5) {
            return 'Password is too short!';
          }
          return null;
        },
        onSaved: (value) {
          _authData['password'] = value;
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.black,
            ),
            hintText: 'Password',
            hintStyle:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.bold),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(
                width: 2,
                color: Theme.of(context).accentColor,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide:
                  BorderSide(width: 2, color: Theme.of(context).accentColor),
            )));
  }

  Widget _buildLoginButton() {
    return FlatButton(
        child: CircleAvatar(
          radius: 50,
          backgroundColor: Theme.of(context).accentColor,
          child: Text('LOGIN',
              style: TextStyle(
                  color: Theme.of(context).primaryColor,
                  fontFamily: 'Raleway',
                  fontWeight: FontWeight.bold,
                  fontSize: 20)),
        ),
        onPressed: () {
          _submit();
        });
  }

  @override
  Widget build(BuildContext context) {
    item = ModalRoute.of(context).settings.arguments as NewsArticle;
    return Scaffold(
      // resizeToAvoidBottomPadding: false ,
      body: Column(
        // crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 120, right: 120, top: 80),
            child: Image.asset(
              'assets/images/logo.jpg',
              scale: 1.50,
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: Container(
                      margin: const EdgeInsets.all(30),
                    child:  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    
                    padding: EdgeInsets.all(16.0),

                    child: Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            _buildEmailTextField(),
                            SizedBox(height: 15),
                            _buildPasswordTextField(),
                            SizedBox(height: 15),
                            AnimatedContainer(
                              duration: Duration(milliseconds: 500),
                              // constraints: BoxConstraints(
                              //     minHeight: _authMode == AuthMode.Signup ? 60 : 0,
                              //     maxHeight: _authMode == AuthMode.Signup ? 120 : 0),
                              child: FadeTransition(
                                opacity: _obacityAnimation,
                                child: TextFormField(
                                  enabled: _authMode == AuthMode.Signup,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        color: Colors.black,
                                      ),
                                      hintText: 'Confirm Password',
                                      hintStyle: TextStyle(
                                          color: Colors.black87,
                                          fontWeight: FontWeight.bold),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                          width: 2,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20.0)),
                                        borderSide: BorderSide(
                                            width: 2,
                                            color:
                                                Theme.of(context).accentColor),
                                      )),
                                  obscureText: true,
                                  validator: _authMode == AuthMode.Signup
                                      ? (value) {
                                          if (value !=
                                              _passwordController.text) {
                                            return 'Passwords do not match!';
                                          }
                                          return null;
                                        }
                                      : null,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            _isLoading
                                ? CircularProgressIndicator()
                                : _buildLoginButton(),
                            SizedBox(height: 10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Don\'t have an accocunt? ',
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontFamily: 'Raleway',
                                        // fontWeight: FontWeight.bold,
                                        fontSize: 15)),
                                InkWell(
                                  onTap: _switchAuthMode,
                                  child: Text(
                                    '${_authMode == AuthMode.Login ? 'SIGNUP' : 'LOGIN'} INSTEAD',
                                    style: TextStyle(
                                        color: Theme.of(context).accentColor,
                                        fontFamily: 'Raleway',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            )
                          ],
                        )),
                  ),),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
