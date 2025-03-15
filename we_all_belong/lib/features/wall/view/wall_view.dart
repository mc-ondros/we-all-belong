import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:we_all_belong/features/wall/controller/wall_controller.dart';
import 'package:we_all_belong/components/specs/colors.dart';
import 'package:we_all_belong/components/specs/font_sizes.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class WallPage extends StatelessWidget {
  final WallController wallController = Get.put(WallController());

  WallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: GenericColors.background,
        title: const Text(
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
                  onPressed: () => wallController.addPost(wallController.postController.text),
                ),
              ],
            ),
          ),
          Expanded(
            child: Obx(
              () => Visibility(
                visible: wallController.posts.isNotEmpty,
                replacement: Column(
                  children: [
                    SvgPicture.network(
                      'https://www.svgrepo.com/show/194884/group-users.svg',
                      width: 100,
                      height: 100,
                      placeholderBuilder: (BuildContext context) => const LoadingIndicator(
                        indicatorType: Indicator.ballBeat,
                        colors: [Colors.white],
                      ),
                    ),
                    Text(
                      'No posts yet. Be the first to post!',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                child: ListView.builder(
                  itemCount: wallController.posts.length,
                  itemBuilder: (context, index) {
                    final post = wallController.posts[index];
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
                            child: Text(
                              '${post['name'] ?? 'guest'} says:',
                              style: const TextStyle(fontSize: 16, color: GenericColors.secondaryAccent),
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
          ),
        ],
      ),
    );
  }
}
