import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class VideoCallPage extends StatefulWidget {
  final String channelName;
  final String doctorId;

  const VideoCallPage({Key? key, required this.channelName, required this.doctorId}) : super(key: key);

  @override
  State<VideoCallPage> createState() => _VideoCallPageState();
}

class _VideoCallPageState extends State<VideoCallPage> {
  late final RtcEngine _engine;
  bool _joined = false;
  int? _remoteUid;

  String? _doctorName;
  String? _doctorProfileUrl;

  static const _appId = '4f9cfcdb1c6d42be8c188fda9a007da7';
  static const _tempToken = null; // If App Certificate is disabled, keep null

  @override
  void initState() {
    super.initState();
    _fetchDoctorDetails();
    _initAgora();
  }

  Future<void> _fetchDoctorDetails() async {
    try {
      final profileResponse = await Supabase.instance.client
          .from('profiles')
          .select('name')
          .eq('id', widget.doctorId)
          .maybeSingle();

      final doctorResponse = await Supabase.instance.client
          .from('doctors')
          .select('profile_image')
          .eq('id', widget.doctorId)
          .maybeSingle();

      setState(() {
        _doctorName = profileResponse?['name'] as String?;
        _doctorProfileUrl = doctorResponse?['profile_image'] as String?;
      });
    } catch (e) {
      print('Error fetching doctor details: $e');
    }
  }

  Future<void> _initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine.initialize(RtcEngineContext(appId: _appId));

    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() => _joined = true);
        },
        onUserJoined: (connection, uid, elapsed) {
          setState(() => _remoteUid = uid);
        },
        onUserOffline: (connection, uid, reason) {
          setState(() => _remoteUid = null);
        },
      ),
    );

    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
      token: _tempToken,
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
      appBar: AppBar(title: Text('Consulting: ${_doctorName ?? 'Doctor'}')),
      body: Stack(
        children: [
          _renderRemoteVideo(),
          _renderLocalPreview(),
        ],
      ),
    );
  }

  Widget _renderLocalPreview() {
    if (_joined) {
      return Positioned(
        bottom: 20,
        right: 20,
        width: 120,
        height: 160,
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.blueAccent),
          ),
          child: AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: _engine,
              canvas: const VideoCanvas(uid: 0),
            ),
          ),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return Stack(
        children: [
          AgoraVideoView(
            controller: VideoViewController.remote(
              rtcEngine: _engine,
              canvas: VideoCanvas(uid: _remoteUid),
              connection: RtcConnection(channelId: widget.channelName),
            ),
          ),
          Positioned(
            top: 40,
            left: 20,
            child: Row(
              children: [
                if (_doctorProfileUrl != null)
                  CircleAvatar(
                    backgroundImage: NetworkImage(_doctorProfileUrl!),
                  ),
                const SizedBox(width: 8),
                Text(
                  _doctorName ?? 'Doctor',
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for the doctor to join...',
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey),
        ),
      );
    }
  }
}
