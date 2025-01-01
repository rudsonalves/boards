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

import '../../../../data/models/address.dart';
import 'edit_address_store.dart';
import 'widgets/address_form.dart';
import 'edit_address_controller.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel? address;

  const EditAddressScreen({
    super.key,
    this.address,
  });

  static const routeName = '/new_address';

  @override
  State<EditAddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<EditAddressScreen> {
  late final EditAddressStore store;
  final crtl = EditAddressController();

  @override
  void initState() {
    super.initState();
    store = EditAddressStore(address: widget.address);
    crtl.init(store);
  }

  @override
  void dispose() {
    store.dispose();
    crtl.dispose();
    super.dispose();
  }

  Future<void> _saveAddressFrom() async {
    if (store.isValid()) {
      await crtl.saveAddressFrom();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _backPage() async {
    if (store.isValid()) {
      await crtl.saveAddressFrom();
    }
    if (mounted) Navigator.pop(context);
  }

  void _backCancel() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Endereço'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: _backPage,
        ),
      ),
      body: ListenableBuilder(
        listenable: store.state,
        builder: (context, _) {
          String? errorText;
          if (store.isError) {
            errorText = 'CEP Inválido';
          }
          return Stack(
            children: [
              Positioned.fill(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    child: Column(
                      children: [
                        AddressForm(
                          ctrl: crtl,
                          errorText: errorText,
                        ),
                        OverflowBar(
                          children: [
                            ElevatedButton.icon(
                              onPressed: _saveAddressFrom,
                              label: const Text('Salvar'),
                              icon: const Icon(Icons.save),
                            ),
                            ElevatedButton.icon(
                              onPressed: _backCancel,
                              label: const Text('Cancelar'),
                              icon: const Icon(Icons.cancel),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (store.isLoading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
