import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_all_belong/features/wall/controller/wall_controller.dart';
import 'package:we_all_belong/components/specs/colors.dart';
import 'package:we_all_belong/components/specs/font_sizes.dart';
import 'package:we_all_belong/features/wall/chatrooms/chatroom_view.dart';

class ChatroomList extends StatelessWidget {
  ChatroomList({super.key});
  final WallController wallController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GenericColors.background,
        title: const Text(
          'Chatrooms',
          style: TextStyle(
            color: GenericColors.secondaryAccent,
            fontSize: FontSizes.f_20,
          ),
        ),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: wallController.chatroomNameController,
                  decoration: InputDecoration(
                    hintText: 'Create a chatroom...',
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: GenericColors.highlightBlue),
                onPressed: () => wallController.createChatroom(wallController.chatroomNameController.text),
              ),
            ],
          ),
        ),
        Expanded(
          child: Obx(
            () => ListView.builder(
              itemCount: wallController.chatrooms.length,
              itemBuilder: (context, index) {
                final chatroom = wallController.chatrooms[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  color: GenericColors.background,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: const BorderSide(color: GenericColors.highlightBlue),
                  ),
                  child: ListTile(
                    title: Text(
                      chatroom['name'],
                      style: const TextStyle(fontSize: FontSizes.f_18, color: GenericColors.secondaryAccent),
                    ),
                    onTap: () => Get.to(ChatRoomPage(chatroomId: chatroom['id'], chatroomName: chatroom['name'])),
                  ),
                );
              },
            ),
          ),
        ),
      ]),
    );
  }
}
