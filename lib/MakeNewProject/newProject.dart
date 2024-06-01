
import 'dart:io';

import 'package:envifund_moblie_application/main.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Services/w3webServices.dart';

class NewProject extends StatefulWidget {

  const NewProject({super.key});

  @override
  State<NewProject> createState() => _NewProjectState();
}

class _NewProjectState extends State<NewProject> {
  TextEditingController titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController fundingGoalController = TextEditingController();
  TextEditingController locationController = TextEditingController();
bool loading = false;
  File? _image;
  final picker = ImagePicker();
  String _selectedItem = 'CryptoCurrency';
  final List<String> _dropdownItems = ['CryptoCurrency','Rupees'];
  static const BASEURL ="https://mvqaptgoblyycfsjzfly.supabase.co/storage/v1/object/public/projectimages/project_images/";
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  String ImageUrl = '';
  auth.User? user;
  final supabase = Supabase.instance.client;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      loading = true;
    });
    _auth.authStateChanges().listen((auth.User? user) {
      setState(() {
        this.user = user;
loading= false;
      });
    });
  }
  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);


      if (pickedFile != null) {
        _image = File(pickedFile.path);

        print('Image Path: ${extractImageName(_image!.path)}');
await uploadImageToSupaBase(_image!);



      } else {
        print('No image selected.');
      }

  }
  String extractImageName(String path) {
    // Find the last occurrence of '/'
    int lastSlashIndex = path.lastIndexOf('/');
    // Extract the substring after the last '/'
    return path.substring(lastSlashIndex + 1);
  }

  Future<void>uploadImageToSupaBase(File file)async{
setState(() {
  loading = true;
});
    //file.writeAsStringSync('File content');
    await supabase.storage
        .from('projectimages')
        .upload('project_images/${titleController.text}/${extractImageName(file.path)}', file);

    ImageUrl = BASEURL+titleController.text+"/"+extractImageName(file.path);
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Create New Project'),
        ),
        body: Container(
          decoration: BoxDecoration(
          gradient: linearGradient,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(

                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.1),
                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Project Title',

                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20,),

                  Container(
                  //  margin:  EdgeInsets.all(25),
                    //padding: EdgeInsets.all(25),
                    height: MediaQuery.sizeOf(context).height * 0.2,
                    width: MediaQuery.sizeOf(context).width * 0.83,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.sizeOf(context).width * 0.04,
                        right: MediaQuery.sizeOf(context).width * 0.08,
                      ), // Add desired padding
                      child: TextField(
                        controller: _descriptionController,
                        style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.w400),
                        maxLines: null,
                        decoration: const InputDecoration(
                          enabledBorder:
                          InputBorder.none, // Remove underline
                          focusedBorder: InputBorder
                              .none, // Remove underline when focused
                          errorBorder: InputBorder
                              .none, // Remove underline on error
                          disabledBorder: InputBorder.none,
                          contentPadding: EdgeInsets
                              .zero, // Set contentPadding to zero
                          hintText: "Project Description",
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  // add drop down for project type
                  DropdownButton<String>(
                    style: TextStyle(color: Colors.white),
                    dropdownColor: Colors.white,
                    value: _selectedItem,
                    items: _dropdownItems.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        _selectedItem = newValue!;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  TextField(
                    keyboardType: TextInputType.number,
                    controller: fundingGoalController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Funding Goal',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20,),
                  TextField(

                    controller: locationController,
                    decoration: InputDecoration(
                      hintStyle: TextStyle(color: Colors.white),
                      hintText: 'Location',
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    onPressed: _pickImage,
                    child: Text('Pick Image from Gallery'),
                  ),
                  SizedBox(height: 20),
                  _image == null
                      ? Text('No image selected.',style: TextStyle(color: Colors.white),)
                      :loading? Container(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.1),
                    child: const CircularProgressIndicator(color: Colors.white),
                  ): Image.file(
                    _image!,
                    height: 200,
                  ),
                  SizedBox(height: 20),
                  Center(
                    child: InkWell(
                      onTap: () async {
                        // Invest in project
                       await Web3Services().createProject(BigInt.parse(fundingGoalController.text),
                           titleController.text, _descriptionController.text, locationController.text, ImageUrl, user?.email ?? '');
                      },
                      child: Container(
                        height: 40,
                        width: 165,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Center(
                          child: Text(
                            'Create Project',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  // Add your widgets here
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
