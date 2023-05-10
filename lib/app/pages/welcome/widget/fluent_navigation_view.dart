import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:business_light/app/pages/welcome/widget/window_buttons.dart';
import 'package:business_light/data/datasource/storage/storage_service.dart';
import 'package:business_light/services/router/routers.dart';
import 'package:business_light/utils/constants.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:go_router_flow/go_router_flow.dart';
import 'package:window_manager/window_manager.dart';

import '../../../../services/router/router_generator.dart';

class FluentNavigationView extends StatefulWidget {
  FluentNavigationView({
    super.key,
    required this.child,
    required this.shellContext,
    required this.state,
  });

  //! Variables
  final Widget child;
  final BuildContext? shellContext;
  final GoRouterState state;

  //! Keys & Nodes
  final viewKey = GlobalKey(debugLabel: 'Navigation View Key');
  final searchKey = GlobalKey(debugLabel: 'Search Bar Key');
  final searchFocusNode = FocusNode();
  final searchController = TextEditingController();

  //! List
  final List<NavigationPaneItem> navigationWidgetItems = [
    //PaneItemHeader(header: const Text('Surfaces')),
    //! Dashboard
    PaneItem(
      key: const Key('/'),
      icon: const Icon(FluentIcons.home),
      title: Text('navigation_view_text_dashboard'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.dashboardRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.dashboardName);
        }
      },
    ),
    //! Brands
    PaneItem(
      key: const Key('/brands'),
      icon: const Icon(FluentIcons.verified_brand),
      title: Text('navigation_view_text_brand'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.brandsRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.brandsName);
        }
      },
    ),
    //! Stores
    PaneItem(
      key: const Key('/stores'),
      icon: const Icon(FluentIcons.visuals_store),
      title: Text('navigation_view_text_store'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.storesRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.storesName);
        }
      },
    ),
    //! Products
    PaneItem(
      key: const Key('/products'),
      icon: const Icon(FluentIcons.product),
      title: Text('navigation_view_text_products'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.productsRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.productsName);
        }
      },
    ),
    //! Orders
    PaneItem(
      key: const Key('/orders'),
      icon: const Icon(FluentIcons.activate_orders),
      title: Text('navigation_view_text_orders'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.ordersRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.ordersName);
        }
      },
    ),
    //! Company
    PaneItem(
      key: const Key('/company'),
      icon: const Icon(FluentIcons.company_directory),
      title: Text('navigation_view_text_company'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.companyRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.companyName);
        }
      },
    ),
    //! Employees
    PaneItem(
      key: const Key('/employees'),
      icon: const Icon(FluentIcons.employee_self_service),
      title: Text('navigation_view_text_employees'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.employeesRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.employeesName);
        }
      },
    ),
    //! Customers
    PaneItem(
      key: const Key('/customers'),
      icon: const Icon(FluentIcons.diamond_user),
      title: Text('navigation_view_text_customer'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.customerRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.customerName);
        }
      },
    ),
    //! Payments
    PaneItem(
      key: const Key('/payments'),
      icon: const Icon(FluentIcons.payment_card),
      title: Text('navigation_view_text_payments'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.paymentsRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.paymentsName);
        }
      },
    ),
    //! Payouts
    PaneItem(
      key: const Key('/payouts'),
      icon: const Icon(FluentIcons.money),
      title: Text('navigation_view_text_payouts'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.payoutsRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.payoutsName);
        }
      },
    ),
    //! Settings
    PaneItem(
      key: const Key('/settings'),
      icon: const Icon(FluentIcons.settings),
      title: Text('navigation_view_text_settings'.tr()),
      body: const SizedBox.shrink(),
      // infoBadge: ,
      onTap: () {
        if (RouteGenerator.routerClient.location != Routers.settingsRoute) {
          RouteGenerator.routerClient.pushNamed(Routers.settingsName);
        }
      },
    ),
  ];

  @override
  State<StatefulWidget> createState() => _FluentNavigationView();
}

