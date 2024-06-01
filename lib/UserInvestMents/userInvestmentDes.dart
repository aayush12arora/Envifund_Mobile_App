

import 'package:envifund_moblie_application/Modals/Investments.dart';
import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

import '../ProjectUpdates/projectUpdates.dart';
import '../Services/w3webServices.dart';

class InvestmentDes extends StatefulWidget {
  final Investment investment;
  const InvestmentDes({super.key, required this.investment});

  @override
  State<InvestmentDes> createState() => _InvestmentDesState();
}

class _InvestmentDesState extends State<InvestmentDes> {

  List<String>projectInvestors =[];
  bool openList = false;
  TextEditingController amountController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getProjectInvestors();
  }

  void getProjectInvestors() async {
    // Get project investors
    List investors = await Web3Services().getAllInvestorsByProjectId(widget.investment.id);
    print(investors);
    // Check if investors is null or empty
    if (investors.isEmpty) {
      return ;
    }
    //
    // // Update project investors
    List<String> updatedInvestors = [];
    for (var sublist in investors) {
      if (sublist == null) continue; // Check if sublist is null
      for (var investorslistData in sublist) {
        if (investorslistData  == null) continue;
        // Check if investmentData is null
        updatedInvestors.add((investorslistData as EthereumAddress).hex);
      }
    }
    setState(() {
      projectInvestors = updatedInvestors ;
    });
    return ;
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
                        widget.investment.imageUrl,),
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
                            widget.investment.title,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.investment.description,
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
                            widget.investment.location,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,

                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Project Owner',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            widget.investment.owner,
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
                            widget.investment.contactEmail,
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
                            '${widget.investment.goalAmount.toString()} MATIC',
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
                            '${convertToMatic(widget.investment.amountRaised).toString()} MATIC',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),

                          Text(
                            'Locked Funds:',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${widget.investment.lockedAmount} MATIC',
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
                                  title: Text(projectInvestors[index]),

                                );
                              },
                            ),
                          ):SizedBox.shrink(),

                          const SizedBox(height: 20),
                          const Divider(),
                          InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectUpdates( ProjectId:  widget.investment.id,)));
                            },
                            child: Container(
                              height: 50,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(width: MediaQuery.of(context).size.width*0.1,),
                                  Text(
                                    'See Updates',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: MediaQuery.of(context).size.width*0.47,),
                                  Icon(Icons.arrow_forward_ios, color: Colors.white,)
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: amountController,
                            decoration: InputDecoration(
                              hintText: 'Enter Amount in Matic ',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Center(
                            child: InkWell(
                              onTap: () async {
                                // Invest in project
                                await Web3Services().fundProject(widget.investment.id, double.parse(amountController.text));
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
                          const SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children:[
                            InkWell(
                              onTap: () async {
                                // Invest in project
                                await Web3Services().withdrawInvestment(widget.investment.id);
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    'Withdraw',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () async {
                                // Invest in project
                                await Web3Services().releaseLockedFunds(widget.investment.id);
                              },
                              child: Container(
                                height: 50,
                                width: MediaQuery.of(context).size.width*0.3,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Center(
                                  child: Text(
                                    'Release',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ]
                        ),

                          const SizedBox(height: 40),

                          Text('Warning: Withdrawing or releasing '
                              'funds will have permanent effects on the project. '
                              'Please make sure before proceeding.',style: TextStyle(
                            color: Colors.red,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),)
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
