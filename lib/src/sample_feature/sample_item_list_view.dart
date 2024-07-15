import 'package:flutter/material.dart';

import '../settings/settings_view.dart';
import 'sample_item.dart';
import 'sample_item_details_view.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({ super.key });

  @override
  _SampleItemListViewState createState() => _SampleItemListViewState();
  
  static const routeName = '/';
}

class _SampleItemListViewState extends State<SampleItemListView> {
  
  List<SampleItem> items = List.empty(growable: true);
    int i = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Items'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to the settings page. If the user leaves and returns
              // to the app after it has been killed while running in the
              // background, the navigation stack is restored.
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),

      // To work with lists that may contain a large number of items, it’s best
      // to use the ListView.builder constructor.
      //
      // In contrast to the default ListView constructor, which requires
      // building all Widgets up front, the ListView.builder constructor lazily
      // builds Widgets as they’re scrolled into view.
      body: ListView.builder(
        // Providing a restorationId allows the ListView to restore the
        // scroll position when a user leaves and returns to the app after it
        // has been killed while running in the background.
        restorationId: 'sampleItemListView',
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          final item = items[index];

          return Dismissible(
            key: UniqueKey(),
            direction: DismissDirection.startToEnd,
            onDismissed: (_) {
              setState(() {
                items.removeAt(index);
              });
            },
            background: Container(
                color: Colors.red,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                padding: const EdgeInsets.only(left: 15),
                alignment: Alignment.centerLeft,
                child: const Icon(  
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            child: ListTile(
              title: Text('SampleItem ${item.id}'),
              leading: const CircleAvatar(
                // Display the Flutter Logo image asset.
                foregroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
              trailing: const Icon(
                Icons.arrow_right,
                color: Colors.grey,
              ),
              onTap:  () {
              // Navigate to the details page. If the user leaves and returns to
              // the app after it has been killed while running in the
              // background, the navigation stack is restored.
                Navigator.restorablePushNamed(
                  context,
                  SampleItemDetailsView.routeName,
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {
        setState(() {
          items.add(SampleItem(i));
        });
        i++;
      }),
    );
  }
}