import 'package:fluent_ui/fluent_ui.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

/// Check Internet connection by 2 ways: Future and Stream
// ignore: must_be_immutable
class InternetService extends StatefulWidget {
  InternetService({super.key, required this.builder});

  Widget Function(BuildContext context, InternetConnectionStatus?) builder;

  /// Check Internet connection Future
  static Future<bool> check() async {
    bool result = await InternetConnectionChecker().hasConnection;
    return result;
  }

  @override
  State<StatefulWidget> createState() => _InternetServiceState();
}

/// Check Internet connection Stream
class _InternetServiceState extends State<InternetService> {
  // ignore: prefer_typing_uninitialized_variables
  var listener;

  @override
  void initState() {
    listener = InternetConnectionChecker().onStatusChange;
    super.initState();
  }

  @override
  void dispose() {
    listener.drain();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0),
      child: StreamBuilder<InternetConnectionStatus>(
        stream: listener,
        initialData: null,
        builder: ((context, snapshot) {
          if (snapshot.data == null) {
            return const Center(
              child: ProgressRing(),
            );
          } else {
            return widget.builder(context, snapshot.data);
          }
        }),
      ),
    );
  }
}
