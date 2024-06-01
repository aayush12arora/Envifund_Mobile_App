

import 'dart:convert';

import 'package:envifund_moblie_application/Modals/Investments.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';
import 'package:http/http.dart' as http;
import '../ProjectUpdates/projectUpdates.dart';
import '../Services/w3webServices.dart';

class CurrencyInvestmentDes extends StatefulWidget {
  final Map<String,dynamic>investment;
  final String email;
  const CurrencyInvestmentDes({super.key, required this.investment, required this.email});

  @override
  State<CurrencyInvestmentDes> createState() => _CurrencyInvestmentDesState();
}

class _CurrencyInvestmentDesState extends State<CurrencyInvestmentDes> {

  List<dynamic>projectInvestors =[];
  bool openList = false;
  final _razorpay = Razorpay();
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectInvestors();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }


  Future<void> _handlePaymentSuccess(PaymentSuccessResponse response) async {
    print('Payment success: ${response.paymentId}');
    try {
      await sendInvestmentData(
        widget.investment['project_details']['project_id'],
      widget.email,
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

  Future<void> getProjectInvestors() async {
    String url = 'https://envifund.vercel.app/api/project/fetch-investors-in-a-project?project_id=${widget.investment['project_id']}';

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
                        widget.investment['project_details']['images'][0],),
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
                    widget.investment['project_details']['project_title'],
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.investment['project_details']['description'],
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
                            widget.investment['project_details']['location'],
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
                            widget.investment['project_details']['project_lead_id'],
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
                            ' ₹ ${ widget.investment['project_details']['funding_goal']}',
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
                            ' ₹ ${ widget.investment['project_details']['funding_amount']}',
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
                                  title: Text(projectInvestors[index]['investor_id']),
                                  subtitle: Text('₹ ${projectInvestors[index]['sum']}'),

                                );
                              },
                            ),
                          ):SizedBox.shrink(),

                          const SizedBox(height: 20),

                          const SizedBox(height: 8),
                          TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                              hintText: 'Enter Amount in Rupees ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: InkWell(
                              onTap: () async {
                                // Invest in project
                                var options = {
                                  'key': 'rzp_test_b7mMJWn7kaDMZ2',
                                  'amount': double.parse(amountController.text)*100, //in the smallest currency sub-unit.
                                  'name': 'Envifund', // Generate order_id using Orders API
                                  'description': widget.investment['project_details']['project_title'],
                                  'timeout': 60, // in seconds
                                  'prefill': {
                                    'contact': '8888888888',
                                    'email': widget.investment['project_details']['project_lead_id']
                                  }
                                };
                                _razorpay.open(options);
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width,
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
// widhraw and release


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
