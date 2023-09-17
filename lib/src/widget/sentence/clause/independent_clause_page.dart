import 'package:flutter/material.dart';

import '../../../model/nullable.dart';
import '../../../model/sentence/clause/independent_clause.dart';
import '../../../model/sentence/clause/independent_clause_settings.dart';
import '../../../model/sentence/clause/value/clause_type.dart';
import '../../../model/sentence/clause/value/independent_clause_part_color.dart';
import '../../../model/sentence/clause/value/tense.dart';
import '../../../model/sentence/noun/subject.dart';
import '../../../model/sentence/noun/undefined_subject.dart';
import '../../../model/sentence/verb/any_verb.dart';
import '../../../model/sentence/verb/be.dart';
import '../../../model/sentence/verb/modal_verb.dart';
import '../../../model/sentence/verb/undefined_modal_verb.dart';
import '../../../model/sentence/verb/undefined_verb.dart';
import '../noun/subject_page.dart';
import '../sentence_item_field.dart';
import '../verb/first_auxiliary_verb_list_item.dart';
import '../verb/verb_list_item.dart';
import 'clause_text.dart';
import '../../root_layout.dart';
import '../sentence_item_tile.dart';

class IndependentClausePage extends StatefulWidget {
  final IndependentClause? clause;

  const IndependentClausePage({super.key, this.clause});

  @override
  State<IndependentClausePage> createState() => _IndependentClausePageState();
}

class _IndependentClausePageState extends State<IndependentClausePage> {
  late IndependentClause clause;
  bool editingSettings = false;
  bool isBottomAppBarShown = false;
  bool editingFirstAuxiliaryVerb = false;
  bool editingVerb = false;
  final TextEditingController verbEditingController = TextEditingController();

  IndependentClauseSettings get settings => clause.settings;
  Subject get safeSubject => clause.subject ?? const UndefinedSubject();
  AnyVerb get safeVerb => clause.verb ?? const UndefinedVerb();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final clauseMap = {
      'frontAdverb': false? null :'Undoubtedly',
      'subject': clause.subject.toString(),//false? null :'you',
      'firstAuxiliaryVerb': false? null :'will',
      'middleAdverb': true? null :'always',
      'secondAuxiliaryVerb': false? null :'have',
      'thirdAuxiliaryVerb': false? null :'been',
      'verb': false? null :'working',
      'indirectObject': null,
      'directObject': null,
      'subjectComplement': null,
      'endAdverb': true? null :'quickly',
    };
    final verbListItem = clause.isBeAuxiliary? const SizedBox.shrink() : VerbListItem(
      clause: clause,
      editingVerb: editingVerb,
      toggleEditingVerb: toggleEditingVerb,
      showOrHideBottomAppBar: showOrHideBottomAppBar,
      setVerb: setVerb,
      verbEditingController: verbEditingController,
    );
    final firstAuxiliaryVerbListItem = FirstAuxiliaryVerbListItem(
      editingFirstAuxiliaryVerb: editingFirstAuxiliaryVerb,
      clause: clause,
      setSettings: setSettings,
      showOrHideBottomAppBar: showOrHideBottomAppBar,
      toggleEditingFirstAuxiliaryVerb: toggleEditingFirstAuxiliaryVerb,
      setModalVerb: setModalVerb,
      setVerb: setVerb,
      verbEditingController: verbEditingController,
    );

