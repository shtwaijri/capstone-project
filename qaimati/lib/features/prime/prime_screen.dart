import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moyasar/moyasar.dart';
import 'package:qaimati/features/nav/navigation_bar_screen.dart';
import 'package:qaimati/features/prime/bloc/payment_bloc.dart';
import 'package:qaimati/features/prime/payment_screen.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/buttom_widget.dart';
import 'package:qaimati/widgets/loading_widget.dart';

class PrimeScreen extends StatelessWidget {
  const PrimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PaymentBloc()..add(RemainingPrimeDays()),
      child: Builder(
        builder: (context) {
          final bloc = context.read<PaymentBloc>();
          return Scaffold(
            appBar: AppBarWidget(
              title: tr('Subspriction'),
              showActions: true,
              showSearchBar: false,
              showBackButton: false,
            ),

            body: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.25,

                      child: Image.asset("assets/image/qaimaty-logo.png"),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width * 0.0005),

                    Text(
                      tr("Qaiamtiprime"),
                      style: StyleText.bold24(
                        context,
                      ).copyWith(color: StyleColor.green),
                    ),
                  ],
                ),
                SizedBox(height: MediaQuery.of(context).size.height * 0.05),
                Padding(
                  padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.04,
                  ),
                  child: BlocBuilder<PaymentBloc, PaymentState>(
                    builder: (context, state) {
                      if (state is SubscribedState) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),

                            Icon(
                              CupertinoIcons.star_fill,
                              color: StyleColor.green,
                              size: 28,
                            ),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.05,
                            ),
                            Expanded(
                              child: Text(
                                '${'subscription_start'.tr()} ${bloc.remainingDay} ${'subscription_end'.tr()}',
                                style: StyleText.bold16(context),
                              ),
                            ),
                          ],
                        );
                      }
                      if (state is NotSubscribedState) {
                        return Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),

                                Icon(
                                  CupertinoIcons.star_fill,
                                  color: StyleColor.green,
                                  size: 28,
                                ),
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.05,
                                ),
                                Expanded(
                                  child: Text(
                                    tr("primeDescribe"),
                                    style: StyleText.bold16(context),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: context.getHeight() * 0.1),
                            ButtomWidget(
                              onTab: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => BlocProvider.value(
                                      value: bloc,
                                      child: PaymentScreen(
                                        payment: (PaymentResponse value) async {
                                          // Callback when payment result is received.
                                          if (value.status ==
                                              PaymentStatus.paid) {
                                            bloc.add(ActivatePrimeEvent());
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NavigationBarScreen(),
                                              ),
                                            );
                                          } else if (value.status ==
                                              PaymentStatus.failed) {
                                            Navigator.pop(context);
                                            // Show snackbar on payment failure.
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  'paymentFailed'.tr(),
                                                  style: StyleText.regular16(
                                                    context,
                                                  ),
                                                ),
                                                backgroundColor:
                                                    StyleColor.error,
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                );
                              },
                              textElevatedButton: tr('pay'),
                            ),
                          ],
                        );
                      }
                      return LoadingWidget();
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
