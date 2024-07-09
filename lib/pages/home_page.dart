import 'package:flutter/material.dart';
import 'package:messaging_app/components/my_drawer.dart';
import 'package:messaging_app/components/user_title.dart';
import 'package:messaging_app/pages/chat_page.dart';
import 'package:messaging_app/services/auth/auth_service.dart';
import 'package:messaging_app/services/chat/chat_service.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  //chat and auth service
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        ),
        drawer: const MyDrawer(),
        body: _buildUserList() ,
    );
  }

  //building a list of users except current loged in

  Widget _buildUserList(){
    return StreamBuilder(
      stream: _chatService.getUsersStream(), 
      builder: (context, snapshot){
        //ERROr
        if(snapshot.hasError){
          return const Text("Error");
        }

        //loading
        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading...");
        }

        //return list view
        return ListView(
          children: snapshot.data!
          .map<Widget>((userData) => _buildUserListItem(userData, context)).toList(),
        );
      },
      );
  }

  //building individual list view for each user
  Widget _buildUserListItem(
    Map<String, dynamic> userData, BuildContext context){
    //display all users except current

    if(userData["email"] != _authService.getCurrentUser()!.email){
      return UserTitle(
      text: userData["email"],
      onTap: (){
        //tapping on user
        Navigator.push(
          context, 
          MaterialPageRoute(
            builder: (context) => ChatPage(
              receiverEmail: userData["email"], 
              receiverID: userData["uid"],
              )
            )
          );
      },
    );
    }else{
      return Container();
    }

  }
}