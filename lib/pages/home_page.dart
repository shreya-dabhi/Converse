import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/my_drawer.dart';
import '../data/fire_store.dart';
import 'chat_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // instance of auth
  final _auth = FirebaseAuth.instance;
  final FireStoreDb _fireStoreDb = FireStoreDb();
  final TextEditingController searchNameController = TextEditingController();
  Map<String, dynamic> userDetails = {};
  bool isSearchPressed = false;
  bool isSearchResultFound = true;
  var queryResultSet = [];
  List<String> listOfOtherUserId = [];

  void getCurrentUserDetail() async {
    userDetails = await _fireStoreDb.getCurrentUserDetails();
    setState(() {});
  }

  void fetchChattedUserId() async {
    listOfOtherUserId = await _fireStoreDb.getIdOfChattedUsers(
        currentUserId: _auth.currentUser!.uid);
    print('IniState print called : $listOfOtherUserId');
    setState(() {});
  }

  void initiateSearch(String value) async {
    QuerySnapshot? querySnapshot =
        await _fireStoreDb.getByUserInitialLetter(value);

    if (value.trim() != "") {
      if (querySnapshot!.docs.isNotEmpty) {
        for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
          setState(() {
            isSearchResultFound = true;
            queryResultSet.add(documentSnapshot.data());
          });
        }
      } else {
        setState(() {
          isSearchResultFound = false;
        });
        print('no record found');
      }
    } else {
      print('Search term is empty. No documents fetched.');
    }
  }

  void clearTheStateOfSearch() {
    setState(() {
      isSearchPressed = false;
      searchNameController.text = '';
      queryResultSet.clear();
    });
  }

  void rebuildWidget() {
    // clear all searched things when chat page is disposed
    clearTheStateOfSearch();
    fetchChattedUserId();
  }

  @override
  void initState() {
    // fetch all the detail of user
    getCurrentUserDetail();
    fetchChattedUserId();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        centerTitle: true,
        title: isSearchPressed
            ? TextField(
                controller: searchNameController,
                cursorColor: Colors.white,
                autofocus: true,
                onChanged: (value) {
                  setState(() {
                    queryResultSet.clear();
                  });
                  initiateSearch(value);
                },
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search by user name..',
                  hintStyle: TextStyle(
                      color: Colors.white54,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w800),
                ),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                ),
              )
            : const Text(
                'CONVERSE',
                style: TextStyle(
                  letterSpacing: 1,
                ),
              ),
        actions: [
          Padding(
            padding: EdgeInsets.all(10),
            child: isSearchPressed
                ? GestureDetector(
                    onTap: () {
                      searchNameController.clear();
                      setState(() {
                        isSearchPressed = false;
                      });
                    },
                    child: const Icon(
                      Icons.clear,
                    ),
                  )
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        isSearchPressed = true;
                      });
                    },
                    child: const Icon(
                      Icons.search_rounded,
                    ),
                  ),
          )
        ],
      ),
      drawer: isSearchPressed ? null : MyDrawer(userDetails: userDetails),
      body: searchNameController.text.isNotEmpty
          ? isSearchResultFound
              ?
              // show available users list in card
              ListView.builder(
                  itemBuilder: (context, index) =>
                      _buildResultCard(queryResultSet[index]),
                  itemCount: queryResultSet.length,
                )
              : Center(
                  child: Text(
                    'No results found.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                )
          :
          // show existing chat list
          listOfOtherUserId.isNotEmpty
              ? _buildUserList()
              : Center(
                  child: Text(
                    'Chat up with someone.',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 19,
                    ),
                  ),
                ),
    );
  }

  // build result card after searching..
  Widget _buildResultCard(dynamic data) {
    return GestureDetector(
      onTap: () {
        // go to that specific chat room & pass the user'Id 's chat page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverUserImageURL: data['imageURL'].toString(),
              receiverUserName: data['name'],
              receiverUserId: data['uid'],
            ),
          ),
        ).then((value) => {rebuildWidget()});
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 13, left: 10, right: 10),
        child: Material(
          elevation: 2.0,
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  backgroundImage: data['imageURL'] != null
                      ? NetworkImage(
                          data['imageURL'],
                        )
                      : null,
                  radius: 26,
                  child: data['imageURL'] == null
                      ? const Icon(
                          Icons.person,
                          color: Colors.white,
                        )
                      : null,
                ),
                const SizedBox(
                  width: 20.0,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      // 'name',
                      data['name'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Text(
                      // 'email',
                      data['email'],
                      style: const TextStyle(
                          color: Colors.black,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // build a list of users except for the current logged user
  Widget _buildUserList() {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .where('uid', whereIn: listOfOtherUserId!)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            setState(() {});
            return const Text('Error');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: Text(
                'Loading...',
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            );
          }

          return ListView(
            children: snapshot.data!.docs
                .map((doc) => _buildUserListItem(doc))
                .toList(),
          );
        });
  }

  // build individual user list item
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    return Container(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 8),
      margin: const EdgeInsets.only(left: 8, right: 8, top: 15),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadiusDirectional.circular(10),
      ),
      child: ListTile(
        leading: CircleAvatar(
          radius: 26,
          backgroundColor: Theme.of(context).colorScheme.primary,
          backgroundImage:
              data['imageURL'] != null ? NetworkImage(data['imageURL']) : null,
          child: data['imageURL'] == null
              ? const Icon(
                  Icons.person,
                  color: Colors.white,
                )
              : null,
        ),
        title: Text(data['name']),
        onTap: () {
          // pass the user'Id 's chat page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverUserImageURL: data['imageURL'].toString(),
                receiverUserName: data['name'],
                receiverUserId: data['uid'],
              ),
            ),
          ).then((value) => {
                // clear all searched things when chat page is disposed
                clearTheStateOfSearch()
              });
        },
      ),
    );
  }
}
