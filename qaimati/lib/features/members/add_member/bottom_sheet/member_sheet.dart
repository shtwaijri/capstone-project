import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qaimati/features/members/add_member/bloc/add_member_bloc.dart';
import 'package:qaimati/style/style_color.dart';
import 'package:qaimati/utilities/extensions/screens/get_size_screen.dart';
import 'package:qaimati/widgets/loading_widget.dart';

void showAddMemberBottomSheet({
  required BuildContext context,
  required String listId,
}) {
  final bloc = context.read<AddMemberBloc>();

  showModalBottomSheet(
    isScrollControlled: true,
    showDragHandle: true,
    context: context,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: BlocConsumer<AddMemberBloc, AddMemberState>(
          listener: (context, state) {
            if (state is AddMemberSuccess) {
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text(tr('InviteSnackBar'))));
            } else if (state is AddMemberFailure) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Error: ${state.error}')));
            }
          },
          builder: (context, state) {
            return Padding(
              padding: EdgeInsets.only(
                left: context.getWidth() * 0.04,
                right: context.getWidth() * 0.04,
                top: context.getHeight() * 0.02,
                bottom:
                    MediaQuery.of(context).viewInsets.bottom +
                    context.getHeight() * 0.02,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    tr('memberAddTitle'),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: context.getHeight() * 0.02),
                  TextField(
                    decoration: InputDecoration(
                      hintText: tr("memberHint"),
                      hintStyle: TextStyle(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white54
                            : Colors.black54,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black,
                        ),
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        vertical: context.getHeight() * 0.015,
                        horizontal: context.getWidth() * 0.04,
                      ),
                    ),
                    onChanged: (value) {
                      bloc.add(AddEmailEvent(value));
                    },
                  ),
                  SizedBox(height: context.getHeight() * 0.025),
                  state is AddMemberLoading
                      ? const LoadingWidget()
                      : ElevatedButton(
                          onPressed: () {
                            bloc.add(
                              SendInviteEvent(
                                email: bloc.email,
                                listId: listId,
                              ),
                            );
                          },
                          child: Text(
                            tr("memberAddTitle"),
                            style: TextStyle(
                              color: StyleColor.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
