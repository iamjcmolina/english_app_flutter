import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/sentence/adjective/adjective.dart';
import '../../../model/sentence_item.dart';
import '../../../repository/vocabulary_repository.dart';
import '../../common/dropdown_tile.dart';
import '../../common/item_editor_layout.dart';
import '../../common/sentence_item_field.dart';

class AdjectiveForm extends StatelessWidget {
  final Function(bool) setCanSave;
  final Widget settingsControl;
  final Adjective? adjective;
  final void Function(Adjective?) setAdjective;

  const AdjectiveForm({
    super.key,
    required this.setCanSave,
    required this.settingsControl,
    required this.adjective,
    required this.setAdjective,
  });

  @override
  Widget build(BuildContext context) {
    final vocabularyRepository = Provider.of<VocabularyRepository>(context);

    return ItemEditorLayout(
      header: [
        settingsControl,
        ListTile(
          title: Text.rich(TextSpan(
            children: [
              TextSpan(
                text: adjective == null ? '<Adjective> ' : '$adjective ',
                style: adjective == null
                    ? SentenceItem.placeholder.style
                    : SentenceItem.adjective.style,
              ),
            ],
          )),
        ),
      ],
      body: [
        DropdownTile(
          style: SentenceItem.adjective.style,
          title: 'Adjective',
          textValue: adjective?.en,
          fields: [
            SentenceItemField<Adjective>(
              label: 'Adjective',
              value: adjective,
              options: vocabularyRepository.adjectives(),
              filterValuesEn: [(Adjective e) => e.en],
              filterValuesEs: [
                (Adjective e) => e.singularEs,
                (Adjective e) => e.pluralEs,
              ],
              onSelected: (adjective) => validateAndSet(adjective),
              onChanged: (text) => validateAndSet(null),
            ),
          ],
        ),
      ],
    );
  }

  validateAndSet(Adjective? adjective) {
    setCanSave(adjective != null);
    setAdjective(adjective);
  }
}
