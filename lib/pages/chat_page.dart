import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messaging_app/components/chat_bubble.dart';
import 'package:messaging_app/components/my_textfield.dart';
import 'package:messaging_app/services/auth/auth_service.dart';
import 'package:messaging_app/services/chat/chat_service.dart';

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;

  ChatPage({
    required this.receiverID,
    required this.receiverEmail,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final ChatService _chatService = ChatService();

  final AuthService _authService = AuthService();

  final TextEditingController _messageController = TextEditingController();

  //for textfield focus
  FocusNode myFocusNode = FocusNode();

  @override   
  void initState(){
    super.initState();

    //add listener to focus node
    myFocusNode.addListener((){
      if(myFocusNode.hasFocus){
        //cause delay so keyboard shows up
        //amount of time
        //then scrol down

        Future.delayed(
          const Duration(milliseconds: 500),
          () => scrollDown(),
          );
      }
    });

    //wait for listview to built then scroll to bottom
    Future.delayed(const Duration(milliseconds: 500), () => scrollDown(),);
  }

  @override  
  void dispose(){
    myFocusNode.dispose();
    _messageController.dispose();
    super.dispose();
  }

  //scroll controller
  final ScrollController _scrollController = ScrollController();
  void scrollDown(){
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent, 
      duration: const Duration(seconds: 1), 
      curve: Curves.fastOutSlowIn,
      );
  }

//send message
  void sendMessage() async {

    //if textfield empty or not
    if (_messageController.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, _messageController.text);
      _messageController.clear();
    }

    scrollDown();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        title:  Text(widget.receiverEmail),
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.grey,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Column(
        children: [

          //display all messages
          Expanded(

            child: _buildMessageList(),
          ),
          _buildUserInput(),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    String senderID = _authService.getCurrentUser()!.uid;
    return StreamBuilder(
      stream: _chatService.getMessages(widget.receiverID, senderID), 
      builder: (context, snapshot){
        // errors
        if(snapshot.hasError){
          return const Text("Error");
        }

        //loading

        if(snapshot.connectionState == ConnectionState.waiting){
          return const Text("Loading....");
        }

        //return List view
        return ListView(
          controller: _scrollController,
          children: snapshot.data!.docs.map((doc) => _buildMessageItem(doc)).toList(),
        );
      }
    );
  }

  Widget _buildMessageItem(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    // Determine if the message sender is the current user
    bool isCurrentUser = data['senderID'] == _authService.getCurrentUser()!.uid;

    // Set alignment based on whether current user sent the message or not
    var alignment = isCurrentUser ? Alignment.centerRight : Alignment.centerLeft;

    return Container(
      alignment: alignment,
      child: Column(
        crossAxisAlignment:
            isCurrentUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        ChatBubble(
          isCurrentUser: isCurrentUser,
          message: data["message"]
          )
      ],
      ),
    );
  }

  Widget _buildUserInput() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: MyTextfield(
              controller: _messageController,
              obscureText: false,
              focusNode: myFocusNode,
              hintText: "Type a message",
                
              ),
            ),
        
          Container(
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
              ),
              margin: const EdgeInsets.only(right: 25),
            child: IconButton(
              onPressed: sendMessage,
              icon: const Icon(Icons.send),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
