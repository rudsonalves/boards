import 'package:flutter/material.dart';

import '/core/models/address.dart';
import 'widgets/address_form.dart';
import 'edit_address_controller.dart';
import 'edit_address_state.dart';

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
  final controller = EditAddressController();

  @override
  void initState() {
    super.initState();
    controller.init();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _saveAddressFrom() async {
    if (controller.valid) {
      await controller.saveAddressFrom();
      if (mounted) Navigator.pop(context);
    }
  }

  Future<void> _backPage() async {
    if (controller.valid) {
      await controller.saveAddressFrom();
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
        listenable: controller,
        builder: (context, _) {
          String? errorText;
          if (controller.state is EditAddressStateError) {
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
                          controller: controller,
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
              if (controller.state is EditAddressStateLoading)
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
