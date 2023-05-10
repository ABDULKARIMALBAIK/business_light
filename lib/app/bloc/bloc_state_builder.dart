import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

//////////////! * Bloc State * ///////////////

@immutable
//ignore: must_be_immutable
abstract class AbstractBlocStateBuilderData extends Equatable {
  bool isChanged = false;
  // ignore: prefer_typing_uninitialized_variables
  dynamic value;

  AbstractBlocStateBuilderData(this.isChanged, this.value);
}

//ignore: must_be_immutable
class BlocStateBuilderData extends AbstractBlocStateBuilderData {
  BlocStateBuilderData(bool isChanged, dynamic value) : super(isChanged, value);

  void setValue(dynamic newValue) => value = newValue;

  @override
  List<Object?> get props => [isChanged, value];
}

//////////////! * Bloc Cubit * /////////////

class BlocStateBuilderCubit extends Cubit<BlocStateBuilderData> {
  BlocStateBuilderCubit({bool isChanged = false, dynamic value})
      : super(BlocStateBuilderData(isChanged, value));

  void change(bool isChanged) =>
      emit(BlocStateBuilderData(isChanged, state.value));
  void update() => emit(BlocStateBuilderData(!state.isChanged, ''));
  void changeValue(bool isChanged, dynamic newValue) =>
      emit(BlocStateBuilderData(isChanged, newValue));

  bool get getIsChanged => state.isChanged;
  dynamic get getValue => state.value;
}

//////////////! * Bloc State Builder Class * /////////////
// ignore: must_be_immutable
class BlocStateBuilder extends StatelessWidget {
  BlocStateBuilder({
    super.key,
    required this.builder,
    required this.cubit,
  });

  Widget Function(BuildContext context, BlocStateBuilderData state) builder;
  BlocStateBuilderCubit cubit;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<BlocStateBuilderCubit>.value(
      value: cubit,
      child: BlocBuilder<BlocStateBuilderCubit, BlocStateBuilderData>(
        buildWhen: (oldState, newState) => true,
        builder: builder,
      ),
    );
  }
}
