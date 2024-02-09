import 'dart:io';
import 'package:converse/data/fire_storage.dart';
import 'package:converse/data/fire_store.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../components/personal_detail_tile.dart';

class ProfilePage extends StatefulWidget {
  final Map<String, dynamic> userDetails;

  const ProfilePage({super.key, required this.userDetails});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? _imageFile;
  final FireStoreDb _fireStoreDb = FireStoreDb();
  final FireStorage _fireStorage = FireStorage();
  final TextEditingController nameController = TextEditingController();

  // update user name to fire store
  void updateUserName() {
    // set default text to text field
    nameController.text = widget.userDetails['name'];
    // alert box to get the latest user name
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            // user input
            content: TextField(
              controller: nameController,
              decoration: InputDecoration(
                  suffixIcon: IconButton(
                onPressed: () => nameController.clear(),
                icon: const Icon(Icons.clear),
              )),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: ElevatedButton(
                  onPressed: () {
                    // update the name to fire store
                    _fireStoreDb.updateCurrentUserName(nameController.text);
                    setState(() {
                      widget.userDetails['name'] = nameController.text;
                      // getCurrentUserDetail();
                    });

                    // clear the text
                    nameController.clear();
                    // pop the box
                    Navigator.pop(context);
                  },
                  child: const Text('Update'),
                ),
              ),
            ],
          );
        });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });

      // upload image to fire storage
      await _fireStorage.uploadImage(
          _imageFile!, widget.userDetails['uid'] + '.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'PROFILE',
          style: TextStyle(
            letterSpacing: 1,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 20),
          child: Column(
            children: [
              Stack(
                alignment: const Alignment(1, 1.1),
                children: [
                  _imageFile != null
                      ? CircleAvatar(
                          radius: 80,
                          backgroundColor:
                              Theme.of(context).colorScheme.background,
                          backgroundImage: FileImage(
                            _imageFile!,
                          ),
                        )
                      : CircleAvatar(
                          radius: 80,
                          backgroundColor: Colors.grey,
                          backgroundImage: widget.userDetails['imageURL'] !=
                                  null
                              ? NetworkImage(widget.userDetails['imageURL']!)
                              : null,
                          child: widget.userDetails['imageURL'] == null
                              ? const Icon(
                                  Icons.person,
                                  size: 80,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                  Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: _pickImage,
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
              // show up all personal details
              PersonalDetailTile(
                icon: Icons.email_rounded,
                label: 'Email',
                labelData: widget.userDetails['email'].toString(),
              ),
              PersonalDetailTile(
                icon: Icons.person,
                label: 'Name',
                labelData: widget.userDetails['name'].toString(),
                suffixIcon: Icons.edit,
                onPressedOnSuffixIcon: updateUserName,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