    return RootLayout(
      title: 'Independent Clause',
      showBottomAppBar: isBottomAppBarShown,
      bottomAppBarChildren: [
        IconButton(
            onPressed: () => onSavePage(context),
            icon: const Icon(Icons.save)
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => setState(() => index = index == 0? 1 : 0),
                    child: const Icon(Icons.chevron_left),
                  ),
                  IndexedStack(
                    index: index,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownMenu<Tense>(
                          initialSelection: settings.tense,
                          label: const Text('Tense'),
                          dropdownMenuEntries: Tense.values
                              .map<DropdownMenuEntry<Tense>>(
                                  (Tense item) => DropdownMenuEntry<Tense>(
                                value: item,
                                label: item.name,
                              )).toList(),
                          onSelected: (Tense? tense) => setTense(tense!),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: DropdownMenu<ClauseType>(
                          initialSelection: settings.clauseType,
                          label: const Text('Clause type'),
                          dropdownMenuEntries: ClauseType.values
                              .map<DropdownMenuEntry<ClauseType>>(
                                  (ClauseType item) => DropdownMenuEntry<ClauseType>(
                                value: item,
                                label: item.name,
                              ))
                              .toList(),
                          onSelected: (ClauseType? type) => setClauseType(type!),
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () => setState(() => index = index == 0? 1 : 0),
                    child: const Icon(Icons.chevron_right),
                  ),
                ],
              ),
            ],
          ),
          ListTile(
            title: ClauseText(clause: clause),
          ),
          Expanded(
            child: ListView(
              children: [
                Card(
                  child: Column(
                    children: [
                      if (settings.clauseType != ClauseType.interrogative)
                        SentenceItemTile(
                          color: IndependentClausePartColor.adverb.color,
                          label: '<FrontAdverb>',
                          value: clause.frontAdverb?.toString(),
                          trailing: const Icon(Icons.arrow_forward_ios),
                        ),
                      if (settings.isInterrogative)
                        firstAuxiliaryVerbListItem,
                      SentenceItemTile(
                        color: IndependentClausePartColor.noun.color,
                        label: '<Subject>',
                        value: clause.subject?.toString(),
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () => navigateToSubjectPage(context),
                      ),
                      if (!settings.isInterrogative)
                        firstAuxiliaryVerbListItem,
                      SentenceItemTile(
                        color: IndependentClausePartColor.adverb.color,
                        label: '<MiddleAdverb>',
                        value: clause.midAdverb?.toString(),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      if (clause.auxiliaries.length > 1) SentenceItemTile(
                        color: IndependentClausePartColor.verb.color,
                        label: '<SecondAuxiliaryVerb>',
                        value: clause.auxiliaries.elementAtOrNull(1),
                        // trailing: const Icon(Icons.arrow_forward_ios),
                        hide: clause.auxiliaries.elementAtOrNull(1) == null,
                      ),
                      if (clause.auxiliaries.length > 2) SentenceItemTile(
                        color: IndependentClausePartColor.verb.color,
                        label: '<ThirdAuxiliaryVerb>',
                        value: clause.auxiliaries.elementAtOrNull(2),
                        // trailing: const Icon(Icons.arrow_forward_ios),
                        hide: clause.auxiliaries.elementAtOrNull(2) == null,
                      ),
                      if (!clause.isBeAuxiliary) verbListItem,
                      SentenceItemTile(
                        color: IndependentClausePartColor.noun.color,
                        label: '<IndirectObject>',
                        value: clause.indirectObject?.toString(),
                        hide: !safeVerb.isDitransitive,
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      SentenceItemTile(
                        color: IndependentClausePartColor.noun.color,
                        label: '<DirectObject>',
                        value: clause.directObject?.toString(),
                        hide: !safeVerb.isTransitive,
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      SentenceItemTile(
                        color: IndependentClausePartColor.noun.color,
                        label: '<SubjectComplement>',
                        value: clause.subjectComplement?.toString(),
                        hide: !safeVerb.isLinkingVerb,
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                      SentenceItemTile(
                        color: IndependentClausePartColor.adverb.color,
                        label: '<EndAdverb>',
                        value: clause.endAdverb?.toString(),
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  setClause(IndependentClause clause) => setState(()=> this.clause = clause);

  setSubject(Subject? subject) => setClause(clause.copyWith(subject: Nullable(subject)));

  setModalVerb(ModalVerb? modalVerb) => setClause(clause.copyWith(modalVerb: Nullable(modalVerb)));

  setVerb(AnyVerb? verb) => setClause(clause.copyWith(verb: Nullable(verb)));

  setSettings(IndependentClauseSettings options) => setClause(clause.copyWith(settings: options));

  setTense(Tense tense) => setSettings(settings.copyWith(tense: tense));

  setClauseType(ClauseType type) => setSettings(settings.copyWith(clauseType: type));

  onSavePage(BuildContext context) => Navigator.pop(context, clause);

  toggleEditingSettings() => setState(() => editingSettings = !editingSettings);

  toggleEditingFirstAuxiliaryVerb() =>
      setState(() => editingFirstAuxiliaryVerb = !editingFirstAuxiliaryVerb);

  toggleEditingVerb() => setState(() => editingVerb = !editingVerb);

  showOrHideBottomAppBar() => setState(() => isBottomAppBarShown =
      clause.modalVerb is! UndefinedModalVerb && clause.verb is! UndefinedVerb
  );
  
  navigateToSubjectPage(BuildContext context) async {
    final subject = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubjectPage(
              subjectType: settings.subjectType,
              subject: clause.subject,
            )));
    if (subject is Subject) {
      setSubject(subject);
    }
  }

  @override
  void initState() {
    super.initState();
    clause = widget.clause ?? IndependentClause();
  }
}
