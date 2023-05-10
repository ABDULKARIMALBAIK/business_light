part of 'main.dart';

/// Method initialize app local database [StorageService] , [EasyLocalization] ,
/// [Theme] and dependency injection for the app
Future _preInitializations() async {
  //! Init Flutter Engine
  WidgetsFlutterBinding.ensureInitialized();
  //! Init EasyLocalization
  await EasyLocalization.ensureInitialized();
  //! Setup Android Portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  //! Setup Windows Configs
  // await flutter_acrylic.Window.initialize();
  await WindowManager.instance.ensureInitialized();
  const WindowOptions windowOptions = WindowOptions(
    size: Size(1200, 700), //755, 545
    minimumSize: Size(350, 600),
    fullScreen: false,
    center: true,
    skipTaskbar: false,
    titleBarStyle: TitleBarStyle.hidden,
  );
  await windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.setTitleBarStyle(
      TitleBarStyle.hidden,
      windowButtonVisibility: false,
    );
    await windowManager.setResizable(true);
    await windowManager.show();
    await windowManager.focus();
    await windowManager.setPreventClose(true);
  });

  //! Setup Injection
  await configureInjection(DataHelper.appInjectionType.name);
  //! Setup Local Storage (Offline)
  StorageService storageService = getItClient.get<StorageService>();
  await storageService.openDatabaseStore();

  //! Init DataHelper
  await initDataHelper(storageService);

  //! Create App Folder and all its folder inside
  await createBusinessLightFolder();

  //! Catch Exceptions
  _overrideErrorWidget();
}

/// Create Business Light folder and codes and excels inside
Future<void> createBusinessLightFolder() async {
  final directory = await getDownloadsDirectory();
  final path = directory!.path;
  // App Folder
  final appFolder = Directory(join(path, 'business_light'));
  if (!(await appFolder.exists())) {
    await appFolder.create();
  }

  // Codes Folder
  final codesFolder = Directory(join(path, 'business_light', 'codes'));
  if (!(await codesFolder.exists())) {
    await codesFolder.create();
  }

  // Excels Folder
  final excelsFolder = Directory(join(path, 'business_light', 'excels'));
  if (!(await excelsFolder.exists())) {
    await excelsFolder.create();
  }

  // Products Folder
  final productsFolder = Directory(join(path, 'business_light', 'products'));
  if (!(await productsFolder.exists())) {
    await productsFolder.create();
  }

  // Orders Folder
  final orderFolder = Directory(join(path, 'business_light', 'orders'));
  if (!(await orderFolder.exists())) {
    await orderFolder.create();
  }
}

/// Initial language and theme from the storage
Future<void> initDataHelper(StorageService store) async {
  DataHelper.appTheme = await store.globalBox.setupTheme();
  DataHelper.appLanguage = await store.globalBox.setupLanguage();
  DataHelper.appColor = await store.globalBox.setupColor();
}

/// Display error screen
void _overrideErrorWidget() {
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Fluent.ScaffoldPage(
      content: Fluent.Center(
        child: Fluent.SizedBox(
          width: 1000,
          height: 1000,
          child: Fluent.Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Fluent.SizedBox(
                  width: 250,
                  height: 250,
                  child: Lottie.asset(ResourcesPath.error,
                      width: 250,
                      height: 250)), //SvgPicture.asset(ResourcesPath.noData)
              const Fluent.SizedBox(
                height: 20,
              ),
              Fluent.Text(
                "error_text".tr(),
                style: const TextStyle(
                  fontSize: 24,
                ),
                overflow: TextOverflow.visible,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Fluent.SizedBox(
                width: 150,
                child: Fluent.FilledButton(
                  onPressed: () {
                    RouteGenerator.routerClient.goNamed(Routers.dashboardName);
                  },
                  child: Fluent.Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Fluent.Center(
                        child: Text(
                      'restart'.tr(),
                      style: const Fluent.TextStyle(fontSize: 14),
                    )),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  };
}
