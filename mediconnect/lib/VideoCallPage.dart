// VideoCallPage.dart
import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;

class VideoCallPage extends StatefulWidget {
  final String channelName;
  const VideoCallPage({Key? key, required this.channelName}) : super(key: key);

  @override
  _VideoCallPageState createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _engine;
  bool _joined = false;
  int? _remoteUid;
  static const _appId = '4f9cfcdb1c6d42be8c188fda9a007da7';

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  /// TODO: implement your token fetch logic
  Future<String> fetchRtcToken(String channel) async {
    // e.g. call your backend or Supabase Function
    throw UnimplementedError('Fetch token from server');
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: _appId));
    _engine.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) => setState(() => _joined = true),
      onUserJoined: (connection, uid, elapsed) => setState(() => _remoteUid = uid),
      onUserOffline: (connection, uid, reason) => setState(() => _remoteUid = null),
    ));
    await _engine.enableVideo();

    // choose one:
    final token = await fetchRtcToken(widget.channelName); // secure
    // final token = null; // if App Certificate disabled for testing

    await _engine.joinChannel(
      token: token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Call: ${widget.channelName}')),
      body: Stack(
        children: [
          if (_joined)
            AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: _engine,
                canvas: const VideoCanvas(uid: 0),
              ),
            )
          else
            const Center(child: CircularProgressIndicator()),

          if (_remoteUid != null)
            AgoraVideoView(
              controller: VideoViewController.remote(
                rtcEngine: _engine,
                canvas: VideoCanvas(uid: _remoteUid),
                connection: RtcConnection(channelId: widget.channelName),
              ),
            ),
        ],
      ),
    );
  }
}