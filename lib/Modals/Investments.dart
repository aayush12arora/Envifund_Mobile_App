import 'package:web3modal_flutter/web3modal_flutter.dart';

class Investment {
  final BigInt id;
  final String title;
  final String owner;
  final BigInt amountRaised; // Updated to accept BigInt
  final BigInt goalAmount;
  final BigInt lockedAmount;// Updated to accept BigInt
  final String description;
  final String location;
  final bool completed;
  final String imageUrl;
  final String contactEmail;

  Investment({
    required this.id,
    required this.title,
    required this.owner,
    required this.amountRaised,
    required this.goalAmount,
    required this.lockedAmount,
    required this.description,
    required this.location,
    required this.completed,
    required this.imageUrl,
    required this.contactEmail,
  });

  factory Investment.fromList(List<dynamic> data) {
    return Investment(
      id: data[0] , // Cast BigInt to int
      title: data[1] as String,
      owner: (data[2] as EthereumAddress).hex,
      amountRaised: data[4] as BigInt, // Directly accept BigInt
      goalAmount: data[3] as BigInt,
      lockedAmount: data[5],// Directly accept BigInt
      description: data[6] as String,
      location: data[7] as String,
      completed: data[8] as bool,
      imageUrl: data[9] as String,
      contactEmail: data[10] as String,
    );
  }
}
