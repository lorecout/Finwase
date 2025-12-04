// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'station.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetStationEntityCollection on Isar {
  IsarCollection<StationEntity> get stationEntitys => this.collection();
}

const StationEntitySchema = CollectionSchema(
  name: r'StationEntity',
  id: -8340744117668150026,
  properties: {
    r'baseRatePerSec': PropertySchema(
      id: 0,
      name: r'baseRatePerSec',
      type: IsarType.double,
    ),
    r'key': PropertySchema(
      id: 1,
      name: r'key',
      type: IsarType.string,
    ),
    r'level': PropertySchema(
      id: 2,
      name: r'level',
      type: IsarType.long,
    ),
    r'multiplier': PropertySchema(
      id: 3,
      name: r'multiplier',
      type: IsarType.double,
    ),
    r'valuePerDish': PropertySchema(
      id: 4,
      name: r'valuePerDish',
      type: IsarType.double,
    )
  },
  estimateSize: _stationEntityEstimateSize,
  serialize: _stationEntitySerialize,
  deserialize: _stationEntityDeserialize,
  deserializeProp: _stationEntityDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _stationEntityGetId,
  getLinks: _stationEntityGetLinks,
  attach: _stationEntityAttach,
  version: '3.1.0+1',
);

int _stationEntityEstimateSize(
  StationEntity object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.key.length * 3;
  return bytesCount;
}

void _stationEntitySerialize(
  StationEntity object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.baseRatePerSec);
  writer.writeString(offsets[1], object.key);
  writer.writeLong(offsets[2], object.level);
  writer.writeDouble(offsets[3], object.multiplier);
  writer.writeDouble(offsets[4], object.valuePerDish);
}

StationEntity _stationEntityDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = StationEntity();
  object.baseRatePerSec = reader.readDouble(offsets[0]);
  object.id = id;
  object.key = reader.readString(offsets[1]);
  object.level = reader.readLong(offsets[2]);
  object.multiplier = reader.readDouble(offsets[3]);
  object.valuePerDish = reader.readDouble(offsets[4]);
  return object;
}

P _stationEntityDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readString(offset)) as P;
    case 2:
      return (reader.readLong(offset)) as P;
    case 3:
      return (reader.readDouble(offset)) as P;
    case 4:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _stationEntityGetId(StationEntity object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _stationEntityGetLinks(StationEntity object) {
  return [];
}

void _stationEntityAttach(
    IsarCollection<dynamic> col, Id id, StationEntity object) {
  object.id = id;
}

extension StationEntityQueryWhereSort
    on QueryBuilder<StationEntity, StationEntity, QWhere> {
  QueryBuilder<StationEntity, StationEntity, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension StationEntityQueryWhere
    on QueryBuilder<StationEntity, StationEntity, QWhereClause> {
  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterWhereClause> idBetween(
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
}

extension StationEntityQueryFilter
    on QueryBuilder<StationEntity, StationEntity, QFilterCondition> {
  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      baseRatePerSecEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'baseRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      baseRatePerSecGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'baseRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      baseRatePerSecLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'baseRatePerSec',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      baseRatePerSecBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'baseRatePerSec',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> idEqualTo(
      Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      idGreaterThan(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> idBetween(
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

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> keyEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      keyGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> keyLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> keyBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'key',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      keyStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> keyEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> keyContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'key',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition> keyMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'key',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      keyIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      keyIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'key',
        value: '',
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      levelEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      levelGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      levelLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'level',
        value: value,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      levelBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'level',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      multiplierEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      multiplierGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      multiplierLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'multiplier',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      multiplierBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'multiplier',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      valuePerDishEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'valuePerDish',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      valuePerDishGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'valuePerDish',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      valuePerDishLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'valuePerDish',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterFilterCondition>
      valuePerDishBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'valuePerDish',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension StationEntityQueryObject
    on QueryBuilder<StationEntity, StationEntity, QFilterCondition> {}

extension StationEntityQueryLinks
    on QueryBuilder<StationEntity, StationEntity, QFilterCondition> {}

extension StationEntityQuerySortBy
    on QueryBuilder<StationEntity, StationEntity, QSortBy> {
  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByBaseRatePerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRatePerSec', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByBaseRatePerSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRatePerSec', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> sortByMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByValuePerDish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valuePerDish', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      sortByValuePerDishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valuePerDish', Sort.desc);
    });
  }
}

extension StationEntityQuerySortThenBy
    on QueryBuilder<StationEntity, StationEntity, QSortThenBy> {
  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByBaseRatePerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRatePerSec', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByBaseRatePerSecDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'baseRatePerSec', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByKey() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByKeyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'key', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByLevelDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'level', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy> thenByMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByMultiplierDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'multiplier', Sort.desc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByValuePerDish() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valuePerDish', Sort.asc);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QAfterSortBy>
      thenByValuePerDishDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'valuePerDish', Sort.desc);
    });
  }
}

extension StationEntityQueryWhereDistinct
    on QueryBuilder<StationEntity, StationEntity, QDistinct> {
  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByBaseRatePerSec() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'baseRatePerSec');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByKey(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'key', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByLevel() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'level');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct> distinctByMultiplier() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'multiplier');
    });
  }

  QueryBuilder<StationEntity, StationEntity, QDistinct>
      distinctByValuePerDish() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'valuePerDish');
    });
  }
}

extension StationEntityQueryProperty
    on QueryBuilder<StationEntity, StationEntity, QQueryProperty> {
  QueryBuilder<StationEntity, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<StationEntity, double, QQueryOperations>
      baseRatePerSecProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'baseRatePerSec');
    });
  }

  QueryBuilder<StationEntity, String, QQueryOperations> keyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'key');
    });
  }

  QueryBuilder<StationEntity, int, QQueryOperations> levelProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'level');
    });
  }

  QueryBuilder<StationEntity, double, QQueryOperations> multiplierProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'multiplier');
    });
  }

  QueryBuilder<StationEntity, double, QQueryOperations> valuePerDishProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'valuePerDish');
    });
  }
}
