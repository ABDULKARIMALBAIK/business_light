import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Display an description content in dialog
// ignore: must_be_immutable
class DescriptionDialog extends StatelessWidget {
  DescriptionDialog({super.key, required this.name, required this.description});

  String name;
  String description;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(name),
      content: SelectableText(description),
      actions: [
        FilledButton(
            child: Text('cancel'.tr()),
            onPressed: () => Navigator.pop(context, 'cancel')),
      ],
    );
  }
}
