import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/invitations/bloc/invitations_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/style/style_text.dart';
import 'package:qaimati/widgets/app_bar_widget.dart';
import 'package:qaimati/widgets/custom_empty_widget.dart';
import 'package:qaimati/widgets/loading_widget.dart';

class InvitationsScreen extends StatelessWidget {
  const InvitationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InvitationsBloc, InvitationsState>(
      builder: (context, state) {
        if (state is InviteLoadingState) {
          return const Scaffold(body: Center(child: LoadingWidget()));
        } else if (state is InviteLoadedState) {
          final invited = state.invitedLists;

          return Scaffold(
            appBar: AppBarWidget(
              title: tr('InviteTitle'),
              showActions: false,
              showSearchBar: false,
              showBackButton: true,
            ),
            body: invited.isEmpty
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CustomEmptyWidget(
                        img: 'assets/svg/no_invites.svg',
                        bigText: tr('NoInvite'),
                        buttonText: tr(""),
                        onPressed: () {},
                      ),
                    ],
                  )
                : ListView.builder(
                    itemCount: invited.length,
                    itemBuilder: (context, index) {
                      final notification = invited[index];
                      final listName =
                          notification['list_name'] ?? 'Unknown List';
                      final senderEmail =
                          notification['sender_email'] ?? 'Unknown Sender';
                      final inviteId = notification['invite_id'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).brightness == Brightness.dark
                                ? StyleColor.graylight
                                : StyleColor.graylight,
                            borderRadius: BorderRadius.circular(12),
                          ),

                          child: ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 12,
                            ),
                            title: RichText(
                              text: TextSpan(
                                style: StyleText.bold16(
                                  context,
                                ).copyWith(color: StyleColor.black),
                                children: [
                                  TextSpan(text: '${tr("invitedTo")} '),
                                  TextSpan(
                                    text: listName,
                                    style: StyleText.bold16(
                                      context,
                                    ).copyWith(color: StyleColor.green),
                                  ),
                                ],
                              ),
                            ),

                            subtitle: Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Text(
                                '${tr("invitedBy")} $senderEmail',
                                style: StyleText.bold12(context).copyWith(
                                  color:
                                      Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? StyleColor.black
                                      : StyleColor.black,
                                ),
                              ),
                            ),

                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    backgroundColor: StyleColor.green,
                                  ),
                                  onPressed: () {
                                    context.read<InvitationsBloc>().add(
                                      AcceptInviteEvent(inviteId: inviteId),
                                    );
                                  },
                                  child: Text(
                                    tr('accept'),
                                    style: StyleText.bold16(
                                      context,
                                    ).copyWith(color: Colors.black),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    context.read<InvitationsBloc>().add(
                                      RejectInviteEvent(inviteId: inviteId),
                                    );
                                  },
                                  style: OutlinedButton.styleFrom(
                                    side: BorderSide.none,
                                    backgroundColor: StyleColor.error,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    tr('reject'),
                                    style: StyleText.bold16(
                                      context,
                                    ).copyWith(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          );
        } else if (state is InviteErrorState) {
          return Scaffold(body: Center(child: Text(state.message)));
        } else {
          return const Scaffold(
            body: Center(child: Text("Something went wrong")),
          );
        }
      },
    );
  }
}
