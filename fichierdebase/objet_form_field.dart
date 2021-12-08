TextFormField(
  decoration: const InputDecoration(labelText: 'insert-field-name'),
  autocorrect: false,
  textInputAction: TextInputAction.next,
  onChanged: (value) {
    ref
        .read(azerFormNotifierProvider.notifier)
        .insert-field-nameChanged(value);
  },
  validator: (_) {
    final notifier = ref.read(azerFormNotifierProvider);
    if (notifier.showErrorMessages) {
      return notifier.azer.insert-field-name.value.fold(
        (f) => f.maybeMap(
          exceedingLenghtOrNull: (_) => 'insert-field-name invalide',
          orElse: () => null,
        ),
        (_) => null,
      );
    } else
      return null;
  },
),
const SizedBox(height: 8),
//insert-field-complete