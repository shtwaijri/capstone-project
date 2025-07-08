import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/nav/bloc/navigation_bloc.dart';
import 'package:qaimati/layer_data/auth_layer.dart';
import 'package:qaimati/style/style_text.dart';

// / [NavigationBarScreen] displays the main app screens with a bottom navigation bar.
///
// / It uses [NavigationBloc] to manage the current selected tab index.
class NavigationBarScreen extends StatelessWidget {
  const NavigationBarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NavigationBloc(),
      child: Builder(
        builder: (context) {
          final bloc = context.read<NavigationBloc>();
          final authLayer = GetIt.I.get<AuthLayer>();
          authLayer.loadUserSettings(context);
          return BlocBuilder<NavigationBloc, NavigationState>(
            builder: (context, state) {
              if (state is! NavigationBarState) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return Scaffold(
                key: ValueKey(context.locale),
                body: bloc.screens[state.selectedIndex],
                bottomNavigationBar: BottomNavigationBar(
                  selectedLabelStyle: StyleText.bold16(context),
                  unselectedLabelStyle: StyleText.regular16(context),
                  currentIndex: state.selectedIndex,
                  onTap: (value) {
                    bloc.add(NavigationItemSelected(value));
                  },
                  items: [
                    BottomNavigationBarItem(
                      icon: state.selectedIndex == 0
                          ? Icon(CupertinoIcons.square_list_fill)
                          : Icon(CupertinoIcons.square_list),
                      label: tr("listsTitle"),
                    ),
                    BottomNavigationBarItem(
                      icon: state.selectedIndex == 1
                          ? Icon(Icons.receipt)
                          : Icon(Icons.receipt_outlined),
                      label: tr("expensesTitle"),
                    ),
                    BottomNavigationBarItem(
                      icon: state.selectedIndex == 2
                          ? Icon(Icons.person)
                          : Icon(Icons.person_outlined),
                      label: tr("profileTitle"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
