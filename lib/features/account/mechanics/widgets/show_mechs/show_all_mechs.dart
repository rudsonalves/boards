import 'package:flutter/material.dart';

import '/core/models/mechanic.dart';
import '/get_it.dart';
import '/data_managers/mechanics_manager.dart';
import '../../mechanics_store.dart';
import 'widgets/dismissible_mech.dart';

class ShowAllMechs extends StatefulWidget {
  final MechanicsStore store;
  final Future<void> Function(MechanicModel)? editMechanic;
  final Future<bool> Function(MechanicModel)? deleteMech;

  const ShowAllMechs({
    super.key,
    required this.store,
    this.editMechanic,
    this.deleteMech,
  });

  @override
  State<ShowAllMechs> createState() => _ShowAllMechsState();
}

class _ShowAllMechsState extends State<ShowAllMechs> {
  final mechanicManager = getIt<MechanicsManager>();
  MechanicsStore get store => widget.store;

  void onTap(MechanicModel mech) {
    store.addMech(mech);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final mechs = mechanicManager.mechanics;

    return ListView.separated(
      padding: const EdgeInsets.only(bottom: 70),
      itemCount: mechs.length,
      separatorBuilder: (context, index) =>
          const Divider(indent: 24, endIndent: 24),
      itemBuilder: (context, index) {
        final mech = mechs[index];
        final isSelected = store.isSelectedId(mech.id!);

        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isSelected ? colorScheme.tertiaryContainer : null,
          ),
          child: ValueListenableBuilder(
            valueListenable: store.hideDescription,
            builder: (context, hideDescription, _) => DismissibleMech(
              mech: mech,
              onTap: onTap,
              saveMech: widget.editMechanic,
              deleteMech: widget.deleteMech,
            ),
          ),
        );
      },
    );
  }
}
