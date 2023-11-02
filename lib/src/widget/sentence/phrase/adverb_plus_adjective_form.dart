import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../extensions/string_extension.dart';
import '../../../model/nullable.dart';
import '../../../model/sentence/adjective/adjective.dart';
import '../../../model/sentence/adverb/adverb.dart';
import '../../../model/sentence/phrase/adverb_plus_adjective.dart';
import '../../../model/word.dart';
import '../../../repository/vocabulary_repository.dart';
import '../../common/dropdown_tile.dart';
import '../../common/item_editor_layout.dart';
import '../../common/sentence_item_field.dart';

class AdverbPlusAdjectiveForm extends StatelessWidget {
  final Widget settingsControl;
  final AdverbPlusAdjective phrase;
  final void Function(AdverbPlusAdjective?) setPhrase;
  final bool isPlural;

  const AdverbPlusAdjectiveForm({
    super.key,
    required this.settingsControl,
    required this.phrase,
    required this.setPhrase,
    required this.isPlural,
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
                text: (phrase.adverb?.en ?? '<Adverb>').addSpace(),
                style: phrase.adverb == null
                    ? Word.empty.style
                    : Word.adverb.style,
              ),
              TextSpan(
                text: (phrase.adjective?.en ?? '<Adjective>').addSpace(),
                style: phrase.adjective == null
                    ? Word.empty.style
                    : Word.adjective.style,
              ),
            ],
          )),
        ),
      ],
      body: [
        DropdownTile(
          style: Word.verb.style,
          title: '<Adverb>',
          textValue: phrase.adverb?.en,
          textValueEs: phrase.adverb?.es,
          required: true,
          fields: [
            SentenceItemField<Adverb>(
              label: '<Adverb>',
              value: phrase.adverb,
              displayStringForOption: (e) => e.en,
              options: vocabularyRepository.endAdverbs(),
              filterValuesEn: [(e) => e.en],
              filterValuesEs: [(e) => e.es],
              onSelected: (e) => setAdverb(e),
              onChanged: (text) => setAdverb(null),
            ),
          ],
        ),
        DropdownTile(
          style: Word.verb.style,
          title: '<Adjective>',
          textValue: phrase.adjective?.en,
          textValueEs: isPlural
              ? phrase.adjective?.singularEs
              : phrase.adjective?.pluralEs,
          required: true,
          fields: [
            SentenceItemField<Adjective>(
              label: '<Adjective>',
              value: phrase.adjective,
              displayStringForOption: (e) => e.en,
              options: vocabularyRepository.adjectives(),
              filterValuesEn: [(e) => e.en],
              filterValuesEs: [(e) => isPlural ? e.pluralEs : e.singularEs],
              onSelected: (e) => setAdjective(e),
              onChanged: (text) => setAdjective(null),
            ),
          ],
        ),
      ],
    );
  }

  void setAdverb(Adverb? adverb) =>
      setPhrase(phrase.copyWith(adverb: Nullable(adverb)));

  void setAdjective(Adjective? adjective) =>
      setPhrase(phrase.copyWith(adjective: Nullable(adjective)));
}
