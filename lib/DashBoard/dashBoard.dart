import 'dart:convert';
import 'package:envifund_moblie_application/DashBoard/ConnectionButton.dart';
import 'package:envifund_moblie_application/Services/w3webServices.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:web3modal_flutter/widgets/w3m_connect_wallet_button.dart';
import '../main.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _DashBoardState();
}

class _DashBoardState extends State<DashBoard> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  int projects = 0;
  int totalMoneyRaised = 0;
  int investments = 0;
  int totalMoneyInvested = 0;
  bool loading = false;
  bool connected = false;




  @override
  void initState() {
    super.initState();
   // _initializeWeb3Services();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
        print(user);
        getDashBoardDetails();
      });
    });
    Web3Services.w3mService.addListener(_updateState);
    //TODO: Fetch dashboard details when widget is created
  }



  void getDashBoardDetails() async {
    setState(() {
      loading = true;
    });
    final String url = 'https://envifund.vercel.app/api/project/fetch-dashboard-details';
    print('email ${user?.email}');
    final response = await http.get(Uri.parse('$url?investor_id=${user?.email}'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data.isNotEmpty) {
        print(data);
        setState(() {
          projects = data['totalProjects'];
          totalMoneyRaised = data['totalAmountRaised'];
          investments = data['totalInvestments'];
          totalMoneyInvested = data['totalInvestedAmount'];
        });
      }

    } else {
      throw Exception('Failed to load data');
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: linearGradient),
        child: loading
            ? Center(
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: const CircularProgressIndicator(color: Colors.white),
          ),
        )
            : Column(
          children: [
            SizedBox(height: height * 0.1),
            Center(
              child: Text("DashBoard", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
            ),
            SizedBox(height: height * 0.03),
            Text("Welcome to DashBoard", style: TextStyle(color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(height: height * 0.06),
            Text("Projects", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
            RunningNumbersAnimation(value: projects),
            SizedBox(height: height * 0.04),
            Text("Total Money Raised", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
            RunningNumbersAnimation(value: totalMoneyRaised),
            SizedBox(height: height * 0.04),
            Text("Investments", style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w600)),
            RunningNumbersAnimation(value: investments),
            SizedBox(height: height * 0.04),
            Text("Total Money Invested", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600)),
            RunningNumbersAnimation(value: totalMoneyInvested),
            SizedBox(height: height * 0.029),
          W3MConnectWalletButton(service: Web3Services.w3mService),
SizedBox(height: height * 0.029),
            walletConnect(height)
          ],
        ),
      ),
    );
  }

  void handleWalletLogin() {
    // Implement wallet login logic
  }

  Widget walletConnect(double height) {
    return InkWell(
onTap: (){
  if(connected){
    Web3Services().getAllInvestmentsByOwner();
  }
},
      child: Container(
        height: height * 0.051,
        color: connected ? Colors.green : Colors.red,
        child: Center(
          child: Text(
            connected ? "Connected ${Web3Services.address}" : "Click to connect your wallet",
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );

  }

  void _updateState() {
    if(Web3Services.w3mService.isConnected){
      setState(() {
        connected = true;
      });
    }
    else{
      setState(() {
        connected = false;
      });
    }

  }
}




  class RunningNumbersAnimation extends StatefulWidget {
  final int value;

  const RunningNumbersAnimation({required this.value, Key? key}) : super(key: key);

  @override
  _RunningNumbersAnimationState createState() => _RunningNumbersAnimationState();
}

class _RunningNumbersAnimationState extends State<RunningNumbersAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<int> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2), // Animation duration
      vsync: this,
    );

    _animation = IntTween(begin: 0, end: widget.value).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    )..addListener(() {
      setState(() {}); // Trigger rebuild when animation value changes
    });

    _controller.forward(); // Start the animation
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      '${_animation.value}', // Display the current animated value
      style: TextStyle(fontSize: 20.0, color: Colors.white),
    );
  }

  @override
  void dispose() {
    _controller.dispose(); // Clean up the animation controller
    super.dispose();
  }
}
