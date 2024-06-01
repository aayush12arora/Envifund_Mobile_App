
import 'package:envifund_moblie_application/Modals/Project.dart';
import 'package:envifund_moblie_application/main.dart';
import 'package:flutter/material.dart';

import '../Services/w3webServices.dart';

class ProjectUpdates extends StatefulWidget {
   final BigInt ProjectId;
  const ProjectUpdates({super.key, required this.ProjectId});

  @override
  State<ProjectUpdates> createState() => _ProjectUpdatesState();
}

class _ProjectUpdatesState extends State<ProjectUpdates> {
  List<Update> updates=[];
  bool loading = false;
  @override
  void initState() {
    getUpdates();
  }

  Future<void> getUpdates() async {
    setState(() {
      loading = true;
    });
    List data = await Web3Services().getUpdatesByProjectId(widget.ProjectId);
    if (data.isEmpty) {
      setState(() {
        loading = false;
      });
      return ;
    }
    List<Update> updatedUpdates = [];
    for (var sublist in data) {
      if (sublist == null) continue; // Check if sublist is null
      for (var updateData in sublist) {
        if (updateData == null) continue; // Check if investmentData is null
        updatedUpdates.add(Update.fromList(updateData));
      }
    }
    setState(() {
      updates = updatedUpdates;
      loading = false;
    });
    return ;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Updates'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: linearGradient,
        ),
        child: loading
            ? Center(
          child: Container(
            padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
            child: const CircularProgressIndicator(color: Colors.black),
          ),
        )
            :Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              childAspectRatio: 0.8,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: updates.length,
            itemBuilder: (context, index) {
              final update = updates[index];
              return UpdatesOfProjectItem(
                Url: update.imageURL,
                Update: update.update,
              );
            },
          ),
        ),
      ),


    );
  }
}

class UpdatesOfProjectItem extends StatefulWidget {
  final String Url;
  final String Update;
  const UpdatesOfProjectItem({super.key, required this.Url, required this.Update});

  @override
  State<UpdatesOfProjectItem> createState() => _UpdatesOfProjectItemState();
}

class _UpdatesOfProjectItemState extends State<UpdatesOfProjectItem> {
  @override
  Widget build(BuildContext context) {
    return Column(

      children: [
        SizedBox(height: 10,),
        Container(
          height: MediaQuery.of(context).size.height * 0.35,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.grey[200],
          ),
          child: Column(
            children: [
              SizedBox(height: 20,),
              Image.network(widget.Url,height: MediaQuery.of(context).size.height*0.25,),
              Divider(),
              Text(widget.Update, style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),

            ],
          ),
        ),
        SizedBox(height: 10,),
      ],
    );
  }
}