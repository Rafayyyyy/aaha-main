import 'package:aaha/Agency.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'editOtherDetails.dart';
import 'package:aaha/services/packageManagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:path/path.dart';
import 'dart:io';

class editPackage extends StatefulWidget {
  final Package1 package;
  const editPackage({Key? key, required this.package}) : super(key: key);
  @override
  _editPackage createState() => _editPackage();
}

class _editPackage extends State<editPackage> {
  @override
  void initState() {
    _nameController..text = widget.package.PName;
    _locationController..text = widget.package.Location;
    _daysController..text = widget.package.Days;
    _priceController..text = widget.package.Price;
    _descController..text = widget.package.Desc;

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the widget tree.
    _nameController.dispose();
    super.dispose();
  }

  File? file;
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  UploadTask? task;
  List<String> ImgUrls1 = [];
  String PhotoUrl = '';
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _daysController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _locationController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final filename =
        file != null ? file!.path.toString() : ('No file selected');

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text(
          'Edit Package',
          style: (TextStyle(color: Colors.black, fontSize: 30)),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          iconSize: 40,
          icon: Icon(
            Icons.arrow_back_ios_sharp,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              editPackageUserInput('Package Name', TextInputType.text,
                  _nameController, widget.package.PName),
              editPackageUserInput('Description', TextInputType.text,
                  _descController, widget.package.Desc),
              editPackageUserInput('Days', TextInputType.text, _daysController,
                  widget.package.Days),
              editPackageUserInput('Price', TextInputType.number,
                  _priceController, widget.package.Price),
              editPackageUserInput('Location', TextInputType.text,
                  _locationController, widget.package.Location),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: RaisedButton(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.indigo.shade500,
                  onPressed: () {
                    selectImage();
                  },
                  child: Text(
                    'Edit thumbnail photo',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: RaisedButton(
                  elevation: 20,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.indigo.shade500,
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (Context) => editotherDetails(
                        p: widget.package,
                      ),
                    ));
                  },
                  child: Text(
                    'Edit Other Details',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Gallery',
                      textAlign: TextAlign.left,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 20, 10),
                      child: IconButton(
                          onPressed: () {
                            selectImages();
                          },
                          icon: Icon(Icons.camera_alt_outlined)),
                    )
                  ],
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.9,
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.25,
                  child: GridView.builder(
                      itemCount: imageFileList!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 6,
                        mainAxisSpacing: 6,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          //height: 55,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  height: 95,
                                  width: 110,
                                  child: Image.file(
                                    File(imageFileList![index].path),
                                    fit: BoxFit.scaleDown,
                                  ),
                                ),
                                SizedBox(height: 5),
                                task != null
                                    ? buildUploadStatus(task!)
                                    : Container(),
                              ],
                            ),
                          ),
                        );
                      }),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.5,
                child: RaisedButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25)),
                  color: Colors.indigo.shade800,
                  onPressed: () async {
                    print(ImgUrls1.length);
                    await packageManagement.UpdatePackage(
                        widget.package,
                        FirebaseAuth.instance.currentUser,
                        _nameController.text,
                        _descController.text,
                        _daysController.text,
                        _priceController.text,
                        _locationController.text,
                        0,
                        context,
                        ImgUrls1,
                        PhotoUrl
                    );
                    setState(() {});
                    context.read<packageProvider>().updatePackage(
                        widget.package,
                        _nameController.text,
                        _descController.text,
                        _daysController.text,
                        _priceController.text,
                        _locationController.text,
                        ImgUrls1);
                  },
                  child: Text(
                    'Edit',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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

  Future selectImage() async {
    final result = await imagePicker.pickImage(source: ImageSource.gallery);
    if (result == null) return;
    final path = File(result.path);
    setState(() {});

    final fileName = basename(path.path);
    final destination = '$fileName';
    int i = 1;
    try {
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref =
      storage.ref().child(packageManagement.Packid + '___' + fileName);
      i = i + 1;
      String url = '';
      task = ref.putFile(path);
      setState(() {});
      TaskSnapshot taskSnapshot = await task!.whenComplete(() {});
      taskSnapshot.ref.getDownloadURL().then(
            (value) {
          url = value;
          PhotoUrl = url;
          print(PhotoUrl +
              '\n...................................................................................................................');
          print("Done: $value");
        },
      );
    } catch (e) {
      print('error occured');
      print(e);
    }
  }

  void selectImages() async {
    final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
    if (selectedImages!.isNotEmpty) {
      imageFileList!.addAll(selectedImages);
    }
    print("Image List Length:" + imageFileList!.length.toString());
    setState(() {});
    await uploadFile(imageFileList!);
  }

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  Future uploadFile(List _images) async {
    _images.forEach((_photo) async {
      if (_photo == null) {
        return;
      }
      ;
      File file = File(_photo.path);
      final fileName = basename(file.path);
      final destination = '$fileName';
      int i = 1;
      try {
        FirebaseStorage storage = FirebaseStorage.instance;
        Reference ref =
            storage.ref().child(packageManagement.Packid + '___' + fileName);
        i = i + 1;
        String url = '';
        task = ref.putFile(file);
        setState(() {});
        TaskSnapshot taskSnapshot = await task!.whenComplete(() {});
        taskSnapshot.ref.getDownloadURL().then(
          (value) {
            url = value;
            ImgUrls1.add(url);
          },
        );
        final urlString = ref.getDownloadURL();
      } catch (e) {
        print('error occured');
        print(e);
      }
    });
  }

  Widget buildUploadStatus(UploadTask task) => StreamBuilder<TaskSnapshot>(
        stream: task.snapshotEvents,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final snap = snapshot.data!;
            final progress = snap.bytesTransferred / snap.totalBytes;
            final percentage = (progress * 100).toStringAsFixed(2);

            return Text(
              '$percentage %',
              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
            );
          } else {
            return Container();
          }
        },
      );
}

editPackageUserInput(String hintTitle, TextInputType keyboardType,
    TextEditingController a, String initalText) {
  return Container(
    margin: const EdgeInsets.only(bottom: 15),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(30)),
    child: Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25),
      child: TextField(
        decoration: InputDecoration(
          hintText: hintTitle,
          hintStyle: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
        ),
        keyboardType: keyboardType,
        onChanged: (text) {},
        controller: a,
      ),
    ),
  );
}


