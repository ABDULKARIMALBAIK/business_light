import 'package:business_light/app/widgets/support_widgets.dart';
import 'package:business_light/utils/resources_path.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

class BlocWidgets {
  static Widget loadingView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 200),
        child: ProgressRing(
          activeColor: FluentTheme.of(context).accentColor,
          backgroundColor: FluentTheme.of(context).scaffoldBackgroundColor,
        ),
      ),
    );
  }

  static Widget noDataView(BuildContext context, Function? onRetryFunction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultTopPadding(),
          SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset(ResourcesPath.noData,
                  width: 250,
                  height: 250)), //SvgPicture.asset(ResourcesPath.noData)
          const SizedBox(
            height: 30,
          ),
          Text('bloc_widgets_noData'.tr(),
              style: FluentTheme.of(context).typography.title,
              textAlign: TextAlign.center),
          const SizedBox(
            height: 30,
          ),
          FilledButton(
            onPressed: () => onRetryFunction != null ? onRetryFunction() : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('bloc_widgets_button_retry_text'.tr(),
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  static Widget noInternetView(
      BuildContext context, Function? onRetryFunction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultTopPadding(),
          SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset(ResourcesPath.noInternet,
                  width: 250,
                  height: 250)), //SvgPicture.asset(ResourcesPath.noInternet)
          const SizedBox(
            height: 30,
          ),
          Text('bloc_widgets_noInternet'.tr(),
              style: FluentTheme.of(context).typography.title,
              textAlign: TextAlign.center),
          const SizedBox(
            height: 30,
          ),
          Button(
            onPressed: onRetryFunction != null ? onRetryFunction() : null,
            child: Center(
              child: Text('bloc_widgets_button_retry_text'.tr(),
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }

  static Widget errorView(BuildContext context, Function? onRetryFunction) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          defaultTopPadding(),
          SizedBox(
              width: 250,
              height: 250,
              child: Lottie.asset(ResourcesPath.error,
                  width: 250,
                  height: 250)), //SvgPicture.asset(ResourcesPath.error)
          const SizedBox(
            height: 30,
          ),
          Text('bloc_widgets_error'.tr(),
              style: FluentTheme.of(context).typography.title,
              textAlign: TextAlign.center),
          const SizedBox(
            height: 30,
          ),
          Button(
            onPressed: onRetryFunction != null ? onRetryFunction() : null,
            child: Center(
              child: Text('bloc_widgets_button_retry_text'.tr(),
                  style: FluentTheme.of(context).typography.body,
                  textAlign: TextAlign.center),
            ),
          ),
        ],
      ),
    );
  }
}
