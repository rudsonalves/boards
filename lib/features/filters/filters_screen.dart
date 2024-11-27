import 'package:flutter/material.dart';

import '../../core/models/ad.dart';
import '../../core/models/filter.dart';
import '../../components/buttons/big_button.dart';
import '../account/mechanics/mechanics_screen.dart';
import 'filters_controller.dart';
import 'filters_states.dart';
import 'widgets/text_form_dropdown.dart';
import 'widgets/text_title.dart';

class FiltersScreen extends StatefulWidget {
  final FilterModel? filter;

  const FiltersScreen(
    this.filter, {
    super.key,
  });

  static const routeName = '/filters';

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  final ctrl = FiltersController();

  @override
  void initState() {
    super.initState();

    ctrl.init(widget.filter);

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (widget.filter != null) {
    //     ctrl.setInitialValues(widget.filter!);
    //   }
    // });
  }

  @override
  void dispose() {
    super.dispose();
    ctrl.dispose();
  }

  void _sendFilter() {
    Navigator.pop(context, ctrl.filter);
  }

  Future<void> _selectMechanics() async {
    final newMechsPsIds = await Navigator.pushNamed(
      context,
      MechanicsScreen.routeName,
      arguments: ctrl.selectedMechIds,
    ) as List<String>;
    ctrl.mechUpdateNames(newMechsPsIds);
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtrar Anúncios'),
        centerTitle: true,
        leading: IconButton(
          onPressed: _sendFilter,
          icon: const Icon(Icons.arrow_back_ios_new),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: AnimatedBuilder(
          animation: ctrl,
          builder: (context, _) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const TextTitle('Localização'),
                      TextFormDropdown(
                        hintText: 'Estado',
                        controller: ctrl.stateController,
                        items: ctrl.stateNames,
                        submitItem: ctrl.submitState,
                        focusNode: ctrl.stateFocus,
                      ),
                      TextFormDropdown(
                        hintText: 'Cidade',
                        controller: ctrl.cityController,
                        items: ctrl.cityNames,
                        submitItem: ctrl.submitCity,
                      ),
                      const TextTitle('Ordenar por'),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<SortOrder>(
                              emptySelectionAllowed: false,
                              segments: const [
                                ButtonSegment(
                                  value: SortOrder.date,
                                  label: Text('Data'),
                                  icon: Icon(Icons.calendar_month),
                                ),
                                ButtonSegment(
                                  value: SortOrder.price,
                                  label: Text('Preço'),
                                  icon: Icon(Icons.price_change),
                                ),
                              ],
                              selected: {ctrl.sortBy},
                              onSelectionChanged: (selection) {
                                if (selection.isEmpty) return;
                                setState(() {
                                  ctrl.sortBy = selection.first;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      if (ctrl.sortBy == SortOrder.price)
                        Padding(
                          padding: const EdgeInsets.only(top: 12, bottom: 12),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: ctrl.minPriceController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Min',
                                    prefixText: 'R\$ ',
                                    hintText: 'Menor preço',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: TextField(
                                  controller: ctrl.maxPriceController,
                                  textInputAction: TextInputAction.next,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    floatingLabelBehavior:
                                        FloatingLabelBehavior.always,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    labelText: 'Max',
                                    prefixText: 'R\$ ',
                                    hintText: 'Maior preço',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      AnimatedBuilder(
                          animation: Listenable.merge([
                            ctrl.minPriceController,
                            ctrl.maxPriceController
                          ]),
                          builder: (context, _) {
                            final minPrice =
                                ctrl.minPriceController.currencyValue;
                            final maxPrice =
                                ctrl.maxPriceController.currencyValue;
                            if (maxPrice > 0 && minPrice > maxPrice) {
                              return Text(
                                'Faixa de preço inválida',
                                style: TextStyle(
                                  color: colorScheme.error,
                                ),
                              );
                            }
                            return Container();
                          }),
                      const TextTitle('Estado do produto'),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<ProductCondition>(
                              multiSelectionEnabled: false,
                              segments: const [
                                ButtonSegment(
                                  value: ProductCondition.all,
                                  icon: Icon(Icons.people_alt_outlined),
                                  label: Text('Todos'),
                                ),
                                ButtonSegment(
                                  value: ProductCondition.used,
                                  icon: Icon(Icons.person),
                                  label: Text('Usado'),
                                ),
                                ButtonSegment(
                                  value: ProductCondition.sealed,
                                  icon: Icon(Icons.store),
                                  label: Text('Lacrado'),
                                ),
                              ],
                              selected: {ctrl.advertiser},
                              onSelectionChanged: (selection) {
                                if (selection.isEmpty) return;
                                setState(() {
                                  ctrl.advertiser = selection.first;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const TextTitle('Mecânicas'),
                      InkWell(
                        onTap: _selectMechanics,
                        child: AbsorbPointer(
                          child: TextField(
                            readOnly: true,
                            maxLines: null,
                            controller: ctrl.mechsController,
                            decoration: InputDecoration(
                              hintText: 'Clique para selecionar mecânicas',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      BigButton(
                        color: Colors.green,
                        label: 'Filtrar',
                        onPressed: _sendFilter,
                      ),
                    ],
                  ),
                ),
                if (ctrl.state is FiltersStateLoading)
                  const Positioned.fill(
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                if (ctrl.state is FiltersStateError)
                  const Positioned.fill(
                    child: Card(
                      child: Center(
                        child: Text('Error!!!'),
                      ),
                    ),
                  )
              ],
            );
          },
        ),
      ),
    );
  }
}
