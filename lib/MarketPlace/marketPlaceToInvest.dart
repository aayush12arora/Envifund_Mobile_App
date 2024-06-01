import 'dart:convert';
import 'package:envifund_moblie_application/MarketPlace/project_scope.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;
import '../Modals/Project.dart';
import '../Services/w3webServices.dart';
import 'currencyProjectScope.dart';

class Invest extends StatefulWidget {
  const Invest({super.key});

  @override
  State<Invest> createState() => _InvestState();
}

class _InvestState extends State<Invest> with TickerProviderStateMixin {
  late final TabController _tabController;
  List<Project> projects = [];
  bool loading = false;
  List<dynamic> currencyProjects = [];

  @override
  void initState() {
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

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    setState(() {
      loading = true;
    });
    List data = await Web3Services().getAllProjects();

    if (data.isEmpty) {
      setState(() {
        loading = false;
      });
      return;
    }

    List<Project> updatedProjects = [];
    for (var sublist in data) {
      if (sublist == null) continue;
      for (var projectData in sublist) {
        if (projectData == null) continue;
        updatedProjects.add(Project.fromList(projectData));
      }
    }
    setState(() {
      projects = updatedProjects;
      loading = false;
    });
  }

  Future<void> fetchProjects() async {
    const String url = 'https://envifund.vercel.app/api/project/fetch-all-projects';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch projects');
      }

      final List<dynamic> data = json.decode(response.body);
      print(data);
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
        title: const Text('Invest Here'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Crypto Projects'),
            Tab(text: 'Normal Currency'),
          ],
        ),
      ),
      body: loading
          ? Center(
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
          child: const CircularProgressIndicator(color: Colors.black),
        ),
      )
          : TabBarView(
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
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProjectDes(
                          project: project,
                          id: project.projectId,
                        ),
                      ),
                    );
                  },
                  child: ProjectCard(
                    title: project.title,
                    percentage: convertToMatic(project.currentBalance) / project.fundingGoal.toInt(),
                    goal: project.fundingGoal.toString(),
                    location: project.location,
                    owner: project.ownerEmail,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Expanded(
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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CurrencyProjectDes(
                            project: project,
                            id: project['project_id'],
                          ),
                        ),
                      );
                    },
                    child: ProjectCard(
                      title: project['project_title'],
                      percentage: project['funding_amount'] / project['funding_goal'],
                      goal: project['funding_goal'].toString(),
                      location: project['location'],
                      owner: project['project_lead_id'],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  double convertToMatic(BigInt wei) {
    final BigInt conversionFactor = BigInt.from(10).pow(18); // 1 Matic = 10^18 Wei
    return wei.toDouble() / conversionFactor.toDouble();
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