class _FluentNavigationView extends State<FluentNavigationView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    widget.searchController.dispose();
    widget.searchFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.shellContext != null) {
      if (RouteGenerator.routerClient.canPop() == false) {
        setState(() {});
      }
    }
    return NavigationView(
      // transitionBuilder: (child, animation) =>
      //     EntrancePageTransition(animation: animation, child: child),
      key: widget.viewKey,
      appBar: NavigationAppBar(
        automaticallyImplyLeading: false,
        leading: () {
          final enabled = widget.shellContext != null &&
              RouteGenerator.routerClient.canPop();

          final onPressed = enabled
              ? () {
                  if (RouteGenerator.routerClient.canPop()) {
                    context.pop();
                    setState(() {});
                  }
                }
              : null;
          return navigationPaneTheme(context, onPressed);
        }(),
        title: () {
          return title(context);
        }(),
        actions: windowButtons(context),
      ),
      pane: NavigationPane(
        indicator: const StickyNavigationIndicator(
          curve: Curves.easeIn,
          duration: Duration(milliseconds: 500),
        ),
        selected: _calculateSelectedIndex(context),
        // header: SizedBox(
        //   height: kOneLineTileHeight,
        //   child: BlocStateBuilder(
        //     cubit: DataHelper.messageCubit,
        //     builder: (context, state) {
        //       return Padding(
        //         padding: const EdgeInsets.symmetric(vertical: 12),
        //         child: Wrap(
        //           alignment: WrapAlignment.start,
        //           crossAxisAlignment: WrapCrossAlignment.center,
        //           children: [
        //             const Icon(FluentIcons.message_fill),
        //             const SizedBox(
        //               width: 12,
        //             ),
        //             Text(state.value)
        //           ],
        //         ),
        //       );
        //     },
        //   ),
        //   // child: ShaderMask(
        //   //   shaderCallback: (rect) {
        //   //     final color = appTheme.color.defaultBrushFor(
        //   //       theme.brightness,
        //   //     );
        //   //     return LinearGradient(
        //   //       colors: [
        //   //         color,
        //   //         color,
        //   //       ],
        //   //     ).createShader(rect);
        //   //   },
        //   //   child: const FlutterLogo(
        //   //     style: FlutterLogoStyle.horizontal,
        //   //     size: 80.0,
        //   //     textColor: Colors.white,
        //   //     duration: Duration.zero,
        //   //   ),
        //   // ),
        // ),
        displayMode: DataHelper.fluentDisplayMode,
        items: widget.navigationWidgetItems,
        autoSuggestBox: searchPageBox(),
        autoSuggestBoxReplacement: const Icon(FluentIcons.search),
        // footerItems: footerItems, //! Here using footer panes
      ),
      paneBodyBuilder: (item, child) {
        final name =
            item?.key is ValueKey ? (item!.key as ValueKey).value : null;
        return FocusTraversalGroup(
          key: ValueKey('body$name'),
          child: widget.child,
        );
      },

      onOpenSearch: () {
        // widget.searchFocusNode.requestFocus();
      },
      // paneBodyBuilder: (child) {
      //   final name =
      //       item?.key is ValueKey ? (item!.key as ValueKey).value : null;
      //   return FocusTraversalGroup(
      //     key: ValueKey('body$name'),
      //     child: widget.child,
      //   );
      // },
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    //! Content Index
    final location = RouteGenerator.routerClient.location;
    int indexOriginal = widget.navigationWidgetItems
        .where((element) => element.key != null)
        .toList()
        .indexWhere((element) => element.key == Key(location));

    if (indexOriginal == -1) {
      return 0;
    }

    return indexOriginal;

    //! Footer Index (Important Code)
    // if (indexOriginal == -1) {
    //   int indexFooter = footerItems
    //       .where((element) => element.key != null)
    //       .toList()
    //       .indexWhere((element) => element.key == Key(location));
    //   if (indexFooter == -1) {
    //     return 0;
    //   }
    //   return originalItems
    //           .where((element) => element.key != null)
    //           .toList()
    //           .length +
    //       indexFooter;
    // } else {
    //   return indexOriginal;
    // }
  }

  NavigationPaneTheme navigationPaneTheme(
      BuildContext context, Function()? onPressed) {
    return NavigationPaneTheme(
      data: NavigationPaneTheme.of(context).merge(NavigationPaneThemeData(
        unselectedIconColor: ButtonState.resolveWith((states) {
          if (states.isDisabled) {
            return ButtonThemeData.buttonColor(context, states);
          }
          return ButtonThemeData.uncheckedInputColor(
            FluentTheme.of(context),
            states,
          ).basedOnLuminance();
        }),
      )),
      child: Builder(
        builder: (context) => PaneItem(
          icon: const Center(child: Icon(FluentIcons.back, size: 12.0)),
          title: Text('app_name'.tr()),
          body: const SizedBox.shrink(),
        ).build(
          context,
          false,
          onPressed,
          displayMode: PaneDisplayMode.compact,
        ),
      ),
    );
  }

  DragToMoveArea title(BuildContext context) {
    return DragToMoveArea(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child: Text(
          'app_name'.tr(),
          style: FluentTheme.of(context).typography.bodyLarge,
        ),
      ),
    );
  }

  Widget windowButtons(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: ToggleSwitch(
              content: Text('app_bar_dark_mode'.tr()),
              checked: DataHelper.appTheme == 'dark',
              onChanged: (isDark) {
                StorageService service = StorageService();
                if (isDark) {
                  DataHelper.appTheme = 'dark';
                  service.globalBox.selectTheme('dark');
                  AdaptiveTheme.of(context).setDark();
                } else {
                  DataHelper.appTheme = 'light';
                  service.globalBox.selectTheme('light');
                  AdaptiveTheme.of(context).setLight();
                }
              },
            ),
          ),
          const WindowButtons(),
        ]);
  }

  AutoSuggestBox searchPageBox() {
    return AutoSuggestBox(
      key: widget.searchKey,
      // focusNode: widget.searchFocusNode,
      controller: widget.searchController,
      unfocusedColor: Colors.transparent,
      items: widget.navigationWidgetItems.whereType<PaneItem>().map((item) {
        assert(item.title is Text);
        final text = (item.title as Text).data!;
        return AutoSuggestBoxItem(
          label: text,
          value: text,
          onSelected: () {
            if (item.onTap != null) {
              item.onTap?.call();
              widget.searchController.clear();
            }
          },
        );
      }).toList(),
      trailingIcon: IgnorePointer(
        child: IconButton(
          onPressed: () {},
          icon: const Icon(FluentIcons.search),
        ),
      ),
      placeholder: 'navigation_search_text'.tr(),
    );
  }
}
