import 'package:business_light/app/pages/welcome/widget/fluent_navigation_view.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:window_manager/window_manager.dart';

/// Main Page that handle all changes on screen (Use Window Manager)
class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.child,
    required this.shellContext,
    required this.state,
  });

  //! Variables
  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  @override
  State<StatefulWidget> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> with WindowListener {
  @override
  void initState() {
    windowManager.addListener(this);
    super.initState();
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    super.dispose();
  }

  @override
  void onWindowFocus() {
    // Make sure to call once.
    setState(() {});
    // do something
  }

  @override
  void onWindowEvent(String eventName) {
    // print('[WindowManager] onWindowEvent: $eventName');
  }

  @override
  Widget build(BuildContext context) {
    return FluentNavigationView(
      shellContext: widget.shellContext,
      state: widget.state,
      child: widget.child,
    );
  }

  @override
  void onWindowClose() async {
    bool isPreventClose = await windowManager.isPreventClose();
    if (isPreventClose) {
      // ignore: use_build_context_synchronously
      showDialog(
        context: context,
        builder: (_) {
          return ContentDialog(
            title: Text('close_contentDialog_title'.tr()),
            content: Text('close_contentDialog_content'.tr()),
            actions: [
              FilledButton(
                child: Text('close_contentDialog_yes'.tr()),
                onPressed: () {
                  Navigator.pop(context);
                  windowManager.destroy();
                },
              ),
              Button(
                child: Text('close_contentDialog_no'.tr()),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    }
  }
}
