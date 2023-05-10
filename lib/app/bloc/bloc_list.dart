import 'dart:developer';

import 'package:business_light/app/bloc/bloc_state_builder.dart';
import 'package:business_light/utils/toast.dart';
import 'package:equatable/equatable.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../services/dio/exceptions.dart';
import '../../utils/support/pagination_id.dart';
import '../widgets/bloc_widgets.dart';
import '../widgets/keep_alive.dart';

//////////////! * Abstract Bloc State * ///////////////
@immutable
//ignore: must_be_immutable
abstract class BlocListState extends Equatable {
  BlocListType type;

  BlocListState(this.type);
}

//////////////! * Bloc Initial State * ///////////////
// ignore: must_be_immutable
class BlocListInitialState extends BlocListState {
  BlocListInitialState(BlocListType newType) : super(newType);

  @override
  List<Object?> get props => [type];
}

//////////////! * Bloc Loading State * ///////////////
// ignore: must_be_immutable
class BlocListLoadingState extends BlocListState {
  BlocListLoadingState(BlocListType newType) : super(newType);

  @override
  List<Object?> get props => [type];
}

//////////////! * Bloc Loaded State * ///////////////
// ignore: must_be_immutable
class BlocListLoadedState extends BlocListState {
  BlocListLoadedState(BlocListType newType) : super(newType);

  @override
  List<Object?> get props => [type];
}

//////////////! * Bloc Loaded Again State * ///////////////
// ignore: must_be_immutable
class BlocListLoadedAgainState extends BlocListState {
  BlocListLoadedAgainState(BlocListType newType) : super(newType);

  @override
  List<Object?> get props => [type];
}

//////////////! * Bloc Error State * ///////////////
// ignore: must_be_immutable
class BlocListErrorState extends BlocListState {
  BlocListErrorState(BlocListType newType) : super(newType);

  @override
  List<Object?> get props => [type];
}

//////////////! * Bloc No Data State * ///////////////
// ignore: must_be_immutable
class BlocListNoDataState extends BlocListState {
  BlocListNoDataState(BlocListType newType) : super(newType);

  @override
  List<Object?> get props => [type];
}

//////////////! * BlocList Cubit * ///////////////
class BlocListCubit<T extends PaginationId> extends Cubit<BlocListState> {
  BlocListCubit({BlocListState? initState})
      : super(initState ?? BlocListInitialState(BlocListType.initial));

  List<T> data = [];
  bool _hasReachedMax = false;
  int _page = 0;
  int _lastId = 0;

  BlocListType getType() => state.type;
  void clearData() => data.clear();

  int get getPage => _page;
  int get getLastId => _lastId;
  bool get getHasReachedMax => _hasReachedMax;
  set setPage(int page) => _page = page;
  set setLastId(int lastId) => _lastId = lastId;
  set updateHasReachedMax(bool value) => _hasReachedMax = value;

  void updateState({required BlocListType newType}) {
    state.type = newType;
    switch (newType) {
      case BlocListType.initial:
        emit(BlocListInitialState(newType));
        break;
      case BlocListType.loading:
        emit(BlocListLoadingState(newType));
        break;
      case BlocListType.loaded:
        emit(BlocListLoadedState(newType));
        break;
      case BlocListType.loadedAgain:
        emit(BlocListLoadedAgainState(newType));
        break;
      case BlocListType.noData:
        emit(BlocListNoDataState(newType));
        break;
      case BlocListType.error:
        emit(BlocListErrorState(newType));
        break;
      default:
        emit(BlocListLoadedState(newType));
        break;
    }
  }
}

//////////////! * BlocList Class * ///////////////
// ignore: must_be_immutable
class BlocList<T extends PaginationId> extends StatefulWidget {
  BlocList(
      {super.key,
      required this.id,
      required this.cubit,
      required this.loadMoreCubit,
      required this.builder,
      required this.isRemoteData,
      this.disableState = false,
      this.showDebug = false,
      this.isPagination = false,
      this.loadingMoreIndicatorAlignment = Alignment.bottomCenter,
      this.loadingMoreIndicatorPadding = const EdgeInsets.all(15),
      this.loadingView,
      this.shimmerView,
      this.errorView,
      this.noDataView,
      this.noInternetView,
      this.onRetryFunction,
      this.onRefresh,
      this.onLoadMore});

