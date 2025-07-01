import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/features/sub_list/sub_list_screen.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/layer_data/auth_layer.dart';

class Tray extends StatefulWidget {
  const Tray({super.key});

  @override
  State<Tray> createState() => _TrayState();
}

final authGetit = GetIt.I.get<AuthLayer>();
final appGetit = GetIt.I.get<AppDatatLayer>();

class _TrayState extends State<Tray> {
  @override
  void initState()  {
    super.initState();

    log("initState start");
     appGetit.getListsApp(userId: authGetit.idUser!);
    log("initState end");
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ListView.builder(
            itemCount: appGetit.lists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(appGetit.lists[index].toString()),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        appGetit.listId = appGetit.lists[index].listId;
                        log("${appGetit.lists[index].listId}");
                        return SubListScreen();
                      },
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

Future<void> s() async {}
