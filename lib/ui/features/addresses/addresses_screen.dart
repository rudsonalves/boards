// Copyright (C) 2025 Rudson Alves
// 
// This file is part of boards.
// 
// boards is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// boards is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with boards.  If not, see <https://www.gnu.org/licenses/>.

import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../components/widgets/base_dismissible_container.dart';
import '../../components/state_messages/state_error_message.dart';
import '../../components/state_messages/state_loading_message.dart';
import 'edit_address/edit_address_screen.dart';
import 'addresses_controller.dart';
import 'addresses_store.dart';

class AddressesScreen extends StatefulWidget {
  const AddressesScreen({super.key});

  static const routeName = '/address';

  @override
  State<AddressesScreen> createState() => _AddressesScreenState();
}

class _AddressesScreenState extends State<AddressesScreen> {
  final ctrl = AddressesController();
  final store = AddressesStore();

  @override
  void initState() {
    super.initState();
    ctrl.init(store);
  }

  Future<void> _addAddress() async {
    await Navigator.pushNamed(context, EditAddressScreen.routeName);
    if (mounted) {
      setState(() {});
    }
  }

  void _backPage() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Endereços'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _backPage,
        ),
      ),
      floatingActionButton: OverflowBar(
        children: [
          FloatingActionButton(
            onPressed: _backPage,
            heroTag: 'fab0',
            tooltip: 'Retornar',
            // label: const Text('Selecionar'),
            child: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _addAddress,
            heroTag: 'fab1',
            tooltip: 'Adicionar Endereço',
            child: const Icon(Symbols.add_home_rounded),
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListenableBuilder(
          listenable: store.state,
          builder: (context, _) {
            return Stack(
              children: [
                if (store.isSuccess)
                  Column(
                    children: [
                      const Text('Selecione um endereço abaixo:'),
                      Expanded(
                        child: ListView.builder(
                          itemCount: ctrl.addressNames.length,
                          itemBuilder: (context, index) {
                            final address = ctrl.addresses[index];
                            final isSelected = address.selected;
                            return Dismissible(
                              key: UniqueKey(),
                              background: baseDismissibleContainer(
                                context,
                                alignment: Alignment.centerLeft,
                                color: Colors.green.withValues(alpha: 0.45),
                                icon: Symbols.edit_square_rounded,
                                label: 'Editar',
                                enable: false,
                              ),
                              secondaryBackground: baseDismissibleContainer(
                                context,
                                alignment: Alignment.centerRight,
                                color: Colors.red.withValues(alpha: 0.45),
                                icon: Symbols.delete_rounded,
                                label: 'Remover',
                              ),
                              child: Card(
                                color: isSelected
                                    ? colorScheme.tertiaryContainer
                                    : colorScheme.primaryContainer
                                        .withValues(alpha: 0.4),
                                child: ListTile(
                                  title: Text(address.name),
                                  subtitle: Text(address.addressString()),
                                  onTap: () => ctrl.selectAddress(
                                      address.selected, index),
                                ),
                              ),
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.startToEnd) {
                                  return false;
                                } else if (direction ==
                                    DismissDirection.endToStart) {
                                  return ctrl.removeAddress(index);
                                }

                                return false;
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                if (store.isLoading) const StateLoadingMessage(),
                if (store.isError)
                  StateErrorMessage(
                    message: store.errorMessage,
                    closeDialog: ctrl.closeErroMessage,
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
