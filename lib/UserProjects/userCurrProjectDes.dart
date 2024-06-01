//
//
// import 'package:envifund_moblie_application/Modals/Project.dart';
// import 'package:envifund_moblie_application/UserProjects/provideUpdates.dart';
//
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:web3modal_flutter/web3modal_flutter.dart';
//
// import '../ProjectUpdates/projectUpdates.dart';
//
// import '../Services/w3webServices.dart';
//
// class UserCurrProjectDes extends StatefulWidget {
//
//   final Map<String,dynamic> project;
//   const UserCurrProjectDes({super.key, required this.project});
//
//   @override
//   State<UserCurrProjectDes> createState() => _UserCurrProjectDesState();
// }
//
// class _UserCurrProjectDesState extends State<UserCurrProjectDes> {
//   List<dynamic>projectInvestors =[];
//   bool openList = false;
//   TextEditingController amountController = TextEditingController();
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     getProjectInvestors();
//   }
//
//   void getProjectInvestors() async {
//     // Get project investors
//     List investors = await Web3Services().getAllInvestorsByProjectId(widget.id);
//     print(investors);
//     // Check if investors is null or empty
//     if (investors.isEmpty) {
//       return ;
//     }
//     //
//     // // Update project investors
//     List<String> updatedInvestors = [];
//     for (var sublist in investors) {
//       if (sublist == null) continue; // Check if sublist is null
//       for (var investorslistData in sublist) {
//         if (investorslistData  == null) continue;
//         // Check if investmentData is null
//         updatedInvestors.add((investorslistData as EthereumAddress).hex);
//       }
//     }
//     setState(() {
//       projectInvestors = updatedInvestors ;
//     });
//     return ;
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Scaffold(
//         body: Container(
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 Container(
//                   height: 200,
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: NetworkImage(
//                         widget.project.imageURL,),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Padding(
//                     padding: const EdgeInsets.all(16.0),
//                     child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             widget.project.title,
//                             style: TextStyle(
//                               fontSize: 24,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             widget.project.description,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Project Location',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             widget.project.location,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Project Owner',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             widget.project.owner,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             ' Owner Email',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             widget.project.ownerEmail,
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Text(
//                             'Funding Goal:',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             '${widget.project.fundingGoal.toString()} MATIC',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//                           Text(
//                             'Current Balance:',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             '${convertToMatic(widget.project.currentBalance).toString()} MATIC',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//
//                           Text(
//                             'Locked Funds:',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.black,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             '${widget.project.lockedFunds} MATIC',
//                             style: TextStyle(
//                               fontSize: 16,
//                               color: Colors.grey,
//                             ),
//                           ),
//
//                           const SizedBox(height: 20),
//                           const Divider(),
//                           const SizedBox(height: 20),
//                           InkWell(
//                             onTap: (){
//                               // Navigate to investors page
//                               setState(() {
//                                 openList= !openList;
//                               });
//                             },
//                             child: Row(
//                               children: [
//                                 Text(
//                                   'Investors',
//                                   style: TextStyle(
//                                     fontSize: 24,
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 openList?Icon(Icons.arrow_drop_up):  Icon(Icons.arrow_drop_down),
//                               ],
//
//                             ),
//                           ),
//                           openList?
//                           Container(
//                             height: MediaQuery.of(context).size.height * 0.2,
//                             child: ListView.builder(
//                               itemCount: projectInvestors.length,
//                               itemBuilder: (context, index) {
//                                 return ListTile(
//                                   leading: Icon(Icons.label),
//                                   title: Text(projectInvestors[index]),
//
//                                 );
//                               },
//                             ),
//                           ):SizedBox.shrink(),
//
//                           const SizedBox(height: 20),
//                           const Divider(),
//                           InkWell(
//                             onTap: (){
//                               Navigator.push(context, MaterialPageRoute(builder: (context) => ProjectUpdates( ProjectId:  widget.id,)));
//                             },
//                             child: Container(
//                               height: 50,
//                               width: MediaQuery.of(context).size.width,
//                               decoration: BoxDecoration(
//                                 color: Colors.green,
//                                 borderRadius: BorderRadius.circular(5),
//                               ),
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.start,
//                                 children: [
//                                   SizedBox(width: MediaQuery.of(context).size.width*0.1,),
//                                   Text(
//                                     'See Updates',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   SizedBox(width: MediaQuery.of(context).size.width*0.47,),
//                                   Icon(Icons.arrow_forward_ios, color: Colors.white,)
//                                 ],
//                               ),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: amountController,
//                             decoration: InputDecoration(
//                               hintText: 'Enter Amount in Matic ',
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           Center(
//                             child: InkWell(
//                               onTap: () async {
//                                 // Invest in project
//                                 await Web3Services().fundProject(widget.id, double.parse(amountController.text));
//                               },
//                               child: Container(
//                                 height: 30,
//                                 width: 75,
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'Invest',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//
//                             ),
//                           ),
// //  provide updates button
//
//                           const SizedBox(height: 8),
//                           Center(
//                             child: InkWell(
//                               onTap: () async {
//                                 // Invest in project
//                                 Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatesOfProject(ProjectId: widget.id)));
//                                 await Web3Services().fundProject(widget.id, double.parse(amountController.text));
//                               },
//                               child: Container(
//                                 height: 30,
//                                 width: 175,
//                                 decoration: BoxDecoration(
//                                   color: Colors.green,
//                                   borderRadius: BorderRadius.circular(5),
//                                 ),
//                                 child: Center(
//                                   child: Text(
//                                     'Provide Updates',
//                                     style: TextStyle(
//                                       color: Colors.white,
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//
//                             ),
//                           ),
//                         ]
//                     )
//                 )
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//
//   }
//   double convertToMatic(BigInt wei) {
//     // Define conversion factor
//     final BigInt conversionFactor = BigInt.from(10).pow(18); // 1 Matic = 10^18 Wei
//
//     // Convert Wei to Matic
//     double matic = wei.toDouble() / conversionFactor.toDouble();
//
//     return matic;
//   }
// }
//
