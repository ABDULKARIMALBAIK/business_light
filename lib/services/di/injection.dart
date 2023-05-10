import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'injection.config.dart';

@InjectableInit()
Future<void> configureInjection(String environment) async =>
    // ignore: await_only_futures
    await getItClient.init(environment: environment);

//GetIt.instance.init(environment: environment);

//! Injection variable
final GetIt getItClient = GetIt.instance;

//! Environments Types
enum Env { dev, test, prod }

//! Environments Annotations (Like @dev), optional
// const dev = Environment('dev');
// const test = Environment('test');
// const prod = Environment('prod');
