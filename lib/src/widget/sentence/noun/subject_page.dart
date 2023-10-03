import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/sentence/noun/any_noun.dart';
import '../../../model/sentence/noun/pronoun.dart';
import '../../../model/sentence/noun/value/noun_type.dart';
import '../../../model/sentence/phrase/noun_phrase.dart';
import '../../../service/vocabulary_service.dart';
import '../../sentence_scaffold.dart';
import 'noun_phrase_form.dart';
import 'pronoun_form.dart';

class SubjectPage extends StatefulWidget {
  final AnyNoun? subject;

  const SubjectPage({super.key, required this.subject});

  @override
  State<SubjectPage> createState() => _SubjectPageState();
}

class _SubjectPageState extends State<SubjectPage> {
  late NounType nounType;
  AnyNoun? subject;
  bool canSave = false;

  @override
  void initState() {
    super.initState();
    subject = widget.subject;
    canSave = subject != null;
    nounType = switch(widget.subject.runtimeType) {
      NounPhrase => NounType.nounPhrase,
      _ => NounType.pronoun,
    };
  }

  @override
  Widget build(BuildContext context) {
    final vocabularyService = Provider.of<VocabularyService>(context);

    List<Pronoun> pronouns = vocabularyService.subjectPronouns();

    final settingsControl = Center(
      child: DropdownButton<NounType>(
        value: nounType,
        onChanged: (NounType? value) => setNounType(value!),
        items: NounType.values.map<DropdownMenuItem<NounType>>(
                (NounType item) => DropdownMenuItem<NounType>(
              value: item,
              child: Text(item.name),
            )
        ).toList(),
      ),
    );

    return SentenceScaffold(
      title: 'Subject',
      bottomActions: [
        IconButton(
          onPressed: canSave? () => Navigator.pop(context, subject) : null,
          icon: const Icon(Icons.save),
        ),
        IconButton(
            onPressed: () => Navigator.pop(context, false),
            icon: const Icon(Icons.clear),
        ),
      ],
      body: switch(nounType) {
        NounType.nounPhrase => NounPhraseForm(
          setNounPhrase: setSubject,
          nounPhrase: subject is NounPhrase? subject as NounPhrase : null,
          settingsControl: settingsControl,
          setCanSave: setCanSave,
        ),
        _ => PronounForm(
          pronouns: pronouns,
          setPronoun: setSubject,
          pronoun: subject is Pronoun? subject as Pronoun : null,
          setCanSave: setCanSave,
          settingsControl: settingsControl,
        ),
      },
    );
  }

  setSubject(AnyNoun? subject) => setState(() => this.subject = subject);

  setNounType(NounType type) => setState(() => nounType = type);

  setCanSave(bool canSave) => setState(() => this.canSave = canSave);
}
