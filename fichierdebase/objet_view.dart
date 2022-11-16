import 'package:base_de_projet/domain/core/value_objects.dart';

import 'widget/panel_az_er_view.dart';
import 'package:base_de_projet/presentation/components/main_scaffold.dart';
import 'package:base_de_projet/presentation/components/spacing.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:base_de_projet/application/az_er/add_az_er_form_notifier.dart';
import 'package:base_de_projet/presentation/core/_core/theme_button.dart';
import 'package:base_de_projet/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_route/src/router/auto_router_x.dart';

class AZERViewPage extends ConsumerWidget {
  final UniqueId id;
  const AZERViewPage({
    required this.id,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(oneAZERProvider(id));

    final azerWidget = listAsync.when(
      data: (data) {
        return data.fold(
            (error) => Center(
                  child: Text("Unknown Failure", style: Theme.of(context).textTheme.headline4),
                ),
            (azer) => PanelAZERView(azer: azer));
      },
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => Text(err.toString()),
    );

    return MainScaffold(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          azerWidget,
          SpaceH10(),
          ElevatedButton(
            onPressed: () {
              ref.read(azerRepositoryProvider).delete(id);
              context.router.pop();
            },
            child: Text(AppLocalizations.of(context)!.supprimer),
            style: buttonNormalRemove,
          ),
        ],
      ),
    ));
  }
}
