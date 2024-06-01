
import 'dart:convert';


import 'package:web3dart/web3dart.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:web3modal_flutter/models/w3m_chain_info.dart';
import 'package:web3modal_flutter/services/w3m_service/w3m_service.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

class Web3Services{
 static late W3MService _w3mService;
    final  deployedContract=  DeployedContract(
      ContractAbi.fromJson(
          jsonEncode([
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_fundingGoal",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "_title",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "_description",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "_location",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "_imageUrL",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "_ownerEmail",
                  "type": "string"
                }
              ],
              "name": "createProject",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "",
                  "type": "string"
                }
              ],
              "stateMutability": "nonpayable",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "fundProject",
              "outputs": [],
              "stateMutability": "payable",
              "type": "function"
            },
            {
              "anonymous": false,
              "inputs": [
                {
                  "indexed": false,
                  "internalType": "uint256",
                  "name": "projectId",
                  "type": "uint256"
                },
                {
                  "indexed": false,
                  "internalType": "address",
                  "name": "investor",
                  "type": "address"
                },
                {
                  "indexed": false,
                  "internalType": "uint256",
                  "name": "amount",
                  "type": "uint256"
                }
              ],
              "name": "FundsReleased",
              "type": "event"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "_update",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "_imageUrl",
                  "type": "string"
                }
              ],
              "name": "giveUpdate",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
            },
            {
              "anonymous": false,
              "inputs": [
                {
                  "indexed": false,
                  "internalType": "uint256",
                  "name": "projectId",
                  "type": "uint256"
                },
                {
                  "indexed": false,
                  "internalType": "address",
                  "name": "owner",
                  "type": "address"
                },
                {
                  "indexed": false,
                  "internalType": "uint256",
                  "name": "fundingGoal",
                  "type": "uint256"
                }
              ],
              "name": "ProjectCreated",
              "type": "event"
            },
            {
              "anonymous": false,
              "inputs": [
                {
                  "indexed": false,
                  "internalType": "uint256",
                  "name": "projectId",
                  "type": "uint256"
                },
                {
                  "indexed": false,
                  "internalType": "address",
                  "name": "investor",
                  "type": "address"
                },
                {
                  "indexed": false,
                  "internalType": "uint256",
                  "name": "amount",
                  "type": "uint256"
                }
              ],
              "name": "ProjectFunded",
              "type": "event"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "releaseLockedFunds",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "withdraw",
              "outputs": [],
              "stateMutability": "nonpayable",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "AllProjects",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "projectId",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "title",
                  "type": "string"
                },
                {
                  "internalType": "address",
                  "name": "owner",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "fundingGoal",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "currentBalance",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "lockedFunds",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "description",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "location",
                  "type": "string"
                },
                {
                  "internalType": "bool",
                  "name": "completionStatus",
                  "type": "bool"
                },
                {
                  "internalType": "string",
                  "name": "imageUrL",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "ownerEmail",
                  "type": "string"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "owner_Address",
                  "type": "address"
                }
              ],
              "name": "getAllInvestmentsByOwner",
              "outputs": [
                {
                  "components": [
                    {
                      "internalType": "uint256",
                      "name": "projectId",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "title",
                      "type": "string"
                    },
                    {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                    },
                    {
                      "internalType": "uint256",
                      "name": "fundingGoal",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "currentBalance",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "lockedFunds",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "description",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "location",
                      "type": "string"
                    },
                    {
                      "internalType": "bool",
                      "name": "completionStatus",
                      "type": "bool"
                    },
                    {
                      "internalType": "string",
                      "name": "imageUrL",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "ownerEmail",
                      "type": "string"
                    }
                  ],
                  "internalType": "struct EnviFundtwo.Project[]",
                  "name": "",
                  "type": "tuple[]"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "getAllInvestorsByProject",
              "outputs": [
                {
                  "internalType": "address[]",
                  "name": "",
                  "type": "address[]"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [],
              "name": "getAllProjects",
              "outputs": [
                {
                  "components": [
                    {
                      "internalType": "uint256",
                      "name": "projectId",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "title",
                      "type": "string"
                    },
                    {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                    },
                    {
                      "internalType": "uint256",
                      "name": "fundingGoal",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "currentBalance",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "lockedFunds",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "description",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "location",
                      "type": "string"
                    },
                    {
                      "internalType": "bool",
                      "name": "completionStatus",
                      "type": "bool"
                    },
                    {
                      "internalType": "string",
                      "name": "imageUrL",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "ownerEmail",
                      "type": "string"
                    }
                  ],
                  "internalType": "struct EnviFundtwo.Project[]",
                  "name": "",
                  "type": "tuple[]"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "_owner",
                  "type": "address"
                }
              ],
              "name": "getAllProjectsByOwner",
              "outputs": [
                {
                  "components": [
                    {
                      "internalType": "uint256",
                      "name": "projectId",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "title",
                      "type": "string"
                    },
                    {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                    },
                    {
                      "internalType": "uint256",
                      "name": "fundingGoal",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "currentBalance",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "lockedFunds",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "description",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "location",
                      "type": "string"
                    },
                    {
                      "internalType": "bool",
                      "name": "completionStatus",
                      "type": "bool"
                    },
                    {
                      "internalType": "string",
                      "name": "imageUrL",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "ownerEmail",
                      "type": "string"
                    }
                  ],
                  "internalType": "struct EnviFundtwo.Project[]",
                  "name": "",
                  "type": "tuple[]"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "investor_address",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "getInvestorFundingForProject",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "getProjectbyId",
              "outputs": [
                {
                  "components": [
                    {
                      "internalType": "uint256",
                      "name": "projectId",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "title",
                      "type": "string"
                    },
                    {
                      "internalType": "address",
                      "name": "owner",
                      "type": "address"
                    },
                    {
                      "internalType": "uint256",
                      "name": "fundingGoal",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "currentBalance",
                      "type": "uint256"
                    },
                    {
                      "internalType": "uint256",
                      "name": "lockedFunds",
                      "type": "uint256"
                    },
                    {
                      "internalType": "string",
                      "name": "description",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "location",
                      "type": "string"
                    },
                    {
                      "internalType": "bool",
                      "name": "completionStatus",
                      "type": "bool"
                    },
                    {
                      "internalType": "string",
                      "name": "imageUrL",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "ownerEmail",
                      "type": "string"
                    }
                  ],
                  "internalType": "struct EnviFundtwo.Project",
                  "name": "",
                  "type": "tuple"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "_projectId",
                  "type": "uint256"
                }
              ],
              "name": "getUpdatesByProject",
              "outputs": [
                {
                  "components": [
                    {
                      "internalType": "string",
                      "name": "update",
                      "type": "string"
                    },
                    {
                      "internalType": "string",
                      "name": "imageURL",
                      "type": "string"
                    }
                  ],
                  "internalType": "struct EnviFundtwo.Updates[]",
                  "name": "",
                  "type": "tuple[]"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "string",
                  "name": "",
                  "type": "string"
                }
              ],
              "name": "investmentsFlag",
              "outputs": [
                {
                  "internalType": "bool",
                  "name": "",
                  "type": "bool"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "investorToProjects",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "projectId",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "title",
                  "type": "string"
                },
                {
                  "internalType": "address",
                  "name": "owner",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "fundingGoal",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "currentBalance",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "lockedFunds",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "description",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "location",
                  "type": "string"
                },
                {
                  "internalType": "bool",
                  "name": "completionStatus",
                  "type": "bool"
                },
                {
                  "internalType": "string",
                  "name": "imageUrL",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "ownerEmail",
                  "type": "string"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "investorToProjIdFunds",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "investorToProjIdToLocked",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [],
              "name": "mapKey",
              "outputs": [
                {
                  "internalType": "string",
                  "name": "",
                  "type": "string"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "ownerToProjects",
              "outputs": [
                {
                  "internalType": "uint256",
                  "name": "projectId",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "title",
                  "type": "string"
                },
                {
                  "internalType": "address",
                  "name": "owner",
                  "type": "address"
                },
                {
                  "internalType": "uint256",
                  "name": "fundingGoal",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "currentBalance",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "lockedFunds",
                  "type": "uint256"
                },
                {
                  "internalType": "string",
                  "name": "description",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "location",
                  "type": "string"
                },
                {
                  "internalType": "bool",
                  "name": "completionStatus",
                  "type": "bool"
                },
                {
                  "internalType": "string",
                  "name": "imageUrL",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "ownerEmail",
                  "type": "string"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "ProjectsToOwner",
              "outputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                }
              ],
              "name": "ProjectToInvestorDupmap",
              "outputs": [
                {
                  "internalType": "bool",
                  "name": "",
                  "type": "bool"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "ProjectToInvestors",
              "outputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                },
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "projectToUpdates",
              "outputs": [
                {
                  "internalType": "string",
                  "name": "update",
                  "type": "string"
                },
                {
                  "internalType": "string",
                  "name": "imageURL",
                  "type": "string"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            },
            {
              "inputs": [
                {
                  "internalType": "uint256",
                  "name": "",
                  "type": "uint256"
                }
              ],
              "name": "testInvestorArr",
              "outputs": [
                {
                  "internalType": "address",
                  "name": "",
                  "type": "address"
                }
              ],
              "stateMutability": "view",
              "type": "function"
            }
          ]),'EnviFundtwo'
      ), // ABI object
      EthereumAddress.fromHex('0x730eb06F5A3fb7f33C67170f47413B71eBD4e03A'), // Contract address
    );
  static const _chainId = "80002";
  final _polygonChain = W3MChainInfo(
    chainName: 'Polygon Amoy Testnet',
    namespace: 'eip155:$_chainId',

    chainId: _chainId,
    tokenName: 'MATIC',
    rpcUrl: 'https://rpc-amoy.polygon.technology/',
    blockExplorer: W3MBlockExplorer(
      name: 'Polygon Explorer',
      url: 'https://amoy.polygonscan.com/',
    ),
  );


 static W3MService get w3mService => _w3mService;
 static String get address => _w3mService.session?.address ?? '';
 late String _address ;

  Future<void> initializeModalAndContract() async {
    await _initializeService();

  }


  Future<void> _initializeService() async {
    W3MChainPresets.chains.putIfAbsent(_chainId, () => _polygonChain);
    _w3mService = W3MService(
      projectId: "b1e43c58f75f833f0ada8ae052ab3d84",
      logLevel: LogLevel.error,
      metadata: const PairingMetadata(
        name: "W3M Flutter",
        description: "W3M Flutter test app",
        url: 'https://www.walletconnect.com/',
        icons: ['https://web3modal.com/images/rpc-illustration.png'],
        redirect: Redirect(
          native: 'web3modalflutter://',
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();
  }


 Future<List> getAllInvestmentsByOwner() async {
   // Get balance of wallet


   final result = await _w3mService.requestReadContract(
     deployedContract: deployedContract,
     functionName: 'getAllInvestmentsByOwner',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     parameters: [
       // Your address
       EthereumAddress.fromHex(_w3mService.session?.address ?? '')
     ],
   );

  return result;
 }

 Future<List> getAllProjects() async {
   // Get balance of wallet
   print("aaya to hu bhai ${deployedContract.toString()}");

   final result = await _w3mService.requestReadContract(
     deployedContract: deployedContract,
     functionName: 'getAllProjects',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     parameters: [
       // Your address

     ],
   );

   return result;
 }

 Future<List> getAllProjectsByOwner() async {
   // Get balance of wallet
try {
  final result = await _w3mService.requestReadContract(
    deployedContract: deployedContract,
    functionName: 'getAllProjectsByOwner',
    rpcUrl: 'https://rpc-amoy.polygon.technology/',
    parameters: [

      EthereumAddress.fromHex(_w3mService.session?.address ?? '')
    ],
  );

  return result;
}catch(e){
  print(e);
}
   return [];
 }

 Future<List> getAllInvestorsByProjectId(BigInt id) async {
   // Get balance of wallet
   print("aaya to hu bhai ${deployedContract.toString()}");

   final result = await _w3mService.requestReadContract(
     deployedContract: deployedContract,
     functionName: 'getAllInvestorsByProject',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     parameters: [
       // Your address
id
     ],
   );

   return result;
 }



 Future<List> getUpdatesByProjectId(BigInt ProjectId) async {
   // Get balance of wallet
   try {
     final result = await _w3mService.requestReadContract(
       deployedContract: deployedContract,
       functionName: 'getUpdatesByProject',
       rpcUrl: 'https://rpc-amoy.polygon.technology/',
       parameters: [

          ProjectId
       ],
     );

     return result;
   }catch(e){
     print(e);
   }
   return [];
 }




 int maticToWei(double matic) {
   // 1 MATIC = 10^18 wei
   const int decimals = 18;
   BigInt weiValue = BigInt.from(matic * BigInt.from(10).pow(decimals).toDouble());
   return weiValue.toInt();
 }


 Future<void> fundProject(BigInt projectId, double amount) async {
   _w3mService.launchConnectedWallet();

   // Create a Web3Client instance
   final ethClient = Web3Client('https://rpc-amoy.polygon.technology/', Client());
   final senderAddress = EthereumAddress.fromHex(_w3mService.session?.address ?? '');

   // Create a transaction object
   final transaction = Transaction(
     from: senderAddress,
     to: deployedContract.address,
     value: EtherAmount.inWei(BigInt.from(maticToWei(amount))),
   );

   // Estimate gas limit
   final estimatedGas = await ethClient.estimateGas(
     sender: senderAddress,
     to: deployedContract.address,
     value: transaction.value,
     data: deployedContract.function('fundProject').encodeCall([projectId]),
   );

   // Get current gas price
   final gasPrice = await ethClient.getGasPrice();

   // Update transaction with estimated gas and gas price
   final updatedTransaction = transaction.copyWith(
     gasPrice: gasPrice,
     maxGas: estimatedGas.toInt(),
   );

   // Send the transaction
   final result = await _w3mService.requestWriteContract(
     topic: _w3mService.session!.topic.toString(),
     chainId: 'eip155:$_chainId',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     deployedContract: deployedContract,
     functionName: 'fundProject',
     transaction: Transaction(
       from: EthereumAddress.fromHex(w3mService.session!.address!),
       value: EtherAmount.fromInt(EtherUnit.wei, maticToWei(amount)),
        maxGas: estimatedGas.toInt(),
        gasPrice: null,
       maxPriorityFeePerGas: null,
       maxFeePerGas: null,
     ),
     parameters: [projectId],
   );
 }

 Future<void> createProject(BigInt _fundingGoal,String _title,String _description,
     String _location,String _imageUrL,String _ownerEmail) async {




   _w3mService.launchConnectedWallet();

   // Create a Web3Client instance
   final ethClient = Web3Client('https://rpc-amoy.polygon.technology/', Client());
   final senderAddress = EthereumAddress.fromHex(_w3mService.session?.address ?? '');

   // Create a transaction object
   final transaction = Transaction(
     from: senderAddress,
     to: deployedContract.address,

   );

   // Estimate gas limit
   final estimatedGas = await ethClient.estimateGas(
     sender: senderAddress,
     to: deployedContract.address,
     value: transaction.value,
     data: deployedContract.function('createProject').encodeCall([_fundingGoal,_title,_description,_location,_imageUrL,_ownerEmail]),
   );

   // Get current gas price
   final gasPrice = await ethClient.getGasPrice();

   // Update transaction with estimated gas and gas price
   final updatedTransaction = transaction.copyWith(
     gasPrice: gasPrice,
     maxGas: estimatedGas.toInt(),
   );

   // Send the transaction
   final result = await _w3mService.requestWriteContract(
     topic: _w3mService.session!.topic.toString(),
     chainId: 'eip155:$_chainId',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     deployedContract: deployedContract,
     functionName: 'createProject',
     transaction: Transaction(
       from: EthereumAddress.fromHex(w3mService.session!.address!),

       maxGas: estimatedGas.toInt(),
       gasPrice: null,
       maxPriorityFeePerGas: null,
       maxFeePerGas: null,
     ),
     parameters: [_fundingGoal,_title,_description,_location,_imageUrL,_ownerEmail],
   );
 }


 Future<void> giveUpdate(BigInt projectId,String update, String imageURL) async {
   _w3mService.launchConnectedWallet();

   // Create a Web3Client instance
   final ethClient = Web3Client('https://rpc-amoy.polygon.technology/', Client());
   final senderAddress = EthereumAddress.fromHex(_w3mService.session?.address ?? '');

   // Create a transaction object
   final transaction = Transaction(
     from: senderAddress,
     to: deployedContract.address,

   );

   // Estimate gas limit
   final estimatedGas = await ethClient.estimateGas(
     sender: senderAddress,
     to: deployedContract.address,
     value: transaction.value,
     data: deployedContract.function('giveUpdate').encodeCall([projectId,update,imageURL]),
   );

   // Get current gas price
   final gasPrice = await ethClient.getGasPrice();



   // Send the transaction
   final result = await _w3mService.requestWriteContract(
     topic: _w3mService.session!.topic.toString(),
     chainId: 'eip155:$_chainId',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     deployedContract: deployedContract,
     functionName: 'giveUpdate',
     transaction: Transaction(
       from: EthereumAddress.fromHex(w3mService.session!.address!),
       maxGas: estimatedGas.toInt(),
       gasPrice: null,
       maxPriorityFeePerGas: null,
       maxFeePerGas: null,
     ),
     parameters: [projectId,update,imageURL],
   );
 }
 Future<void> withdrawInvestment(BigInt projectId) async {
   _w3mService.launchConnectedWallet();

   // Create a Web3Client instance
   final ethClient = Web3Client('https://rpc-amoy.polygon.technology/', Client());
   final senderAddress = EthereumAddress.fromHex(_w3mService.session?.address ?? '');

   // Create a transaction object
   final transaction = Transaction(
     from: senderAddress,
     to: deployedContract.address,

   );

   // Estimate gas limit
   final estimatedGas = await ethClient.estimateGas(
     sender: senderAddress,
     to: deployedContract.address,
     value: transaction.value,
     data: deployedContract.function('withdraw').encodeCall([projectId]),
   );

   // Get current gas price
   final gasPrice = await ethClient.getGasPrice();



   // Send the transaction
   final result = await _w3mService.requestWriteContract(
     topic: _w3mService.session!.topic.toString(),
     chainId: 'eip155:$_chainId',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     deployedContract: deployedContract,
     functionName: 'withdraw',
     transaction: Transaction(
       from: EthereumAddress.fromHex(w3mService.session!.address!),
       maxGas: estimatedGas.toInt(),
       gasPrice: null,
       maxPriorityFeePerGas: null,
       maxFeePerGas: null,
     ),
     parameters: [projectId],
   );
 }



 Future<void> releaseLockedFunds(BigInt projectId) async {
   _w3mService.launchConnectedWallet();

   // Create a Web3Client instance
   final ethClient = Web3Client('https://rpc-amoy.polygon.technology/', Client());
   final senderAddress = EthereumAddress.fromHex(_w3mService.session?.address ?? '');

   // Create a transaction object
   final transaction = Transaction(
     from: senderAddress,
     to: deployedContract.address,

   );

   // Estimate gas limit
   final estimatedGas = await ethClient.estimateGas(
     sender: senderAddress,
     to: deployedContract.address,
     value: transaction.value,
     data: deployedContract.function('releaseLockedFunds').encodeCall([projectId]),
   );

   // Get current gas price
   final gasPrice = await ethClient.getGasPrice();



   // Send the transaction
   final result = await _w3mService.requestWriteContract(
     topic: _w3mService.session!.topic.toString(),
     chainId: 'eip155:$_chainId',
     rpcUrl: 'https://rpc-amoy.polygon.technology/',
     deployedContract: deployedContract,
     functionName: 'releaseLockedFunds',
     transaction: Transaction(
       from: EthereumAddress.fromHex(w3mService.session!.address!),
       maxGas: estimatedGas.toInt(),
       gasPrice: null,
       maxPriorityFeePerGas: null,
       maxFeePerGas: null,
     ),
     parameters: [projectId],
   );
 }

}