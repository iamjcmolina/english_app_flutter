enum SubjectType {
  pronoun("Pronoun"),
  nounPhrase("Noun Phrase"),
  gerundPhrase("Gerund Phrase"),
  infinitivePhrase("Infinitive Phrase"),
  nounPhraseVariant("Determiner Number Possesive-adjective? Noun");

  final String name;

  const SubjectType(this.name);
}
