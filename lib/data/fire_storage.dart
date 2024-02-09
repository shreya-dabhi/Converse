import 'dart:io';
import 'package:converse/data/fire_store.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FireStorage {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _imagePath = 'converse/images/';

  Future<String?> uploadImage(File file, String imageName) async {
    try {
      // delete if exists already
      await deleteImage(_imagePath + imageName);

      // upload to fire storage
      await _storage.ref(_imagePath + imageName).putFile(file);

      // download the url path of image
      String? imageURl = await downloadImage(imageName);

      // add image URL to fire store db
      FireStoreDb _fireStoreDb = FireStoreDb();
      _fireStoreDb.addOrUpdateImageFieldOfCurrentUser(imageURl!);

      print('Image uploaded successfully!');
      return imageURl;
    } catch (error) {
      print('Error uploading image: $error');
    }
  }

  Future<String?> downloadImage(String imageName) async {
    try {
      final String downloadURL =
          await _storage.ref(_imagePath + imageName).getDownloadURL();
      print('Image downloaded successfully!');
      return downloadURL;
    } catch (error) {
      print('Error downloading image: $error');
      return null;
    }
  }

  Future<void> deleteImage(String imagePath) async {
    try {
      await _storage.ref(imagePath).delete();
      print('Image deleted successfully!');
    } catch (error) {
      print('Error deleting image: $error');
    }
  }
}
