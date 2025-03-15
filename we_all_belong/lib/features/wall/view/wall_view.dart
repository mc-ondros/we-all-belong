import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:we_all_belong/features/wall/controller/wall_controller.dart';
import 'package:we_all_belong/components/specs/colors.dart';
import 'package:we_all_belong/components/specs/font_sizes.dart';

class WallPage extends StatelessWidget {
  final WallController wallController = Get.put(WallController());

  WallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: GenericColors.background,
        title: Text(
          'Community Wall',
          style: TextStyle(
            color: GenericColors.secondaryAccent,
            fontSize: FontSizes.f_20,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: wallController.postController,
                    decoration: InputDecoration(
                      hintText: 'Write something...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: GenericColors.highlightBlue),
                  onPressed: () => wallController.addPost(wallController.postController.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => ListView.builder(
                itemCount: wallController.posts.length,
                itemBuilder: (context, index) {
                  final post = wallController.posts[index];
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    color: GenericColors.background,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(color: GenericColors.highlightBlue),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '${post['name'] ?? 'guest'} says:',
                            style: TextStyle(fontSize: 16, color: GenericColors.secondaryAccent),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: Text(
                            post['content'] ?? '',
                            style: TextStyle(fontSize: 16, color: GenericColors.secondaryAccent),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
