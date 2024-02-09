import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FireStoreDb {
  final _store = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<Map<String, dynamic>> getCurrentUserDetails() async {
    final currentUserId = _auth.currentUser!.uid;

    // fetch all details
    DocumentSnapshot document =
        await _store.collection('users').doc(currentUserId).get();

    Map<String, dynamic> userDetails = document!.data() as Map<String, dynamic>;

    return userDetails;
  }

  void updateCurrentUserName(String updatedName) async {
    try {
      await _store
          .collection('users')
          .doc(_auth.currentUser!.uid)
          .update({'name': updatedName});
    } catch (e) {
      print(e);
    }
  }

  void addOrUpdateImageFieldOfCurrentUser(String imageURL) async {
    try {
      // Update the document with a new field
      await _store.collection('users').doc(_auth.currentUser!.uid).update({
        'imageURL': imageURL,
      });

      print('Field added successfully!');
    } catch (e) {
      print('error while adding or uploading image to fire store : $e');
    }
  }

  Future<QuerySnapshot?> getByUserInitialLetter(String searchTerm) async {
    try {
      // Query documents where 'fieldName' is equal to 'initialValue'
      QuerySnapshot querySnapshot = await _store
          .collection('users')
          .where('name', isGreaterThanOrEqualTo: searchTerm.trim())
          .where('name', isLessThanOrEqualTo: "${searchTerm.trim()}\uf8ff")
          .get();

      return querySnapshot;
    } catch (error) {
      print('Error fetching data of getByUserInitialLetter: $error');
    }
  }

  Future<List<String>?> fetchDocIdsWithFieldValue(
      {required String fieldName, required String fieldValue}) async {
    try {
      QuerySnapshot querySnapshot = await _store
          .collection('chat_rooms')
          .where(fieldName, isEqualTo: fieldValue)
          .get();

      List<String> documentIds = [];

      querySnapshot.docs.forEach((doc) {
        documentIds.add(doc.id);
      });

      return documentIds;
    } catch (e) {
      print('error $e');
    }
  }

  // get list of user if with whom current user has done chats
  Future<List<String>> getIdOfChattedUsers(
      {required String currentUserId}) async {
    List<String> listOfDocumentIds = [];

    List<String>? listOfIdsByUserOne = await fetchDocIdsWithFieldValue(
        fieldName: 'roomUser1', fieldValue: currentUserId);
    List<String>? listOfIdsByUserTwo = await fetchDocIdsWithFieldValue(
        fieldName: 'roomUser2', fieldValue: currentUserId);

    listOfDocumentIds = [...listOfIdsByUserOne!, ...listOfIdsByUserTwo!];

    List<String> documentId = [];

    // loop through each document to split the joined string from _ and add it in another list and make it unique
    listOfDocumentIds.forEach((element) {
      final splittedItem = element.split('_');
      splittedItem.forEach((element) {
        if (!documentId.contains(element)) {
          documentId.add(element);
        }
      });
    });

    // remove current user id
    documentId.remove(currentUserId);
    return documentId;
    // make list unique
    // List<String> uniqueDocIds = documentId.toSet().toList();
    // print('List $uniqueDocIds');
  }
}
