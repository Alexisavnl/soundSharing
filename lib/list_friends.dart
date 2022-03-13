import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/userData.dart';

class ListFriends extends StatefulWidget {
  const ListFriends({Key? key}) : super(key: key);

  @override
  State<ListFriends> createState() => _ListFriendsState();
}

class _ListFriendsState extends State<ListFriends> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<List<UserData>>(context);
    friends.forEach((element) {
      print(element);
    });

    return ListView.builder(
      itemCount: friends.length,
      itemBuilder: (context, index) {
        return FriendTile(friend: friends[index]);
      },
    );
  }
}

class FriendTile extends StatelessWidget {
  final UserData friend;

  const FriendTile({required this.friend});

  @override
  Widget build(BuildContext context) {
    return Padding(padding: const EdgeInsets.only(top: 8.0),
      child: Card(
      margin: const EdgeInsets.fromLTRB(20.0,6.0,20.0,0.0),
        child: ListTile(
          title: Text(friend.firstName),
        ),

      ),
    );
  }

}
