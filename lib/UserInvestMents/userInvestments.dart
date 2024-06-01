
import 'dart:convert';
import 'dart:math';
import 'package:envifund_moblie_application/UserInvestMents/userInvestmentCurrDes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:envifund_moblie_application/Services/w3webServices.dart';
import 'package:envifund_moblie_application/UserInvestMents/userInvestmentDes.dart';
import 'package:envifund_moblie_application/UserProjects/userProjectDes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

import '../Modals/Investments.dart';


class UserInvestmentsPage extends StatefulWidget {
  final String email;
  const UserInvestmentsPage({super.key, required this.email});

  @override
  State<UserInvestmentsPage> createState() => _UserInvestmentsPageState();
}

class _UserInvestmentsPageState extends State<UserInvestmentsPage> with TickerProviderStateMixin  {
  List<Investment> investments = [];
  List<dynamic> currencyInvestments = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  late final TabController _tabController;
  bool loading = false;
  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    // _auth.authStateChanges().listen((User? user) {
    //   setState(() {
    //     this.user = user;
    //   });
    // });
    _tabController = TabController(length: 2, vsync: this);
    setState(() {
      loading = true;
    });


    getData();
    fetchInvestments();
    setState(() {
      loading = false;
    });
  }


  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    List data = await Web3Services().getAllInvestmentsByOwner();

    // Check if data is null or empty
    if (data.isEmpty) {
      setState(() {
        loading = false;
      });
      return ;
    }

    List<Investment> updatedInvestments = [];
    for (var sublist in data) {
      if (sublist == null) continue; // Check if sublist is null
      for (var investmentData in sublist) {
        if (investmentData == null) continue; // Check if investmentData is null
        updatedInvestments.add(Investment.fromList(investmentData));
      }
    }
    setState(() {
      investments = updatedInvestments;
      loading = false;
    });
    return ;
  }

  Future<void> fetchInvestments() async {

    print("email for investments ${widget.email}");
String url = 'https://envifund.vercel.app/api/project/fetch-investments-done-by-user?investor_id=${widget.email}';
  //String url = 'https://envifund.vercel.app/api/project/fetch-investments-done-by-user?investor_id=${user?.email!}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch projects');
      }

      final List<dynamic> data = json.decode(response.body);
      print("data for investments $data");
      setState(() {
        currencyInvestments = data;
      });
    } catch (error) {
      print('Error fetching projects: $error');
      setState(() {
        currencyInvestments = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('User Investments'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Crypto Investments'),
           Tab(text: 'Normal Currency Investments'),
          ],
        ),
      ),
      body:  loading
          ? Center(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: const CircularProgressIndicator(color: Colors.black),
        ),
      )
          :TabBarView(
        controller: _tabController,
            children: [
              Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 0.8,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: investments.length,
              itemBuilder: (context, index) {
                final investment = investments[index];
                return InkWell(
                  onTap: (){

                    Navigator.push(context, MaterialPageRoute(builder: (context)=> InvestmentDes(investment: investment)));
                  },
                  child: InvestmentCard(
                    title: investment.title,
                      percentage: convertToMatic(investment.goalAmount.toInt()) / investment.goalAmount.toDouble(),

                      goal: investment.goalAmount.toString(),
                    location: investment.location,
                    owner: investment.owner
                  ),
                );
              },
                      ),
                    ),



              Padding(
                padding: const EdgeInsets.all(16.0),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 1,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: currencyInvestments.length,
                  itemBuilder: (context, index) {
                    final investment = currencyInvestments[index];
                    return InkWell(
                      onTap: (){

                        Navigator.push(context, MaterialPageRoute(builder: (context)=> CurrencyInvestmentDes(investment: investment, email: widget.email,)));
                      },
                      child: InvestmentCard(
                          title: investment['project_details']['project_title'],
                          percentage: investment['project_details']['funding_amount'] / investment['project_details']['funding_goal'] ,

                          goal: investment['project_details']['funding_goal'].toString(),
                          location: investment['project_details']['location'],
                          owner:investment['project_details']['project_lead_id']
                      ),
                    );
                  },
                ),
              ),


            ],
          ),
    );
  }

  double convertToMatic(int wei) {
    // Define conversion factor
    final BigInt conversionFactor = BigInt.from(10).pow(18); // 1 Matic = 10^18 Wei

    // Convert Wei to Matic
    double matic = wei.toDouble() / conversionFactor.toDouble();

    return matic;
  }


}



class InvestmentCard extends StatelessWidget {
  final String title;
  final double percentage;
  final String goal;
  final String location;
  final String owner;

  const InvestmentCard({
    required this.title,
    required this.percentage,
    required this.goal,
    required this.location,
    required this.owner,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Center(
            //   child: CircularPercentIndicator(
            //     radius: 50.0,
            //     lineWidth: 10.0,
            //     percent: percentage,
            //     center: Text(
            //       '${(percentage * 100).toInt()}%',
            //       style: const TextStyle(
            //         fontSize: 16,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.black,
            //       ),
            //     ),
            //     progressColor: Colors.blue,
            //   ),
            // ),
            const SizedBox(height: 10),
            Text(
              'Goal: $goal',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Location: $location',
              style: const TextStyle(fontSize: 14),
            ),
            Text(
              'Owner: $owner',
              style: const TextStyle(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

