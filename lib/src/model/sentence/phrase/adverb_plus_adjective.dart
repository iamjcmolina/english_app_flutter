import '../../nullable.dart';
import '../adjective/adjective.dart';
import '../adjective/any_adjective.dart';
import '../adverb/adverb.dart';
import '../text_buffer.dart';

class AdverbPlusAdjective extends AnyAdjective {
  final Adverb? adverb;
  final Adjective? adjective;

  @override
  String get en => TextBuffer().add(adverb?.en).add(adjective?.en).toString();

  @override
  String get pluralEs =>
      TextBuffer().add(adverb?.es).add(adjective?.pluralEs).toString();

  @override
  String get singularEs =>
      TextBuffer().add(adverb?.es).add(adjective?.singularEs).toString();

  @override
  bool get isValid => adverb != null && adjective != null;

  const AdverbPlusAdjective({this.adjective, this.adverb});

  AdverbPlusAdjective copyWith({
    Nullable<Adverb>? adverb,
    Nullable<Adjective>? adjective,
  }) =>
      AdverbPlusAdjective(
        adverb: adverb == null ? this.adverb : adverb.value,
        adjective: adjective == null ? this.adjective : adjective.value,
      );

  @override
  String toString() => en;
}
