import 'package:base_de_projet/DOMAIN/az_er/az_er.dart';
import 'package:base_de_projet/PRESENTATION/core/_components/default_panel.dart';
import 'package:flutter/material.dart';
import 'package:base_de_projet/PRESENTATION/core/_core/theme_button.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base_de_projet/PRESENTATION/core/_core/theme_colors.dart';
import 'package:auto_route/src/router/auto_router_x.dart';
import 'package:base_de_projet/PRESENTATION/core/_core/router.gr.dart';

class PanelAZERView extends StatelessWidget {
  final AZER azer;
  const PanelAZERView({Key? key, required this.azer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultPanel(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //insert-info
            ElevatedButton(
              onPressed: () {
                context.router.push(AZERViewRoute(id: azer.id));
              },
              child: Text("Voir Plus"),
              style: buttonPrimaryHide,
            ),
          ],
        ),
      ),
    );
  }
}
