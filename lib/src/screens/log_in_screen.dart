import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noted_app/src/utils/colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  late String _username = '';
  late String _email = '';
  bool validFields = false;
  bool validEmail = false;
  bool isEmailFocused = false;
  RegExp emailReg = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");

  _transitionToHome() {
    Navigator.of(context).pushReplacementNamed("home");
  }

  _checkUsername(value) {
    _username = value.trim();
    _verifyFields();
  }

  _checkEmail(value) {
    _email = value.trim();
    if(_email.trim().isNotEmpty && emailReg.hasMatch(_email)) {
      setState(() {
        validEmail = true;
      });
    } else {
      setState(() {
        validEmail = false;
      });
    }
    _verifyFields();
  }

  _verifyFields() {
    if(validEmail && _username.isNotEmpty) {
      setState(() {
        validFields = true;
      });
    } else {
      setState(() {
        validFields = false;
      });      
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBG,
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 25.0),
          child: Text(
            "Your data is saved to your device", 
            style: TextStyle(
              color: clrLIGHTGREY,
              fontFamily: 'Inter',
              fontWeight: FontWeight.w500,
              fontSize: 13.0
            ),
            textAlign: TextAlign.center
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SafeArea(
          child: ScrollConfiguration(
            behavior: const ScrollBehavior(),
            child: ListView(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.asset(
                      'assets/images/app-ui/app-logo-h.svg',
                      width: 116.0,
                    ),
                    SvgPicture.asset(
                      'assets/images/app-ui/arrow-r.svg',
                      color: validFields ? clrWHITE : clrWHITE.withOpacity(0.6),
                    )
                  ],
                ),
                const SizedBox(height: 56.0),
                // TEXT FIELD: USERNAME
                TextField(
                  onChanged: (value) {
                    _checkUsername(value);
                  },
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  style: TextStyle(
                    color: clrWHITE,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                  cursorColor: clrWHITE,
                  decoration: InputDecoration(
                    hintText: "Your username",
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: clrLIGHTGREY
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0
                    ),
                    filled: true,
                    fillColor: clrLIGHTBLACK,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: clrLIGHTGREY.withOpacity(0.8)
                      ),
                      borderRadius: BorderRadius.circular(3.0)
                    ) ,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: clrWHITE
                      ),
                      borderRadius: BorderRadius.circular(3.0)
                    ) ,
                  ),
                ),
                const SizedBox(height: 16.0),
                // TEXT FIELD: EMAIL
                TextField(
                  onChanged: (value) {
                    _checkEmail(value);
                  },
                  onEditingComplete: () {
                    setState(() {
                      isEmailFocused = true;
                    });
                  },
                  cursorColor: clrWHITE,
                  keyboardType: TextInputType.name,
                  autofocus: true,
                  style: TextStyle(
                    color: clrWHITE,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                  decoration: InputDecoration(
                    hintText: "Your email address",
                    hintStyle: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                      color: clrLIGHTGREY
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 20.0
                    ),
                    filled: true,
                    fillColor: clrLIGHTBLACK,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: clrLIGHTGREY.withOpacity(0.8)
                      ),
                      borderRadius: BorderRadius.circular(3.0)
                    ) ,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: validEmail 
                          ? clrWHITE 
                          : isEmailFocused
                            ? clrYELLOW
                            : clrWHITE
                      ),
                      borderRadius: BorderRadius.circular(3.0)
                    ) ,
                  ),
                ),
                const SizedBox(height: 5.0),
                // EMAIL WARNING MESSAGE
                Text(
                  validEmail
                    ? '' 
                    : isEmailFocused 
                      ? "That email address may not be valid" 
                      : ''
                    ,
                  style: TextStyle(
                    color: clrYELLOW,
                    fontSize: 10.0
                  )
                ),
                const SizedBox(height: 32.0),
                // LOG IN BUTTON
                TextButton(
                  onPressed: validFields ? ()  async { 
                    SharedPreferences userInfo = await SharedPreferences.getInstance();
                    userInfo.setBool('isLoggedIn', true);
                    userInfo.setString('username', _username);
                    userInfo.setString('email', _email);
                    _transitionToHome();
                  } : null, 
                  style: ButtonStyle(
                    backgroundColor: MaterialStateColor.resolveWith(
                      (states) => validFields 
                        ? clrWHITE
                        : clrLIGHTBLACK
                    ),
                    overlayColor: MaterialStateColor.resolveWith(
                      (states) => Colors.transparent
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(3.0)
                      )
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: validFields
                          ? clrBG
                          : clrWHITE,
                        fontWeight: FontWeight.w800,
                        fontSize: 16.0
                      ),
                    ),
                  )
                )
              ],
            ),
          ),
        ),
      )
    );
  }
}