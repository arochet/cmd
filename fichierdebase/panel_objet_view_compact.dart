import 'package:base_de_projet/DOMAIN/az_er/az_er.dart';
import 'package:flutter/material.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import '../../../core/_core/router.dart';

class PanelAZERView extends StatelessWidget {
  final AZER azer;
  const PanelAZERView({Key? key, required this.azer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //insert-info
            TextButton(
              onPressed: () {
                context.router.push(AZERViewRoute(id: azer.id));
              },
              child: Text("Voir Plus"),
            ),
          ],
        ),
      ),
    );
  }
}
