import 'package:another_flushbar/flushbar.dart';
import 'package:base_de_projet/APPLICATION/auth/register_form_notifier.dart';
import 'package:base_de_projet/PRESENTATION/auth/widget/flushbar_auth_failure.dart';
import 'package:base_de_projet/APPLICATION/az_er/add_az_er_form_notifier.dart';
import 'package:base_de_projet/PRESENTATION/core/_core/router.dart';

import 'package:base_de_projet/providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_route/src/router/auto_router_x.dart';

class AZERFormProvider extends ConsumerWidget {
  const AZERFormProvider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<AddAZERFormData>(azerFormNotifierProvider as ProviderListenable<AddTestFormData>,
        (prev, myRegisterState) {
      myRegisterState.authFailureOrSuccessOption.fold(
          () {},
          (either) => either.fold((failure) {
                //Message d'erreur
                Flushbar(
                  duration: const Duration(seconds: 3),
                  icon: const Icon(Icons.warning),
                  messageColor: Colors.red,
                  message: failure.map(
                      insufficientPermission: (_) => AppLocalizations.of(context)!.permissioninsuffisante,
                      unableToUpdate: (_) => "Unable to update",
                      unexpected: (_) => "Unexpected"),
                ).show(context);
              }, (_) {
                //Création réussie !
                Future.delayed(Duration.zero, () async {
                  context.router.pop();
                });
              }));
    });
    return AZERForm();
  }
}

class AZERForm extends ConsumerWidget {
  const AZERForm({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(azerFormNotifierProvider);
    return Form(
      autovalidateMode: AutovalidateMode.always,
      child: ListView(padding: const EdgeInsets.all(18), shrinkWrap: true, children: [
        const SizedBox(height: 8),
        //insert-field-complete
        const SizedBox(height: 14),
        Align(
          child: Container(
            width: 200,
            child: ElevatedButton(
              onPressed: () {
                ref.read(azerFormNotifierProvider.notifier).addAZERPressed();
              },
              child: const Text("Ajout"),
            ),
          ),
        ),
        const SizedBox(height: 12),
        if (ref.read(azerFormNotifierProvider).isSubmitting) ...[
          const SizedBox(height: 8),
          const LinearProgressIndicator(value: null)
        ]
      ]),
    );
  }
}
