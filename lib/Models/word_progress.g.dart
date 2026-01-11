// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_progress.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetWordProgressCollection on Isar {
  IsarCollection<WordProgress> get wordProgress => this.collection();
}

const WordProgressSchema = CollectionSchema(
  name: r'WordProgress',
  id: 1635632464258474267,
  properties: {
    r'correctCount': PropertySchema(
      id: 0,
      name: r'correctCount',
      type: IsarType.long,
    ),
    r'ease': PropertySchema(
      id: 1,
      name: r'ease',
      type: IsarType.double,
    ),
    r'intervalDays': PropertySchema(
      id: 2,
      name: r'intervalDays',
      type: IsarType.long,
    ),
    r'lastSeenAt': PropertySchema(
      id: 3,
      name: r'lastSeenAt',
      type: IsarType.dateTime,
    ),
    r'nextReviewAt': PropertySchema(
      id: 4,
      name: r'nextReviewAt',
      type: IsarType.dateTime,
    ),
    r'seenCount': PropertySchema(
      id: 5,
      name: r'seenCount',
      type: IsarType.long,
    ),
    r'wordKey': PropertySchema(
      id: 6,
      name: r'wordKey',
      type: IsarType.string,
    ),
    r'wrongCount': PropertySchema(
      id: 7,
      name: r'wrongCount',
      type: IsarType.long,
    )
  },
  estimateSize: _wordProgressEstimateSize,
  serialize: _wordProgressSerialize,
  deserialize: _wordProgressDeserialize,
  deserializeProp: _wordProgressDeserializeProp,
  idName: r'id',
  indexes: {
    r'wordKey': IndexSchema(
      id: 6229021340103188451,
      name: r'wordKey',
      unique: true,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'wordKey',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _wordProgressGetId,
  getLinks: _wordProgressGetLinks,
  attach: _wordProgressAttach,
  version: '3.1.0+1',
);

int _wordProgressEstimateSize(
  WordProgress object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.wordKey.length * 3;
  return bytesCount;
}

void _wordProgressSerialize(
  WordProgress object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeLong(offsets[0], object.correctCount);
  writer.writeDouble(offsets[1], object.ease);
  writer.writeLong(offsets[2], object.intervalDays);
  writer.writeDateTime(offsets[3], object.lastSeenAt);
  writer.writeDateTime(offsets[4], object.nextReviewAt);
  writer.writeLong(offsets[5], object.seenCount);
  writer.writeString(offsets[6], object.wordKey);
  writer.writeLong(offsets[7], object.wrongCount);
}

WordProgress _wordProgressDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = WordProgress();
  object.correctCount = reader.readLong(offsets[0]);
  object.ease = reader.readDouble(offsets[1]);
  object.id = id;
  object.intervalDays = reader.readLong(offsets[2]);
  object.lastSeenAt = reader.readDateTimeOrNull(offsets[3]);
  object.nextReviewAt = reader.readDateTimeOrNull(offsets[4]);
  object.seenCount = reader.readLong(offsets[5]);
  object.wordKey = reader.readString(offsets[6]);
  object.wrongCount = reader.readLong(offsets[7]);
  return object;
}

P _wordProgressDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readLong(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readLong(offset)) as P;
    case 6:
      return (reader.readString(offset)) as P;
    case 7:
      return (reader.readLong(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _wordProgressGetId(WordProgress object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _wordProgressGetLinks(WordProgress object) {
  return [];
}

void _wordProgressAttach(
    IsarCollection<dynamic> col, Id id, WordProgress object) {
  object.id = id;
}

extension WordProgressByIndex on IsarCollection<WordProgress> {
  Future<WordProgress?> getByWordKey(String wordKey) {
    return getByIndex(r'wordKey', [wordKey]);
  }

  WordProgress? getByWordKeySync(String wordKey) {
    return getByIndexSync(r'wordKey', [wordKey]);
  }

  Future<bool> deleteByWordKey(String wordKey) {
    return deleteByIndex(r'wordKey', [wordKey]);
  }

  bool deleteByWordKeySync(String wordKey) {
    return deleteByIndexSync(r'wordKey', [wordKey]);
  }

  Future<List<WordProgress?>> getAllByWordKey(List<String> wordKeyValues) {
    final values = wordKeyValues.map((e) => [e]).toList();
    return getAllByIndex(r'wordKey', values);
  }

  List<WordProgress?> getAllByWordKeySync(List<String> wordKeyValues) {
    final values = wordKeyValues.map((e) => [e]).toList();
    return getAllByIndexSync(r'wordKey', values);
  }

  Future<int> deleteAllByWordKey(List<String> wordKeyValues) {
    final values = wordKeyValues.map((e) => [e]).toList();
    return deleteAllByIndex(r'wordKey', values);
  }

  int deleteAllByWordKeySync(List<String> wordKeyValues) {
    final values = wordKeyValues.map((e) => [e]).toList();
    return deleteAllByIndexSync(r'wordKey', values);
  }

  Future<Id> putByWordKey(WordProgress object) {
    return putByIndex(r'wordKey', object);
  }

  Id putByWordKeySync(WordProgress object, {bool saveLinks = true}) {
    return putByIndexSync(r'wordKey', object, saveLinks: saveLinks);
  }

  Future<List<Id>> putAllByWordKey(List<WordProgress> objects) {
    return putAllByIndex(r'wordKey', objects);
  }

  List<Id> putAllByWordKeySync(List<WordProgress> objects,
      {bool saveLinks = true}) {
    return putAllByIndexSync(r'wordKey', objects, saveLinks: saveLinks);
  }
}

extension WordProgressQueryWhereSort
    on QueryBuilder<WordProgress, WordProgress, QWhere> {
  QueryBuilder<WordProgress, WordProgress, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension WordProgressQueryWhere
    on QueryBuilder<WordProgress, WordProgress, QWhereClause> {
  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> idNotEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            )
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            );
      } else {
        return query
            .addWhereClause(
              IdWhereClause.greaterThan(lower: id, includeLower: false),
            )
            .addWhereClause(
              IdWhereClause.lessThan(upper: id, includeUpper: false),
            );
      }
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> idBetween(
    Id lowerId,
    Id upperId, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: lowerId,
        includeLower: includeLower,
        upper: upperId,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> wordKeyEqualTo(
      String wordKey) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'wordKey',
        value: [wordKey],
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterWhereClause> wordKeyNotEqualTo(
      String wordKey) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordKey',
              lower: [],
              upper: [wordKey],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordKey',
              lower: [wordKey],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordKey',
              lower: [wordKey],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'wordKey',
              lower: [],
              upper: [wordKey],
              includeUpper: false,
            ));
      }
    });
  }
}

