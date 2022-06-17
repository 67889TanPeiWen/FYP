import 'package:video_player/video_player.dart';
import 'package:flutter/material.dart';
import 'package:antibullying_suicideprevention/videoPlaying/basic_overlay.dart';


/*class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController videoController;

  const VideoPlayerWidget({Key? key, required this.videoController}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      videoController !=null && videoController.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo(),)
          :Container(child: CircularProgressIndicator(),);

  Widget buildVideo() => buildVideoPlayer();
  Widget buildVideoPlayer() => VideoPlayerWidget(videoController: videoController);

}*/

class VideoPlayerWidget extends StatelessWidget {
  final VideoPlayerController controller;

  const VideoPlayerWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      controller != null && controller.value.isInitialized
          ? Container(alignment: Alignment.topCenter, child: buildVideo())
          : Container(
        height: 200,
        child: Center(child: CircularProgressIndicator()),
      );

  Widget buildVideo() => Stack(
    children: <Widget>[
      buildVideoPlayer(),
      Positioned.fill(child: BasicOverlayWidget(controller: controller)),
    ],
  );

  Widget buildVideoPlayer() => AspectRatio(
    aspectRatio: controller.value.aspectRatio,
    child: VideoPlayer(controller),
  );
}