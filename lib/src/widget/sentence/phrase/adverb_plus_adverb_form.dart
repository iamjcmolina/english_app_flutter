import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../extensions/string_extension.dart';
import '../../../model/nullable.dart';
import '../../../model/sentence/adverb/adverb.dart';
import '../../../model/sentence/phrase/adverb_plus_adverb.dart';
import '../../../model/word.dart';
import '../../../repository/vocabulary_repository.dart';
import '../../common/dropdown_tile.dart';
import '../../common/item_editor_layout.dart';
import '../../common/sentence_item_field.dart';

class AdverbPlusAdverbForm extends StatelessWidget {
  final Widget settingsControl;
  final AdverbPlusAdverb phrase;
  final void Function(AdverbPlusAdverb?) setPhrase;

  const AdverbPlusAdverbForm({
    super.key,
    required this.settingsControl,
    required this.phrase,
    required this.setPhrase,
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
                text: (phrase.modifierAdverb?.en ?? '<Adverb> ').addSpace(),
                style: phrase.modifierAdverb == null
                    ? Word.empty.style
                    : Word.adverb.style,
              ),
              TextSpan(
                text: (phrase.adverb?.en ?? '<Adverb>').addSpace(),
                style: phrase.adverb == null
                    ? Word.empty.style
                    : Word.adverb.style,
              ),
            ],
          )),
        ),
      ],
      body: [
        DropdownTile(
          style: Word.verb.style,
          title: '<Adverb>',
          textValue: phrase.modifierAdverb?.en,
          textValueEs: phrase.modifierAdverb?.es,
          required: true,
          fields: [
            SentenceItemField<Adverb>(
              label: '<Adverb>',
              value: phrase.modifierAdverb,
              displayStringForOption: (e) => e.en,
              options: vocabularyRepository.endAdverbs(),
              filterValuesEn: [(e) => e.en],
              filterValuesEs: [(e) => e.es],
              onSelected: (e) => setIntensifierOrMitigator(e),
              onChanged: (text) => setIntensifierOrMitigator(null),
            ),
          ],
        ),
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
              onSelected: (e) => setIntensifierOrMitigator(e),
              onChanged: (text) => setIntensifierOrMitigator(null),
            ),
          ],
        ),
      ],
    );
  }

  void setIntensifierOrMitigator(Adverb? adverb) => setPhrase(
      phrase.copyWith(intensifierOrMitigatorAdverb: Nullable(adverb)));

  void setAdverb(Adverb? adverb) =>
      setPhrase(phrase.copyWith(adverb: Nullable(adverb)));
}
