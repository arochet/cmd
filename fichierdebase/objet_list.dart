import 'package:base_de_projet/presentation/core/_components/main_scaffold.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:base_de_projet/application/az_er/add_az_er_form_notifier.dart';
import 'package:base_de_projet/presentation/core/_core/theme_button.dart';
import 'package:base_de_projet/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_route/src/router/auto_router_x.dart';

class AZERListPage extends ConsumerWidget {
  const AZERListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(allAZERProvider);

    final listAZER = listAsync.when(
      data: (data) {
        return data.fold(
            (error) => Center(
                  child: Text("Unknown Failure", style: Theme.of(context).textTheme.headline4),
                ),
            (listAZER) =>
                ListView(children: listAZER.map<Widget>((azerObj) => PanelAZERView(azer: azerObj)).toList()));
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text(err.toString()),
    );

    return MainScaffold(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: listAZER,
    ));
  }
}
