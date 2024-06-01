// lib/models/project.dart

import 'package:web3modal_flutter/web3modal_flutter.dart';

class Update {
  final String update;
  final String imageURL;

  Update({
    required this.update,
    required this.imageURL,
  });

  factory Update.fromList(List<dynamic> updateData) {
    return Update(
      update: updateData[0],
      imageURL: updateData[1],
    );
  }
}

class Project {
  final BigInt projectId;
  final String title;
  final String owner;
  final double fundingGoal;
  final BigInt currentBalance;
  final double lockedFunds;
  final String description;
  final String location;
  final bool completionStatus;
  final String imageURL;
  final String ownerEmail;

  Project({
    required this.projectId,
    required this.title,
    required this.owner,
    required this.fundingGoal,
    required this.currentBalance,
    required this.lockedFunds,
    required this.description,
    required this.location,
    required this.completionStatus,
    required this.imageURL,
    required this.ownerEmail,
  });

  factory Project.fromList(List<dynamic> projectData) {
    return Project(
      projectId: projectData[0] ,
      title: projectData[1],
      owner: (projectData[2] as EthereumAddress).hex,
      fundingGoal: (projectData[3] as BigInt).toDouble(),
      currentBalance: (projectData[4]),
      lockedFunds: (projectData[5] as BigInt).toDouble(),
      description: projectData[6],
      location: projectData[7],
      completionStatus: projectData[8],
      imageURL: projectData[9],
      ownerEmail: projectData[10],
    );
  }
}
