import 'package:auto_route/auto_route.dart';
import 'package:base_de_projet/PRESENTATION/core/_core/router.dart';
import 'package:base_de_projet/PRESENTATION/core/_components/main_scaffold.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:base_de_projet/APPLICATION/az_er/add_az_er_form_notifier.dart';
import 'package:base_de_projet/PRESENTATION/core/_components/app_async.dart';
import 'package:base_de_projet/PRESENTATION/core/_components/app_error.dart';
import 'package:base_de_projet/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_route/src/router/auto_router_x.dart';

@RoutePage()
class AZERListPage extends ConsumerWidget {
  const AZERListPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MainScaffold(
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppAsync(
              ref.watch(allAZERProvider),
              builder: (data) => data!.fold(
                  (error) => AppError(message: error.toString()),
                  (listAZER) => ListView(children: [
                        ElevatedButton(
                          onPressed: () {
                            context.router.push(AZERAddRoute());
                          },
                          child: Text("Ajout Button"),
                        ),
                        ...listAZER.map<Widget>((azerObj) => PanelAZERView(azer: azerObj)).toList()
                      ])),
            )));
  }
}
