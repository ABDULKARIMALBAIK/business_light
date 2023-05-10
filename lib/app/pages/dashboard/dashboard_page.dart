import 'package:dyn_mouse_scroll/dyn_mouse_scroll.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' as material;

import '../../../domain/entity/payment.dart';
import '../../../domain/entity/payout.dart';
import '../../../services/di/injection.dart';
import '../../viewmodels/dashboard_view_model.dart';

// ignore: must_be_immutable
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardViewModel viewModel;

  @override
  void initState() {
    viewModel = getItClient.get<DashboardViewModel>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: viewModel.loadData(),
        builder: (context, snapshot) {
          if (viewModel.paymentsData.isEmpty || viewModel.payoutsData.isEmpty) {
            return const SizedBox();
          }
          return DynMouseScroll(
              builder: (context, scrollController, physics) =>
                  ScrollConfiguration(
                    behavior: const FluentScrollBehavior(),
                    child: ScaffoldPage.scrollable(
                      scrollController: scrollController,
                      ////////////// * Header * /////////////
                      header: header(context),
                      children: [
                        const SizedBox(height: 12),
                        ////////////// * Payments Section * /////////////
                        Text(
                          'payment_header'.tr(),
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
                        const SizedBox(height: 7),
                        ////////////// * Payments Cards * /////////////
                        paymentsCards(context),
                        const SizedBox(height: 20),

                        ////////////// * Payments Data * /////////////
                        Text(
                          'dashboard_last_payments'.tr(),
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        payments5LastData(context),
                        const SizedBox(height: 45),

                        ////////////// * Payouts Section * /////////////
                        Text(
                          'payout_header'.tr(),
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
                        const SizedBox(height: 7),
                        ////////////// * Payouts Cards * /////////////
                        payoutsCards(context),
                        const SizedBox(height: 20),

                        ////////////// * Payouts Data * /////////////
                        Text(
                          'dashboard_last_payouts'.tr(),
                          style: FluentTheme.of(context).typography.subtitle,
                        ),
                        const SizedBox(
                          height: 7,
                        ),
                        payouts5LastData(context),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ));
        });
  }

  Widget dataCard(BuildContext context, String title, double price) {
    return Card(
        padding: const EdgeInsets.symmetric(horizontal: 62, vertical: 24),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: FluentTheme.of(context)
                  .typography
                  .bodyLarge!
                  .copyWith(color: FluentTheme.of(context).accentColor),
            ),
            const SizedBox(
              height: 6,
            ),
            Text(
              '$price \$',
              textAlign: TextAlign.center,
              style: FluentTheme.of(context)
                  .typography
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
          ],
        ));
  }

  header(BuildContext context) {
    return PageHeader(
      title: Text('dashboard_header'.tr()),
    );
  }

  Widget paymentsCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          spacing: 20,
          runSpacing: 20,
          runAlignment: WrapAlignment.center,
          children: [
            dataCard(context, 'dashboard_card_today'.tr(),
                viewModel.paymentsData[0].price ?? 0),
            dataCard(context, 'dashboard_card_yesterday'.tr(),
                viewModel.paymentsData[1].price ?? 0),
            dataCard(context, 'dashboard_card_week'.tr(),
                viewModel.paymentsData[2].price ?? 0),
            dataCard(context, 'dashboard_card_month'.tr(),
                viewModel.paymentsData[3].price ?? 0)
          ],
        ),
      ),
    );
  }

  Widget payments5LastData(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(4.0),
        child: Builder(builder: (context) {
          if (viewModel.paymentsLast5Days.isEmpty) {
            return Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
                child: Text(
                  "✨  ${'bloc_widgets_noData'.tr()}  ✨",
                  style: FluentTheme.of(context).typography.bodyLarge,
                ),
              ),
            );
          } else {
            return SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: ListView.builder(
                itemCount: viewModel.paymentsLast5Days.length,
                scrollDirection: Axis.horizontal,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                physics: const material.BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  Payment payment =
                      viewModel.paymentsLast5Days.elementAt(index);
                  return paymentDataCard(context, payment);
                },
              ),
            );
          }
        }));
  }

  Widget paymentDataCard(BuildContext context, Payment payment) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(
              '#${payment.code ?? ''}',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FluentTheme.of(context).accentColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${payment.price.toString()} \$',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context)
                  .typography
                  .subtitle!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${'date'.tr()}: ${DateFormat('yyyy-MM-dd hh:mm').format(payment.date ?? DateTime.now())}',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context)
                  .typography
                  .caption!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }

  Widget payoutsCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        child: Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          direction: Axis.horizontal,
          spacing: 20,
          runSpacing: 20,
          runAlignment: WrapAlignment.center,
          children: [
            dataCard(context, 'dashboard_card_today'.tr(),
                viewModel.payoutsData[0].price ?? 0),
            dataCard(context, 'dashboard_card_yesterday'.tr(),
                viewModel.payoutsData[1].price ?? 0),
            dataCard(context, 'dashboard_card_week'.tr(),
                viewModel.payoutsData[2].price ?? 0),
            dataCard(context, 'dashboard_card_month'.tr(),
                viewModel.payoutsData[3].price ?? 0)
          ],
        ),
      ),
    );
  }

  Widget payouts5LastData(BuildContext context) {
    return Builder(builder: (context) {
      if (viewModel.payoutsLast5Days.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 100),
            child: Text(
              "✨  ${'bloc_widgets_noData'.tr()}  ✨",
              style: FluentTheme.of(context).typography.bodyLarge,
            ),
          ),
        );
      } else {
        return Padding(
            padding: const EdgeInsets.all(4.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 150,
              child: ListView.builder(
                itemCount: viewModel.payoutsLast5Days.length,
                scrollDirection: Axis.horizontal,
                addAutomaticKeepAlives: true,
                addRepaintBoundaries: true,
                padding: const EdgeInsets.symmetric(horizontal: 4),
                physics: const material.BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  Payout payout = viewModel.payoutsLast5Days.elementAt(index);
                  return payoutDataCard(context, payout);
                },
              ),
            ));
      }
    });
  }

  Widget payoutDataCard(BuildContext context, Payout payout) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        child: Wrap(
          direction: Axis.vertical,
          alignment: WrapAlignment.start,
          crossAxisAlignment: WrapCrossAlignment.start,
          spacing: 8,
          runSpacing: 8,
          children: [
            Text(
              '#${payout.code ?? ''}',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context).typography.bodyLarge!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: FluentTheme.of(context).accentColor),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              '${payout.price.toString()} \$',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context)
                  .typography
                  .subtitle!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Text(
              '${'date'.tr()}: ${DateFormat('yyyy-MM-dd hh:mm').format(payout.date ?? DateTime.now())}',
              textAlign: TextAlign.start,
              style: FluentTheme.of(context)
                  .typography
                  .caption!
                  .copyWith(fontStyle: FontStyle.italic),
            ),
          ],
        ),
      ),
    );
  }
}