  final String id;
  final BlocListCubit<T> cubit;
  final bool disableState;
  final bool isRemoteData;
  final bool isPagination;
  final bool showDebug;
  final Widget? loadingView;
  final Widget? shimmerView;
  final Widget? errorView;
  final Widget? noDataView;
  final Widget? noInternetView;
  final Function? onRetryFunction;
  final Function? onLoadMore;
  final Function? onRefresh;
  final BlocBody builder;
  final AlignmentGeometry loadingMoreIndicatorAlignment;
  final EdgeInsetsGeometry loadingMoreIndicatorPadding;
  // Future<List<T>> Function() fetchDataFunction;

  final BlocStateBuilderCubit loadMoreCubit;

  ScrollController scrollController = ScrollController();
  bool isLoading = false;

  @override
  State<StatefulWidget> createState() => _BlocListState<T>();
}

class _BlocListState<T extends PaginationId> extends State<BlocList<T>> {
  @override
  void initState() {
    widget.scrollController.addListener(_scrollListener);
    super.initState();
  }

  void _scrollListener() async {
    if (widget.isPagination) {
      if (widget.scrollController.position.atEdge &&
          !widget.isLoading &&
          !widget.cubit.getHasReachedMax) {
        final bool isTop = widget.scrollController.position.pixels == 0;
        if (!isTop && !widget.isLoading) {
          widget.isLoading = true;
          if (widget.onLoadMore != null) {
            widget.loadMoreCubit.change(true);
            await widget.onLoadMore!();
          }
        }
        widget.loadMoreCubit.change(false);
        widget.isLoading = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.isPagination
        ? RefreshIndicator(
            backgroundColor: FluentTheme.of(context).cardColor,
            color: FluentTheme.of(context).accentColor,
            onRefresh: () async {
              if (widget.onRefresh != null) {
                await widget.onRefresh!();
              }
            },
            child: Stack(
              children: [
                KeepAliveWidget(widget: _blocBuilder()),
                BlocStateBuilder(
                  cubit: widget.loadMoreCubit,
                  builder: (context, state) {
                    return Visibility(
                      visible: widget.loadMoreCubit.getIsChanged &&
                          widget.isPagination,
                      child: Align(
                        alignment: widget.loadingMoreIndicatorAlignment,
                        child: Padding(
                          padding: widget.loadingMoreIndicatorPadding,
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: CircleAvatar(
                                radius: 15,
                                backgroundColor:
                                    FluentTheme.of(context).cardColor,
                                child: ProgressRing(
                                    activeColor:
                                        FluentTheme.of(context).accentColor)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          )
        : _blocBuilder();
  }

  Widget _blocBuilder() {
    return BlocProvider<BlocListCubit>.value(
      value: widget.cubit,
      child: BlocBuilder<BlocListCubit, BlocListState>(
        buildWhen: (oldState, newState) => true,
        builder: (context, state) {
          //Debug the state
          if (widget.showDebug) {
            debugState();
          }

          if (widget.disableState) {
            return widget.builder(
                widget.cubit.state.type, widget.scrollController);
          } else {
            switch (state.type) {
              case BlocListType.initial:
                return widget.loadingView ?? BlocWidgets.loadingView(context);
              case BlocListType.loading:
                return widget.shimmerView ??
                    BlocWidgets.loadingView(context); //Use Shimmer (:
              case BlocListType.loaded:
                return widget.builder(
                    widget.cubit.state.type, widget.scrollController);
              case BlocListType.loadedAgain:
                return widget.builder(
                    widget.cubit.state.type, widget.scrollController);
              case BlocListType.noData:
                return widget.noDataView ??
                    BlocWidgets.noDataView(context, widget.onRetryFunction);
              case BlocListType.error:
                return widget.isRemoteData
                    ? (widget.noInternetView ??
                        BlocWidgets.noInternetView(
                            context, widget.onRetryFunction))
                    : (widget.errorView ??
                        BlocWidgets.errorView(context, widget.onRetryFunction));
              default:
                return widget.loadingView ?? BlocWidgets.loadingView(context);
            }
          }
        },
      ),
    );
  }

  debugState() {
    log('''
    BlocList______________________________________
      "Bloc Id": ${widget.id}\n
      "Bloc Type": ${widget.cubit.getType()}\n
      "Bloc hasReachedMax": ${widget.cubit.getHasReachedMax}\n
      "Bloc Last id": ${widget.cubit.getLastId}\n
      "Bloc Page": ${widget.cubit.getPage}\n
      "Bloc Data": ${widget.cubit.data.toString()}\n
    BlocList______________________________________
    ''');
  }
}

//////////////! * Request Type * ///////////////
enum RequestType { refresh, load, moreData }

//////////////! * BlocList Type * ///////////////
enum BlocListType { initial, loading, loaded, loadedAgain, noData, error }

//////////////! * Bloc List Mixin * ///////////////
mixin BlocListMixin<T extends PaginationId> {
  Future<void> fetchData(
      {required BuildContext context,
      required RequestType type,
      required BlocListCubit cubit,
      required BlocStateBuilderCubit loadMoreCubit,
      required Function fetchDataFunction}) async {
    //! Reset values
    if (type == RequestType.refresh || type == RequestType.load) {
      cubit.clearData();
      cubit.setPage = 0;
      cubit.setLastId = 0;
    }

    //! Loading show
    if (type == RequestType.refresh || type == RequestType.load) {
      cubit.updateState(newType: BlocListType.initial);
      await Future.delayed(const Duration(milliseconds: 2000));
    }

    //! Fetch data
    try {
      final List<T> data = await fetchDataFunction();

      //! Failed to get some data (Load & Refresh cases only)
      if (data.isEmpty && cubit.data.isEmpty) {
        cubit.updateHasReachedMax = false;
        // ignore: use_build_context_synchronously
        CustomInfoBar.showDefault(
            title: 'NO Data TO SHOW',
            severity: InfoBarSeverity.warning,
            context: context);
        cubit.updateState(newType: BlocListType.noData);
      }
      //! First Load or refresh case or load more
      else {
        //! Check if loading circle is appear
        if (loadMoreCubit.getIsChanged == true) {
          loadMoreCubit.change(false);
        }
        //! Check if reached the maximum number
        if (data.isEmpty && cubit.data.isNotEmpty) {
          cubit.updateHasReachedMax = true;
          // ignore: use_build_context_synchronously
          CustomInfoBar.showDefault(
              context: context,
              title: 'NO MORE DATA',
              severity: InfoBarSeverity.info);
        } else {
          cubit.updateHasReachedMax = false;
        }

        //! Show shimmer or loading (Load & Refresh cases only)
        if (data.isNotEmpty && cubit.data.isEmpty) {
          cubit.updateState(newType: BlocListType.loading); //Shimmer
          await Future.delayed(const Duration(milliseconds: 2000));
        }

        //! Set new data
        cubit.data.addAll(data);

        //! Add new last id to pagination
        if (cubit.data.isNotEmpty) {
          cubit.setLastId = cubit.data.last.lastId;
        }

        //! Add new page to pagination
        if (type == RequestType.moreData) {
          cubit.setPage = cubit.getPage + 1;
        } else {
          cubit.setPage = 1;
        }

        //! New state
        cubit.updateState(newType: BlocListType.loaded);
      }
    } on CustomException catch (e) {
      log("error fetch data: \n$e");
      cubit.updateHasReachedMax = false;
      if (loadMoreCubit.getIsChanged == true) {
        loadMoreCubit.change(false);
      }
      //! Error when get data and hasn't data => error view
      if (cubit.data.isEmpty) {
        cubit.updateState(newType: BlocListType.error);
      }
      //! Error when get data and has data already (loading more data for pagination is failed) => loaded view
      else {
        // No Thing here !
        // cubit.updateState(newType: BlocListType.loaded);
      }
      // ignore: use_build_context_synchronously
      CustomInfoBar.showError(
          error: e.error, severity: InfoBarSeverity.error, context: context);
    }
  }
}

//////////////! * Change The Principle * ///////////////
typedef BlocBody = Widget Function(
    BlocListType widgetState, ScrollController scrollController);
