
import 'dart:io';

import 'package:envifund_moblie_application/main.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../Services/w3webServices.dart';

class UpdatesOfProject extends StatefulWidget {
 final BigInt ProjectId;
  const UpdatesOfProject({super.key, required this.ProjectId});

  @override
  State<UpdatesOfProject> createState() => _UpdatesOfProjectState();
}

class _UpdatesOfProjectState extends State<UpdatesOfProject> {
  TextEditingController updateTextController = TextEditingController();
  bool loading = false;
  File? _image;
  final picker = ImagePicker();
  static const BASEURL ="https://mvqaptgoblyycfsjzfly.supabase.co/storage/v1/object/public/projectimages/project_update_images/";
  String ImageUrl = '';

  final supabase = Supabase.instance.client;
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
        .upload('project_images/${updateTextController.text}/${updateTextController.text}/${extractImageName(file.path)}', file);

    ImageUrl = BASEURL+updateTextController.text+"/"+extractImageName(file.path);
    setState(() {
      loading = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Updates'),
      ),
      body: Container(
        height: MediaQuery.sizeOf(context).height,
        decoration: BoxDecoration(
          gradient:linearGradient,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Add your code here
              Text("Add Update", style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),),
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
                    controller: updateTextController,
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

                    await Web3Services().giveUpdate(widget.ProjectId, updateTextController.text, ImageUrl);
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
                        'Give Updates',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
