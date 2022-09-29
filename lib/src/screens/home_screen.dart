import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:noted_app/src/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isBeingPressed = false;

  bool isNotesEmpty = false; // IMPLEMENT SHARED PREFERENCES

  String? username;

  void loadPrefs() async {
    SharedPreferences userInfo = await SharedPreferences.getInstance(); 
    setState(() {
      username = userInfo.getString('username');
    });
  }

  @override
  void initState() {
    loadPrefs();
    // delay initialization to fetch the data
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: clrBG,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: SvgPicture.asset('assets/images/app-ui/app-logo-h.svg'),
        centerTitle: true,
      ),
      floatingActionButton: GestureDetector(
        onTap: () { print('Added note'); },
        onTapDown: ((details) => setState(() {
          isBeingPressed = true;
        }) ),
        onTapUp: ((details) => setState(() {
          isBeingPressed = false;
        })),
        child: Container(
          width: 48.0,
          height: 48.0,
          margin: const EdgeInsets.only(
            right: 8.0,
            bottom: 8.0
          ),
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: isBeingPressed ? clrLIGHTERBLACK : clrLIGHTBLACK,
            border: Border.all(width: 1.0, color: clrWHITE),
            borderRadius: BorderRadius.circular(4.0)
          ),
          child: SvgPicture.asset(
            'assets/images/app-ui/icon-add.svg',
            color: clrWHITE
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: isNotesEmpty 
            ? MainAxisAlignment.center 
            : MainAxisAlignment.start,
          children: [
            !isNotesEmpty ? ListView(
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                const SizedBox(height: 24.0),
                Text(
                  "NOTES ARE HERE",
                  style: TextStyle(
                    color: clrWHITE
                  )
                )
              ],
            ) : Center(
              child: Column(
                children: <Widget>[
                  SvgPicture.asset('assets/images/app-ui/no-notes.svg'),
                  const SizedBox(height: 32.0),
                  Text(
                    "Your saved notes will appear here",
                    style: TextStyle(
                      color: clrDARKGREY,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  const SizedBox(height: 96.0)
                ]
              ),
            ),
          ],
        )
      )
    );
  }
}