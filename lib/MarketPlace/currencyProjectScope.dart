

import 'dart:convert';

import 'package:envifund_moblie_application/Modals/Project.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;
import '../Services/w3webServices.dart';

class CurrencyProjectDes extends StatefulWidget {
  final  int id;
  final Map<String,dynamic> project;
  const CurrencyProjectDes({super.key, required this.id, required this.project});

  @override
  State<CurrencyProjectDes> createState() => _CurrencyProjectDesState();
}

class _CurrencyProjectDesState extends State<CurrencyProjectDes> {
  List<dynamic>projectInvestors =[];
  final _razorpay = Razorpay();
  bool openList = false;
  TextEditingController amountController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectInvestors();
    _auth.authStateChanges().listen((User? user) {
      setState(() {
        this.user = user;
      });
    });
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _razorpay.clear(); // Removes all listeners
  }

  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment success: ${response.paymentId}');
    try {
      await sendInvestmentData(
        widget.project['project_id'],
        user!.email!,
        double.parse(amountController.text),
      );
    } catch (error) {
      print('Error sending investment data: $error');
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print('Payment error: ${response.code} - ${response.message}');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External wallet selected: ${response.walletName}');
  }

  Future<void> getProjectInvestors() async {
     String url = 'https://envifund.vercel.app/api/project/fetch-investors-in-a-project?project_id=${widget.project['project_id']}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch Investors');
      }

      final List<dynamic> data = json.decode(response.body);
      setState(() {
        projectInvestors = data ;
      });
      print(' investor data ${data}');

    } catch (error) {
      print('Error fetching Investors $error');
      // setState(() {
      //   currencyProjects = [];
      // });
    }
  }

  Future<void> sendInvestmentData( int projectId, String investorId, double amount) async {
    final url = Uri.parse('https://envifund.vercel.app/api/project/updates-in-funding');

    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'project_id': projectId,
        'investor_id': investorId,
        'amount': amount,
      }),
    );

    if (response.statusCode == 201) {
      print('Investment added successfully');
    } else {
      throw Exception('Failed to add investment');
    }
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(
                        widget.project['images'][0],),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.project['project_title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.project['description'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Project Location',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.project['location'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,

                            ),
                          ),
                          const SizedBox(height: 8),


                          Text(
                            ' Owner Email',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.project['project_lead_id'],
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Funding Goal:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            ' ₹ ${widget.project['funding_goal']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            'Current Balance:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                           ' ₹ ${widget.project['funding_amount']}',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),



                          const SizedBox(height: 20),
                          const Divider(),
                          const SizedBox(height: 20),
                          InkWell(
                            onTap: (){
                              // Navigate to investors page
                              setState(() {
                                openList= !openList;
                              });
                            },
                            child: Row(
                              children: [
                                Text(
                                  'Investors',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                openList?Icon(Icons.arrow_drop_up):  Icon(Icons.arrow_drop_down),
                              ],

                            ),
                          ),
                          openList?
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            child: ListView.builder(
                              itemCount: projectInvestors.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: Icon(Icons.label),
                                  title: Text(projectInvestors[index]['investor_id'],style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                                  subtitle:  Text(projectInvestors[index]['sum'].toString()),

                                );
                              },
                            ),
                          ):SizedBox.shrink(),
                          const SizedBox(height: 8),
                          TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                              hintText: 'Enter Amount in Rupees ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Center(
                            child: InkWell(
                              onTap: () async {
                                // Invest in project
                                var options = {
                                  'key': 'rzp_test_b7mMJWn7kaDMZ2',
                                  'amount': double.parse(amountController.text)*100, //in the smallest currency sub-unit.
                                  'name': 'Envifund', // Generate order_id using Orders API
                                  'description': widget.project['project_title'],
                                  'timeout': 60, // in seconds
                                  'prefill': {
                                    'contact': '9000090000',
                                    'email': widget.project['project_lead_id'],
                                  }
                                };
                                _razorpay.open(options);
                             },
                              child: Container(
                                height: 30,
                                width: 75,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    'Invest',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        ]
                    )
                )
              ],
            ),
          ),
        ),
      ),
    );

  }
  double convertToMatic(BigInt wei) {
    // Define conversion factor
    final BigInt conversionFactor = BigInt.from(10).pow(18); // 1 Matic = 10^18 Wei

    // Convert Wei to Matic
    double matic = wei.toDouble() / conversionFactor.toDouble();

    return matic;
  }
}

