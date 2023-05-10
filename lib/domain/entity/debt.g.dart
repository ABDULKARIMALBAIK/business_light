// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetDebtCollection on Isar {
  IsarCollection<Debt> get debts => this.collection();
}

const DebtSchema = CollectionSchema(
  name: r'Debt',
  id: -7488304698004590828,
  properties: {
    r'balancer': PropertySchema(
      id: 0,
      name: r'balancer',
      type: IsarType.double,
    ),
    r'code': PropertySchema(
      id: 1,
      name: r'code',
      type: IsarType.string,
    ),
    r'costTaxes': PropertySchema(
      id: 2,
      name: r'costTaxes',
      type: IsarType.double,
    ),
    r'costTransit': PropertySchema(
      id: 3,
      name: r'costTransit',
      type: IsarType.double,
    ),
    r'date': PropertySchema(
      id: 4,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'description': PropertySchema(
      id: 5,
      name: r'description',
      type: IsarType.string,
    ),
    r'finalPrice': PropertySchema(
      id: 6,
      name: r'finalPrice',
      type: IsarType.double,
    ),
    r'finalPricePerPiece': PropertySchema(
      id: 7,
      name: r'finalPricePerPiece',
      type: IsarType.double,
    ),
    r'isPaid': PropertySchema(
      id: 8,
      name: r'isPaid',
      type: IsarType.bool,
    ),
    r'otherCosts': PropertySchema(
      id: 9,
      name: r'otherCosts',
      type: IsarType.double,
    ),
    r'qtyPieces': PropertySchema(
      id: 10,
      name: r'qtyPieces',
      type: IsarType.long,
    ),
    r'totalQty': PropertySchema(
      id: 11,
      name: r'totalQty',
      type: IsarType.long,
    ),
    r'type': PropertySchema(
      id: 12,
      name: r'type',
      type: IsarType.byte,
      enumMap: _DebttypeEnumValueMap,
    )
  },
  estimateSize: _debtEstimateSize,
  serialize: _debtSerialize,
  deserialize: _debtDeserialize,
  deserializeProp: _debtDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {
    r'company': LinkSchema(
      id: -1629654253904323636,
      name: r'company',
      target: r'Company',
      single: true,
    ),
    r'currency': LinkSchema(
      id: -6048274391829143838,
      name: r'currency',
      target: r'Currency',
      single: true,
    ),
    r'payouts': LinkSchema(
      id: 5717416075551078226,
      name: r'payouts',
      target: r'Payout',
      single: false,
    ),
    r'products': LinkSchema(
      id: -7248733920067993061,
      name: r'products',
      target: r'Product',
      single: false,
    )
  },
  embeddedSchemas: {},
  getId: _debtGetId,
  getLinks: _debtGetLinks,
  attach: _debtAttach,
  version: '3.0.5',
);

int _debtEstimateSize(
  Debt object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  {
    final value = object.code;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.description;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _debtSerialize(
  Debt object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.balancer);
  writer.writeString(offsets[1], object.code);
  writer.writeDouble(offsets[2], object.costTaxes);
  writer.writeDouble(offsets[3], object.costTransit);
  writer.writeDateTime(offsets[4], object.date);
  writer.writeString(offsets[5], object.description);
  writer.writeDouble(offsets[6], object.finalPrice);
  writer.writeDouble(offsets[7], object.finalPricePerPiece);
  writer.writeBool(offsets[8], object.isPaid);
  writer.writeDouble(offsets[9], object.otherCosts);
  writer.writeLong(offsets[10], object.qtyPieces);
  writer.writeLong(offsets[11], object.totalQty);
  writer.writeByte(offsets[12], object.type.index);
}

Debt _debtDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = Debt();
  object.balancer = reader.readDoubleOrNull(offsets[0]);
  object.code = reader.readStringOrNull(offsets[1]);
  object.costTaxes = reader.readDoubleOrNull(offsets[2]);
  object.costTransit = reader.readDoubleOrNull(offsets[3]);
  object.date = reader.readDateTimeOrNull(offsets[4]);
  object.description = reader.readStringOrNull(offsets[5]);
  object.finalPrice = reader.readDoubleOrNull(offsets[6]);
  object.finalPricePerPiece = reader.readDoubleOrNull(offsets[7]);
  object.id = id;
  object.isPaid = reader.readBool(offsets[8]);
  object.otherCosts = reader.readDoubleOrNull(offsets[9]);
  object.qtyPieces = reader.readLongOrNull(offsets[10]);
  object.totalQty = reader.readLongOrNull(offsets[11]);
  object.type = _DebttypeValueEnumMap[reader.readByteOrNull(offsets[12])] ??
      TypeDebt.negotiation;
  return object;
}

P _debtDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDoubleOrNull(offset)) as P;
    case 1:
      return (reader.readStringOrNull(offset)) as P;
    case 2:
      return (reader.readDoubleOrNull(offset)) as P;
    case 3:
      return (reader.readDoubleOrNull(offset)) as P;
    case 4:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 5:
      return (reader.readStringOrNull(offset)) as P;
    case 6:
      return (reader.readDoubleOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readBool(offset)) as P;
    case 9:
      return (reader.readDoubleOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readLongOrNull(offset)) as P;
    case 12:
      return (_DebttypeValueEnumMap[reader.readByteOrNull(offset)] ??
          TypeDebt.negotiation) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

