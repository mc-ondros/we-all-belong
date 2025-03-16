import 'package:flutter/material.dart';
import 'package:we_all_belong/components/specs/colors.dart';
import 'package:get/get.dart';
import 'package:we_all_belong/features/wall/controller/wall_controller.dart';
import 'package:we_all_belong/features/profile/widgets/compact_user_labels_widget.dart';
import 'package:we_all_belong/core/models/user_profile_model.dart';

class ChatRoomPage extends StatefulWidget {
  final String chatroomId;
  final String chatroomName;

  const ChatRoomPage({super.key, required this.chatroomId, required this.chatroomName});

  @override
  State<ChatRoomPage> createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  final WallController wallController = Get.find();
  @override
  void initState() {
    wallController.fetchChatroomPostsApi(widget.chatroomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.chatroomName),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: wallController.chatroomPostList.length,
                itemBuilder: (context, index) {
                  final post = wallController.chatroomPostList[index];

                  final UserProfileModel? userProfile = post['userProfile'];

                  return Card(
                    margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: GenericColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: const BorderSide(color: GenericColors.highlightBlue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    '${post['name'] ?? 'guest'} says:',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: GenericColors.secondaryAccent,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              if (userProfile != null) ...[
                                const SizedBox(height: 4),
                                CompactUserLabelsWidget(
                                  userProfile: userProfile,
                                  maxLabels: 20,
                                  labelHeight: 20,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Text(
                            post['content'] ?? '',
                            style: const TextStyle(fontSize: 16, color: GenericColors.secondaryAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: wallController.chatroomPostController,
                    decoration: InputDecoration(
                      fillColor: Colors.black,
                      hintText: 'Write something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: GenericColors.highlightBlue),
                  onPressed: () async {
                    await wallController.addChatroomPost(
                      widget.chatroomId,
                      wallController.chatroomPostController.text,
                      wallController.profileController.userProfile.value?.uuid ?? '',
                    );
                    await wallController.fetchChatroomPostsApi(widget.chatroomId);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
