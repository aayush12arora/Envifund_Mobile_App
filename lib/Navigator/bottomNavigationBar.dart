
import 'package:envifund_moblie_application/DashBoard/dashBoard.dart';
import 'package:envifund_moblie_application/MakeNewProject/newProject.dart';
import 'package:envifund_moblie_application/MarketPlace/marketPlaceToInvest.dart';
import 'package:envifund_moblie_application/Profile/Profile.dart';
import 'package:envifund_moblie_application/auth/google_sign.dart';
import 'package:flutter/material.dart';



class BottomNavigation extends StatefulWidget {
  final int? passedindex;
  const BottomNavigation(this.passedindex);

  @override
  State<BottomNavigation> createState() => _BottomNavigationState();
}

class _BottomNavigationState extends State<BottomNavigation> {

  int _selectedIndex = 0;
  bool loading = false;
  @override
  void initState() {
    super.initState();
    // Set the initial selected index based on the passedindex or use 0 if not provided
    // setState(() {
    //   loading = true;
    // });

    loadscreens();
    _selectedIndex = widget.passedindex ?? 0;
  }

  void _onItemTapped(int index) {
    setState(() {
      // loading = true;
      _selectedIndex = index;

      loadscreens();
    });
  }

  // Future<void> loadData(String key) async {
  //   final prefs = await SharedPreferences.getInstance();
  // }

  List? screens = [];

  void loadscreens() {

    screens = [
      DashBoard(),
Invest(),
NewProject(),
      GoogleSignIn(),

    ProfilePage()

    ];

    // setState(() {
    //   loading = false;
    // });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: loading
          ? Center(
        child: Container(
          padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.1),
          child: const CircularProgressIndicator(color: Colors.white),
        ),
      )
          : Container(
        height: MediaQuery.of(context).size.height,
        child: screens?[_selectedIndex],
      ),
      bottomNavigationBar: Container(
          height: MediaQuery.sizeOf(context).height * 0.08,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Color(0xffebe7e7),
            borderRadius: BorderRadius.circular(15),
            //  border: Border.all(color: Colors.white54, width: 0.9)
          ),
          child: BottomNavigationBar(
            elevation: 1,

            iconSize: 25,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.grey[600],
            selectedItemColor:  Color.fromRGBO(2, 70, 104, 1),
            unselectedItemColor: Colors.white,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items:  [
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.dashboard,
                ),
                label: 'Dashboard',
              ),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.energy_savings_leaf,
                  ),
                  label: 'Invest'),
              BottomNavigationBarItem(
                icon: Icon(
                  Icons.add_rounded,
                ),
                label: 'Create',
              ),
              
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.chat_rounded,
                  ),
                  label: 'Chat'),
              BottomNavigationBarItem(
                  icon: Icon(
                    Icons.person,
                  ),
                  label: 'Profile'),
            ],
          )),
    );
  }
}