const _DebttypeEnumValueMap = {
  'negotiation': 0,
  'deal': 1,
  'sell': 2,
  'complete': 3,
};
const _DebttypeValueEnumMap = {
  0: TypeDebt.negotiation,
  1: TypeDebt.deal,
  2: TypeDebt.sell,
  3: TypeDebt.complete,
};

Id _debtGetId(Debt object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _debtGetLinks(Debt object) {
  return [object.company, object.currency, object.payouts, object.products];
}

void _debtAttach(IsarCollection<dynamic> col, Id id, Debt object) {
  object.id = id;
  object.company.attach(col, col.isar.collection<Company>(), r'company', id);
  object.currency.attach(col, col.isar.collection<Currency>(), r'currency', id);
  object.payouts.attach(col, col.isar.collection<Payout>(), r'payouts', id);
  object.products.attach(col, col.isar.collection<Product>(), r'products', id);
}

extension DebtQueryWhereSort on QueryBuilder<Debt, Debt, QWhere> {
  QueryBuilder<Debt, Debt, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension DebtQueryWhere on QueryBuilder<Debt, Debt, QWhereClause> {
  QueryBuilder<Debt, Debt, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterWhereClause> idNotEqualTo(Id id) {
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

  QueryBuilder<Debt, Debt, QAfterWhereClause> idGreaterThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<Debt, Debt, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<Debt, Debt, QAfterWhereClause> idBetween(
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

extension DebtQueryFilter on QueryBuilder<Debt, Debt, QFilterCondition> {
  QueryBuilder<Debt, Debt, QAfterFilterCondition> balancerIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'balancer',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> balancerIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'balancer',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> balancerEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balancer',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> balancerGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balancer',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> balancerLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balancer',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> balancerBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balancer',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'code',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeContains(String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeMatches(String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTaxesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'costTaxes',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTaxesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'costTaxes',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTaxesEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'costTaxes',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTaxesGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'costTaxes',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTaxesLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'costTaxes',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTaxesBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'costTaxes',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTransitIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'costTransit',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTransitIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'costTransit',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTransitEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'costTransit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTransitGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'costTransit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTransitLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'costTransit',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> costTransitBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'costTransit',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> dateEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> dateGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> dateLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> dateBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'date',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'description',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'description',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'description',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'description',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> descriptionIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'description',
        value: '',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finalPrice',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finalPrice',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalPrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalPrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPricePerPieceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'finalPricePerPiece',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition>
      finalPricePerPieceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'finalPricePerPiece',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPricePerPieceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'finalPricePerPiece',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPricePerPieceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'finalPricePerPiece',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPricePerPieceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'finalPricePerPiece',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> finalPricePerPieceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'finalPricePerPiece',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> idEqualTo(Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> idGreaterThan(
    Id? value, {
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

  QueryBuilder<Debt, Debt, QAfterFilterCondition> idLessThan(
    Id? value, {
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

  QueryBuilder<Debt, Debt, QAfterFilterCondition> idBetween(
    Id? lower,
    Id? upper, {
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

  QueryBuilder<Debt, Debt, QAfterFilterCondition> isPaidEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isPaid',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> otherCostsIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'otherCosts',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> otherCostsIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'otherCosts',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> otherCostsEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'otherCosts',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> otherCostsGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'otherCosts',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> otherCostsLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'otherCosts',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> otherCostsBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'otherCosts',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> qtyPiecesIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'qtyPieces',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> qtyPiecesIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'qtyPieces',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> qtyPiecesEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'qtyPieces',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> qtyPiecesGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'qtyPieces',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> qtyPiecesLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'qtyPieces',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> qtyPiecesBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'qtyPieces',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> totalQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'totalQty',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> totalQtyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'totalQty',
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> totalQtyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'totalQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> totalQtyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'totalQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> totalQtyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'totalQty',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> totalQtyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'totalQty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> typeEqualTo(TypeDebt value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> typeGreaterThan(
    TypeDebt value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> typeLessThan(
    TypeDebt value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'type',
        value: value,
      ));
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> typeBetween(
    TypeDebt lower,
    TypeDebt upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'type',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }
}

extension DebtQueryObject on QueryBuilder<Debt, Debt, QFilterCondition> {}

extension DebtQueryLinks on QueryBuilder<Debt, Debt, QFilterCondition> {
  QueryBuilder<Debt, Debt, QAfterFilterCondition> company(
      FilterQuery<Company> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'company');
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> companyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'company', 0, true, 0, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> currency(
      FilterQuery<Currency> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'currency');
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> currencyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'currency', 0, true, 0, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payouts(
      FilterQuery<Payout> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'payouts');
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payoutsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payouts', length, true, length, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payoutsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payouts', 0, true, 0, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payoutsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payouts', 0, false, 999999, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payoutsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payouts', 0, true, length, include);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payoutsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'payouts', length, include, 999999, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> payoutsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'payouts', lower, includeLower, upper, includeUpper);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> products(
      FilterQuery<Product> q) {
    return QueryBuilder.apply(this, (query) {
      return query.link(q, r'products');
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> productsLengthEqualTo(
      int length) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'products', length, true, length, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> productsIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'products', 0, true, 0, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> productsIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'products', 0, false, 999999, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> productsLengthLessThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'products', 0, true, length, include);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> productsLengthGreaterThan(
    int length, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(r'products', length, include, 999999, true);
    });
  }

  QueryBuilder<Debt, Debt, QAfterFilterCondition> productsLengthBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.linkLength(
          r'products', lower, includeLower, upper, includeUpper);
    });
  }
}

extension DebtQuerySortBy on QueryBuilder<Debt, Debt, QSortBy> {
  QueryBuilder<Debt, Debt, QAfterSortBy> sortByBalancer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balancer', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByBalancerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balancer', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByCostTaxes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTaxes', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByCostTaxesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTaxes', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByCostTransit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTransit', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByCostTransitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTransit', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByFinalPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPrice', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByFinalPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPrice', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByFinalPricePerPiece() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPricePerPiece', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByFinalPricePerPieceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPricePerPiece', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByOtherCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherCosts', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByOtherCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherCosts', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByQtyPieces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyPieces', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByQtyPiecesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyPieces', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByTotalQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQty', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByTotalQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQty', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> sortByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DebtQuerySortThenBy on QueryBuilder<Debt, Debt, QSortThenBy> {
  QueryBuilder<Debt, Debt, QAfterSortBy> thenByBalancer() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balancer', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByBalancerDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balancer', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByCostTaxes() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTaxes', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByCostTaxesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTaxes', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByCostTransit() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTransit', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByCostTransitDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'costTransit', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByDescription() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByDescriptionDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'description', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByFinalPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPrice', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByFinalPriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPrice', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByFinalPricePerPiece() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPricePerPiece', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByFinalPricePerPieceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'finalPricePerPiece', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByIsPaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isPaid', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByOtherCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherCosts', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByOtherCostsDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'otherCosts', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByQtyPieces() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyPieces', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByQtyPiecesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'qtyPieces', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByTotalQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQty', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByTotalQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'totalQty', Sort.desc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.asc);
    });
  }

  QueryBuilder<Debt, Debt, QAfterSortBy> thenByTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'type', Sort.desc);
    });
  }
}

extension DebtQueryWhereDistinct on QueryBuilder<Debt, Debt, QDistinct> {
  QueryBuilder<Debt, Debt, QDistinct> distinctByBalancer() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balancer');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByCostTaxes() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'costTaxes');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByCostTransit() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'costTransit');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByDescription(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'description', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByFinalPrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalPrice');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByFinalPricePerPiece() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'finalPricePerPiece');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByIsPaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isPaid');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByOtherCosts() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'otherCosts');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByQtyPieces() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'qtyPieces');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByTotalQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'totalQty');
    });
  }

  QueryBuilder<Debt, Debt, QDistinct> distinctByType() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'type');
    });
  }
}