extension WordProgressQueryFilter
    on QueryBuilder<WordProgress, WordProgress, QFilterCondition> {
  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      correctCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'correctCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      correctCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'correctCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      correctCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'correctCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      correctCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'correctCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> easeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'ease',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      easeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'ease',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> easeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'ease',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> easeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'ease',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> idGreaterThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> idLessThan(
    Id value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition> idBetween(
    Id lower,
    Id upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'id',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      intervalDaysEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      intervalDaysGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      intervalDaysLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'intervalDays',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      intervalDaysBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'intervalDays',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      lastSeenAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'lastSeenAt',
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      lastSeenAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'lastSeenAt',
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      lastSeenAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      lastSeenAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      lastSeenAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'lastSeenAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      lastSeenAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'lastSeenAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      nextReviewAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'nextReviewAt',
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      nextReviewAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'nextReviewAt',
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      nextReviewAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'nextReviewAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      nextReviewAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'nextReviewAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      nextReviewAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'nextReviewAt',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      nextReviewAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'nextReviewAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      seenCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'seenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      seenCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'seenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      seenCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'seenCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      seenCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'seenCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wordKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wordKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wordKey',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'wordKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'wordKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'wordKey',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'wordKey',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wordKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wordKeyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'wordKey',
        value: '',
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wrongCountEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'wrongCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wrongCountGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'wrongCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wrongCountLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'wrongCount',
        value: value,
      ));
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterFilterCondition>
      wrongCountBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'wrongCount',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension WordProgressQueryObject
    on QueryBuilder<WordProgress, WordProgress, QFilterCondition> {}

extension WordProgressQueryLinks
    on QueryBuilder<WordProgress, WordProgress, QFilterCondition> {}

extension WordProgressQuerySortBy
    on QueryBuilder<WordProgress, WordProgress, QSortBy> {
  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      sortByCorrectCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByEase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ease', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByEaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ease', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      sortByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      sortByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByNextReviewAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewAt', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      sortByNextReviewAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewAt', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortBySeenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortBySeenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByWordKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordKey', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByWordKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordKey', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> sortByWrongCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongCount', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      sortByWrongCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongCount', Sort.desc);
    });
  }
}

extension WordProgressQuerySortThenBy
    on QueryBuilder<WordProgress, WordProgress, QSortThenBy> {
  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      thenByCorrectCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'correctCount', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByEase() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ease', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByEaseDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'ease', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      thenByIntervalDaysDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'intervalDays', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      thenByLastSeenAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'lastSeenAt', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByNextReviewAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewAt', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      thenByNextReviewAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'nextReviewAt', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenBySeenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenBySeenCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'seenCount', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByWordKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordKey', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByWordKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wordKey', Sort.desc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy> thenByWrongCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongCount', Sort.asc);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QAfterSortBy>
      thenByWrongCountDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'wrongCount', Sort.desc);
    });
  }
}

extension WordProgressQueryWhereDistinct
    on QueryBuilder<WordProgress, WordProgress, QDistinct> {
  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByCorrectCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'correctCount');
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByEase() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'ease');
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByIntervalDays() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'intervalDays');
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByLastSeenAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'lastSeenAt');
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByNextReviewAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'nextReviewAt');
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctBySeenCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'seenCount');
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByWordKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wordKey', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<WordProgress, WordProgress, QDistinct> distinctByWrongCount() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'wrongCount');
    });
  }
}

extension WordProgressQueryProperty
    on QueryBuilder<WordProgress, WordProgress, QQueryProperty> {
  QueryBuilder<WordProgress, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<WordProgress, int, QQueryOperations> correctCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'correctCount');
    });
  }

  QueryBuilder<WordProgress, double, QQueryOperations> easeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'ease');
    });
  }

  QueryBuilder<WordProgress, int, QQueryOperations> intervalDaysProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'intervalDays');
    });
  }

  QueryBuilder<WordProgress, DateTime?, QQueryOperations> lastSeenAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'lastSeenAt');
    });
  }

  QueryBuilder<WordProgress, DateTime?, QQueryOperations>
      nextReviewAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'nextReviewAt');
    });
  }

  QueryBuilder<WordProgress, int, QQueryOperations> seenCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'seenCount');
    });
  }

  QueryBuilder<WordProgress, String, QQueryOperations> wordKeyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wordKey');
    });
  }

  QueryBuilder<WordProgress, int, QQueryOperations> wrongCountProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'wrongCount');
    });
  }
}
