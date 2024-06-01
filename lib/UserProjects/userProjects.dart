import 'dart:convert';

import 'package:envifund_moblie_application/MarketPlace/currencyProjectScope.dart';
import 'package:envifund_moblie_application/MarketPlace/project_scope.dart';
import 'package:envifund_moblie_application/UserProjects/userProjectDes.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import '../Modals/Project.dart';
import '../Services/w3webServices.dart';

class UserProjects extends StatefulWidget {
  final String email;
  const UserProjects({super.key, required this.email});

  @override
  State<UserProjects> createState() => _UserProjectsState();
}

class _UserProjectsState extends State<UserProjects> with TickerProviderStateMixin  {

  List<Project> projects = [];
  bool loading = false;
  List<dynamic> currencyProjects = [];
  late final TabController _tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    setState(() {
      loading = true;
    });
    getData();
    fetchProjects();
    setState(() {
      loading = false;
    });
  }

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    List data = await Web3Services().getAllProjectsByOwner();

    // Check if data is null or empty
    if (data.isEmpty) {
      setState(() {
        loading = false;
      });
      return ;
    }

    List<Project> updatedProjects = [];
    for (var sublist in data) {
      if (sublist == null) continue; // Check if sublist is null
      for (var projectData in sublist) {
        if (projectData == null) continue; // Check if investmentData is null
        updatedProjects.add(Project.fromList(projectData));
      }
    }
    setState(() {
      projects = updatedProjects;
      loading = false;
    });
    return ;
  }


  Future<void> fetchProjects() async {

    print("email for investments ${widget.email}");
    String url = 'https://envifund.vercel.app/api/project/fetch-projects-of-a-user?email_id=${widget.email}';
    //String url = 'https://envifund.vercel.app/api/project/fetch-investments-done-by-user?investor_id=${user?.email!}';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch projects');
      }

      final List<dynamic> data = json.decode(response.body);
      print("data for projects $data");
      setState(() {
        currencyProjects = data;
      });
    } catch (error) {
      print('Error fetching projects: $error');
      setState(() {
        currencyProjects = [];
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Projects'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Crypto Projects'),
            Tab(text: 'Normal Currency Projects'),
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
              itemCount: projects.length,
              itemBuilder: (context, index) {
                final project = projects[index];
                return InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context) => UserProjectDes(project: project, id: project.projectId,)));
                  },
                  child: ProjectCard(
                      title: project.title,
                      percentage: convertToMatic(project.currentBalance)/ project.fundingGoal.toInt() ,

                      goal: project.fundingGoal.toString(),
                      location: project.location,
                      owner:project.ownerEmail
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
                  itemCount: currencyProjects.length,
                  itemBuilder: (context, index) {
                    final project = currencyProjects[index];
                    return InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CurrencyProjectDes(id: project['project_id'], project: project)));
                      },
                      child: ProjectCard(
                          title: project['project_title'],
                          percentage: project['funding_amount']/ project['funding_goal'] ,

                          goal: project['funding_goal'].toString(),
                          location:project['location'] ,
                          owner:project['project_lead_id']
                      ),
                    );
                  },
                ),
              ),
            ],
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




class ProjectCard extends StatelessWidget {
  final String title;
  final double percentage;
  final String goal;
  final String location;
  final String owner;

  const ProjectCard({
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
            Center(
              child: CircularPercentIndicator(
                radius: 50.0,
                lineWidth: 10.0,
                percent: percentage,
                center: Text(
                  '${(percentage * 100).toInt()}%',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                progressColor: Colors.blue,
              ),
            ),
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