import 'package:flutter/material.dart';
import 'package:base_de_projet/presentation/components/main_scaffold.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:base_de_projet/presentation/core/_core/theme_colors.dart';
import 'package:base_de_projet/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AZERPage extends StatelessWidget {
  const AZERPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      title: AppLocalizations.of(context)!.nomprojet,
      child: Padding(
        padding: EdgeInsets.all(10),
        child: Text('insert-code'),
      ),
    );
  }
}
