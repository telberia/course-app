import 'package:flutter/material.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'dart:convert'; // Added for jsonDecode
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  // Danh sách khóa học và file PDF/audio nhập tay
  final List<Map<String, dynamic>> lessons = [
    {
      'name': 'Lesson 1',
      'pdf': 'assets/App/Lektion_1/vt1_eBook_Lektion_1.pdf',
      'audio': [
        'assets/App/Lektion_1/Tab 1_1 - Grußformeln und Befinden - informell.mp3',
        'assets/App/Lektion_1/Tab 1_2 - Grußformeln und Befinden - formell.mp3',
        'assets/App/Lektion_1/Tab 1_3 - Vorstellung - informell.mp3',
        'assets/App/Lektion_1/Tab 1_4 - Vorstellung - formell.mp3',
        'assets/App/Lektion_1/Tab 1_5 - Vorstellung - Alternative.mp3',
        'assets/App/Lektion_1/Tab 1_8 - Ergänzung zum Dialog.mp3',
        'assets/App/Lektion_1/Audio_E1_1.mp3',
        'assets/App/Lektion_1/audio_1_6.mp3',
        'assets/App/Lektion_1/audio_1_7.mp3',
      ],
    },
    {
      'name': 'Lesson 2',
      'pdf': 'assets/App/Lektion_2/vt1_eBook_Lektion_2.pdf',
      'audio': [
        'assets/App/Lektion_2/Audio 2_12 - Text - Ich bin Studentin.mp3',
        'assets/App/Lektion_2/Audio E2_1.mp3',
        'assets/App/Lektion_2/audio_2_11.mp3',
        'assets/App/Lektion_2/Tab 2_1 - Regionale Begrüßungen - ugs.mp3',
        'assets/App/Lektion_2/Tab 2_10 - Elliptische Gegenfrage - informell und formell.mp3',
        'assets/App/Lektion_2/Tab 2_13 - Verabschiedungen.mp3',
        'assets/App/Lektion_2/Tab 2_2 - Begrüßungen.mp3',
        'assets/App/Lektion_2/Tab 2_3 - Alter und Hobbys - informell.mp3',
        'assets/App/Lektion_2/Tab 2_4 - Alter und Hobbys - formell.mp3',
        'assets/App/Lektion_2/Tab 2_5 - Arbeit - informell.mp3',
        'assets/App/Lektion_2/Tab 2_6 - Arbeit - formell.mp3',
        'assets/App/Lektion_2/Tab 2_7 - Studium - informell und formell.mp3',
        'assets/App/Lektion_2/Tab 2_8 - Studium - Verneinung_arbeiten und studieren.mp3',
        'assets/App/Lektion_2/Tab 2_9 - Berufliche Situation - Alternativen.mp3',
      ],
    },
    // Thêm các lesson khác ở đây nếu muốn
  ];

  void _showUserInfoDialog() {
    final user = Supabase.instance.client.auth.currentUser;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Benutzerinformationen'),
        content: user == null
            ? const Text('Keine Benutzerdaten gefunden')
            : Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('E-Mail: ${user.email}'),
                  Text('Benutzer-ID: ${user.id}'),
                ],
              ),
        actions: [
          TextButton(
            onPressed: () async {
              await Supabase.instance.client.auth.signOut();
              if (mounted) {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            child: const Text('Abmelden'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kursliste'),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: _showUserInfoDialog,
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];
          return ListTile(
            title: Text(lesson['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LessonDetailPage(
                    lessonName: lesson['name'],
                    pdfPath: lesson['pdf'],
                    audioFiles: List<String>.from(lesson['audio']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class LessonDetailPage extends StatefulWidget {
  final String lessonName;
  final String pdfPath;
  final List<String> audioFiles;
  const LessonDetailPage({Key? key, required this.lessonName, required this.pdfPath, required this.audioFiles}) : super(key: key);

  @override
  State<LessonDetailPage> createState() => _LessonDetailPageState();
}

class _LessonDetailPageState extends State<LessonDetailPage> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  Duration _audioDuration = Duration.zero;
  Duration _audioPosition = Duration.zero;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) {
      _audioPlayer.onDurationChanged.listen((d) {
        setState(() => _audioDuration = d);
      });
      _audioPlayer.onPositionChanged.listen((p) {
        setState(() => _audioPosition = p);
      });
      _audioPlayer.onPlayerStateChanged.listen((state) {
        setState(() => _isPlaying = state == PlayerState.playing);
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio(String audioPath) {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio wird nur auf Mobilgeräten unterstützt')),
      );
    } else {
      _audioPlayer.stop();
      _audioPlayer.play(AssetSource(audioPath));
    }
  }

  void _stopAudio() {
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Audio wird nur auf Mobilgeräten unterstützt')),
      );
    } else {
      _audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.lessonName)),
      body: Column(
        children: [
          ListTile(
            title: const Text('PDF anzeigen'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PDFViewPage(pdfAssetPath: widget.pdfPath),
                ),
              );
            },
          ),
          const Divider(),
          const Text('Audiodateien', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: widget.audioFiles.isEmpty
                ? const Center(child: Text('Keine Audiodateien'))
                : ListView.builder(
                    itemCount: widget.audioFiles.length,
                    itemBuilder: (context, index) {
                      final audio = widget.audioFiles[index];
                      final audioName = audio.split('/').last;
                      return ListTile(
                        title: Text(audioName),
                        subtitle: _isPlaying
                            ? Column(
                                children: [
                                  Slider(
                                    min: 0,
                                    max: _audioDuration.inMilliseconds.toDouble(),
                                    value: _audioPosition.inMilliseconds.clamp(0, _audioDuration.inMilliseconds).toDouble(),
                                    onChanged: (value) async {
                                      final position = Duration(milliseconds: value.toInt());
                                      if (!kIsWeb) {
                                        await _audioPlayer.seek(position);
                                      }
                                    },
                                  ),
                                  Text(
                                    "${_audioPosition.inMinutes}:${(_audioPosition.inSeconds % 60).toString().padLeft(2, '0')} / ${_audioDuration.inMinutes}:${(_audioDuration.inSeconds % 60).toString().padLeft(2, '0')}",
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                ],
                              )
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow),
                              onPressed: () => _playAudio(audio),
                              tooltip: 'Abspielen',
                            ),
                            IconButton(
                              icon: const Icon(Icons.stop),
                              onPressed: _stopAudio,
                              tooltip: 'Stopp',
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class PDFViewPage extends StatelessWidget {
  final String pdfAssetPath;
  const PDFViewPage({Key? key, required this.pdfAssetPath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Scaffold(
        appBar: AppBar(title: const Text('PDF anzeigen')),
        body: const Center(child: Text('PDF-Anzeige nur auf Mobilgeräten unterstützt')), 
      );
    } else {
      // Mobile: dùng flutter_pdfview như cũ
      return Scaffold(
        appBar: AppBar(title: const Text('PDF anzeigen')),
        body: FutureBuilder<String>(
          future: _copyAssetToTemp(pdfAssetPath),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData) {
              return const Center(child: Text('PDF-Datei nicht gefunden'));
            }
            return PDFView(
              filePath: snapshot.data!,
            );
          },
        ),
      );
    }
  }

  Future<String> _copyAssetToTemp(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final dir = await Directory.systemTemp.createTemp();
    final file = File('${dir.path}/${assetPath.split('/').last}');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file.path;
  }
} 