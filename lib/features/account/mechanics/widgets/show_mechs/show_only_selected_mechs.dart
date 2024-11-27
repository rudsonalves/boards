import 'package:flutter/material.dart';

import '/get_it.dart';
import '/data_managers/mechanics_manager.dart';
import '../../mechanics_store.dart';

class ShowOnlySelectedMechs extends StatefulWidget {
  final MechanicsStore store;

  const ShowOnlySelectedMechs({
    super.key,
    required this.store,
  });

  @override
  State<ShowOnlySelectedMechs> createState() => _ShowOnlySelectedMechsState();
}

class _ShowOnlySelectedMechsState extends State<ShowOnlySelectedMechs> {
  final mechanicManager = getIt<MechanicsManager>();
  MechanicsStore get store => widget.store;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mechs = store.selectedMechIds;

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 70),
      itemCount: mechs.length,
      separatorBuilder: (context, index) =>
          const Divider(indent: 24, endIndent: 24),
      itemBuilder: (context, index) {
        final mech = store.selectedMechs[index];

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: colorScheme.tertiaryContainer,
          ),
          child: ListTile(
            title: Text(mech.name),
            subtitle: store.hideDescription.value
                ? null
                : Text(mech.description ?? ''),
            onTap: () {
              store.addMech(mech);
              if (store.selectedMechs.isEmpty) {
                store.toggleShowSelected();
              }
              setState(() {});
            },
          ),
        );
      },
    );
  }
}