extension DebtQueryProperty on QueryBuilder<Debt, Debt, QQueryProperty> {
  QueryBuilder<Debt, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<Debt, double?, QQueryOperations> balancerProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balancer');
    });
  }

  QueryBuilder<Debt, String?, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<Debt, double?, QQueryOperations> costTaxesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'costTaxes');
    });
  }

  QueryBuilder<Debt, double?, QQueryOperations> costTransitProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'costTransit');
    });
  }

  QueryBuilder<Debt, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<Debt, String?, QQueryOperations> descriptionProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'description');
    });
  }

  QueryBuilder<Debt, double?, QQueryOperations> finalPriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalPrice');
    });
  }

  QueryBuilder<Debt, double?, QQueryOperations> finalPricePerPieceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'finalPricePerPiece');
    });
  }

  QueryBuilder<Debt, bool, QQueryOperations> isPaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isPaid');
    });
  }

  QueryBuilder<Debt, double?, QQueryOperations> otherCostsProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'otherCosts');
    });
  }

  QueryBuilder<Debt, int?, QQueryOperations> qtyPiecesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'qtyPieces');
    });
  }

  QueryBuilder<Debt, int?, QQueryOperations> totalQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'totalQty');
    });
  }

  QueryBuilder<Debt, TypeDebt, QQueryOperations> typeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'type');
    });
  }
}
