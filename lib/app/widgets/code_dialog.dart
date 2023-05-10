import 'package:barcode_widget/barcode_widget.dart';
import 'package:business_light/utils/app_color.dart';
import 'package:business_light/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';

/// Display a code in dialog
// ignore: must_be_immutable
class CodeDialog extends StatelessWidget {
  CodeDialog({super.key, required this.name, required this.code});

  String name;
  String code;

  @override
  Widget build(BuildContext context) {
    return ContentDialog(
      title: Text(name),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(
            height: 10,
          ),
          Text('product_codeDialog_content'.tr()),
          const SizedBox(
            height: 40,
          ),
          BarcodeWidget(
            barcode: Barcode.qrCode(),
            data: code,
            color: DataHelper.appTheme == 'dark'
                ? FluentColors.white
                : FluentColors.black,
            errorBuilder: (context, error) => Center(child: Text(error)),
          ),
          const SizedBox(
            height: 30,
          ),
        ],
      ),
      actions: [
        Button(
            child: Text('save'.tr()),
            onPressed: () => Navigator.pop<String>(context, 'save')),
        Button(
            child: Text('print'.tr()),
            onPressed: () => Navigator.pop<String>(context, 'print')),
        FilledButton(
            child: Text('cancel'.tr()),
            onPressed: () => Navigator.pop<String>(context, 'cancel')),
      ],
    );
  }
}
