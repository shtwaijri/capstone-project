import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:qaimati/layer_data/app_data.dart';
import 'package:qaimati/widgets/empty_widget.dart';


// import 'package:flutter/material.dart';
// import 'package:get_it/get_it.dart';


class TestDataLayerScreen extends StatelessWidget {
  const TestDataLayerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dataLayer = GetIt.I<AppDatatLayer>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Data Layer'),
      ),
      body: FutureBuilder<void>(
        future: dataLayer.loadAdminLists(),//loadMemberLists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final lists = dataLayer.lists;

          if (lists.isEmpty) {
            return EmptyWidget(lable: 'no list here', img: '');
          }

          return ListView.builder(
            itemCount: lists.length,
            
            itemBuilder: (context, index) {
              final list = lists[index];
              return ListTile(
                title: Text(list.name),
                subtitle: Text('ID: ${list.listId}'),
                trailing: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: list.getColor(),
                    shape: BoxShape.circle,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}



