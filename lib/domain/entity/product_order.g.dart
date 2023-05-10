// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_order.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters

extension GetProductOrderCollection on Isar {
  IsarCollection<ProductOrder> get productOrders => this.collection();
}

const ProductOrderSchema = CollectionSchema(
  name: r'ProductOrder',
  id: 5230335016252659897,
  properties: {
    r'code': PropertySchema(
      id: 0,
      name: r'code',
      type: IsarType.string,
    ),
    r'date': PropertySchema(
      id: 1,
      name: r'date',
      type: IsarType.dateTime,
    ),
    r'imagePath': PropertySchema(
      id: 2,
      name: r'imagePath',
      type: IsarType.string,
    ),
    r'name': PropertySchema(
      id: 3,
      name: r'name',
      type: IsarType.string,
    ),
    r'packagePrice': PropertySchema(
      id: 4,
      name: r'packagePrice',
      type: IsarType.double,
    ),
    r'packagesQty': PropertySchema(
      id: 5,
      name: r'packagesQty',
      type: IsarType.long,
    ),
    r'packagesQtyStore': PropertySchema(
      id: 6,
      name: r'packagesQtyStore',
      type: IsarType.long,
    ),
    r'piecePrice': PropertySchema(
      id: 7,
      name: r'piecePrice',
      type: IsarType.double,
    ),
    r'piecesPerPackage': PropertySchema(
      id: 8,
      name: r'piecesPerPackage',
      type: IsarType.long,
    ),
    r'piecesQty': PropertySchema(
      id: 9,
      name: r'piecesQty',
      type: IsarType.long,
    ),
    r'productId': PropertySchema(
      id: 10,
      name: r'productId',
      type: IsarType.long,
    ),
    r'stringify': PropertySchema(
      id: 11,
      name: r'stringify',
      type: IsarType.bool,
    )
  },
  estimateSize: _productOrderEstimateSize,
  serialize: _productOrderSerialize,
  deserialize: _productOrderDeserialize,
  deserializeProp: _productOrderDeserializeProp,
  idName: r'id',
  indexes: {},
  links: {},
  embeddedSchemas: {},
  getId: _productOrderGetId,
  getLinks: _productOrderGetLinks,
  attach: _productOrderAttach,
  version: '3.0.5',
);

int _productOrderEstimateSize(
  ProductOrder object,
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
    final value = object.imagePath;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  {
    final value = object.name;
    if (value != null) {
      bytesCount += 3 + value.length * 3;
    }
  }
  return bytesCount;
}

void _productOrderSerialize(
  ProductOrder object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeString(offsets[0], object.code);
  writer.writeDateTime(offsets[1], object.date);
  writer.writeString(offsets[2], object.imagePath);
  writer.writeString(offsets[3], object.name);
  writer.writeDouble(offsets[4], object.packagePrice);
  writer.writeLong(offsets[5], object.packagesQty);
  writer.writeLong(offsets[6], object.packagesQtyStore);
  writer.writeDouble(offsets[7], object.piecePrice);
  writer.writeLong(offsets[8], object.piecesPerPackage);
  writer.writeLong(offsets[9], object.piecesQty);
  writer.writeLong(offsets[10], object.productId);
  writer.writeBool(offsets[11], object.stringify);
}

ProductOrder _productOrderDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = ProductOrder();
  object.code = reader.readStringOrNull(offsets[0]);
  object.date = reader.readDateTimeOrNull(offsets[1]);
  object.id = id;
  object.imagePath = reader.readStringOrNull(offsets[2]);
  object.name = reader.readStringOrNull(offsets[3]);
  object.packagePrice = reader.readDoubleOrNull(offsets[4]);
  object.packagesQty = reader.readLongOrNull(offsets[5]);
  object.packagesQtyStore = reader.readLongOrNull(offsets[6]);
  object.piecePrice = reader.readDoubleOrNull(offsets[7]);
  object.piecesPerPackage = reader.readLongOrNull(offsets[8]);
  object.piecesQty = reader.readLongOrNull(offsets[9]);
  object.productId = reader.readLongOrNull(offsets[10]);
  return object;
}

P _productOrderDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readStringOrNull(offset)) as P;
    case 1:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 2:
      return (reader.readStringOrNull(offset)) as P;
    case 3:
      return (reader.readStringOrNull(offset)) as P;
    case 4:
      return (reader.readDoubleOrNull(offset)) as P;
    case 5:
      return (reader.readLongOrNull(offset)) as P;
    case 6:
      return (reader.readLongOrNull(offset)) as P;
    case 7:
      return (reader.readDoubleOrNull(offset)) as P;
    case 8:
      return (reader.readLongOrNull(offset)) as P;
    case 9:
      return (reader.readLongOrNull(offset)) as P;
    case 10:
      return (reader.readLongOrNull(offset)) as P;
    case 11:
      return (reader.readBoolOrNull(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _productOrderGetId(ProductOrder object) {
  return object.id ?? Isar.autoIncrement;
}

List<IsarLinkBase<dynamic>> _productOrderGetLinks(ProductOrder object) {
  return [];
}

void _productOrderAttach(
    IsarCollection<dynamic> col, Id id, ProductOrder object) {
  object.id = id;
}

extension ProductOrderQueryWhereSort
    on QueryBuilder<ProductOrder, ProductOrder, QWhere> {
  QueryBuilder<ProductOrder, ProductOrder, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }
}

extension ProductOrderQueryWhere
    on QueryBuilder<ProductOrder, ProductOrder, QWhereClause> {
  QueryBuilder<ProductOrder, ProductOrder, QAfterWhereClause> idEqualTo(Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterWhereClause> idNotEqualTo(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterWhereClause> idGreaterThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterWhereClause> idLessThan(Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterWhereClause> idBetween(
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

extension ProductOrderQueryFilter
    on QueryBuilder<ProductOrder, ProductOrder, QFilterCondition> {
  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      codeIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'code',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeEqualTo(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      codeGreaterThan(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeLessThan(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeBetween(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      codeStartsWith(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeEndsWith(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'code',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> codeMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'code',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      codeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      codeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'code',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> dateIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      dateIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'date',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> dateEqualTo(
      DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'date',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      dateGreaterThan(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> dateLessThan(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> dateBetween(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> idIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      idIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'id',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> idEqualTo(
      Id? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> idGreaterThan(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> idLessThan(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> idBetween(
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

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'imagePath',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'imagePath',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'imagePath',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'imagePath',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      imagePathIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'imagePath',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      nameIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'name',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameEqualTo(
    String? value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      nameGreaterThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameLessThan(
    String? value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameBetween(
    String? lower,
    String? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'name',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      nameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameContains(
      String value,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'name',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition> nameMatches(
      String pattern,
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'name',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      nameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      nameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'name',
        value: '',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagePriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packagePrice',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagePriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packagePrice',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagePriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packagePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagePriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packagePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagePriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packagePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagePriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packagePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packagesQty',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packagesQty',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packagesQty',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packagesQty',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packagesQty',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packagesQty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyStoreIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'packagesQtyStore',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyStoreIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'packagesQtyStore',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyStoreEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'packagesQtyStore',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyStoreGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'packagesQtyStore',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyStoreLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'packagesQtyStore',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      packagesQtyStoreBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'packagesQtyStore',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecePriceIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'piecePrice',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecePriceIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'piecePrice',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecePriceEqualTo(
    double? value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'piecePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecePriceGreaterThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'piecePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecePriceLessThan(
    double? value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'piecePrice',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecePriceBetween(
    double? lower,
    double? upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'piecePrice',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesPerPackageIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'piecesPerPackage',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesPerPackageIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'piecesPerPackage',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesPerPackageEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'piecesPerPackage',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesPerPackageGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'piecesPerPackage',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesPerPackageLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'piecesPerPackage',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesPerPackageBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'piecesPerPackage',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesQtyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'piecesQty',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesQtyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'piecesQty',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesQtyEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'piecesQty',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesQtyGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'piecesQty',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesQtyLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'piecesQty',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      piecesQtyBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'piecesQty',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      productIdIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      productIdIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'productId',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      productIdEqualTo(int? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      productIdGreaterThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      productIdLessThan(
    int? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'productId',
        value: value,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      productIdBetween(
    int? lower,
    int? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'productId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      stringifyIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'stringify',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      stringifyIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'stringify',
      ));
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterFilterCondition>
      stringifyEqualTo(bool? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stringify',
        value: value,
      ));
    });
  }
}

extension ProductOrderQueryObject
    on QueryBuilder<ProductOrder, ProductOrder, QFilterCondition> {}

extension ProductOrderQueryLinks
    on QueryBuilder<ProductOrder, ProductOrder, QFilterCondition> {}

extension ProductOrderQuerySortBy
    on QueryBuilder<ProductOrder, ProductOrder, QSortBy> {
  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByPackagePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagePrice', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPackagePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagePrice', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByPackagesQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQty', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPackagesQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQty', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPackagesQtyStore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQtyStore', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPackagesQtyStoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQtyStore', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByPiecePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPiecePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPiecesPerPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerPackage', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      sortByPiecesPerPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerPackage', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByPiecesQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesQty', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByPiecesQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesQty', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> sortByStringifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.desc);
    });
  }
}

extension ProductOrderQuerySortThenBy
    on QueryBuilder<ProductOrder, ProductOrder, QSortThenBy> {
  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByCode() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByCodeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'code', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'date', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByImagePath() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByImagePathDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'imagePath', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'name', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByPackagePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagePrice', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPackagePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagePrice', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByPackagesQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQty', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPackagesQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQty', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPackagesQtyStore() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQtyStore', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPackagesQtyStoreDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'packagesQtyStore', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByPiecePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPiecePriceDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecePrice', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPiecesPerPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerPackage', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy>
      thenByPiecesPerPackageDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesPerPackage', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByPiecesQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesQty', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByPiecesQtyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'piecesQty', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByProductIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'productId', Sort.desc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.asc);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QAfterSortBy> thenByStringifyDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stringify', Sort.desc);
    });
  }
}

extension ProductOrderQueryWhereDistinct
    on QueryBuilder<ProductOrder, ProductOrder, QDistinct> {
  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByCode(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'code', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'date');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByImagePath(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'imagePath', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByName(
      {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'name', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByPackagePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packagePrice');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByPackagesQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packagesQty');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct>
      distinctByPackagesQtyStore() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'packagesQtyStore');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByPiecePrice() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'piecePrice');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct>
      distinctByPiecesPerPackage() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'piecesPerPackage');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByPiecesQty() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'piecesQty');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByProductId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'productId');
    });
  }

  QueryBuilder<ProductOrder, ProductOrder, QDistinct> distinctByStringify() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stringify');
    });
  }
}

extension ProductOrderQueryProperty
    on QueryBuilder<ProductOrder, ProductOrder, QQueryProperty> {
  QueryBuilder<ProductOrder, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<ProductOrder, String?, QQueryOperations> codeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'code');
    });
  }

  QueryBuilder<ProductOrder, DateTime?, QQueryOperations> dateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'date');
    });
  }

  QueryBuilder<ProductOrder, String?, QQueryOperations> imagePathProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'imagePath');
    });
  }

  QueryBuilder<ProductOrder, String?, QQueryOperations> nameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'name');
    });
  }

  QueryBuilder<ProductOrder, double?, QQueryOperations> packagePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packagePrice');
    });
  }

  QueryBuilder<ProductOrder, int?, QQueryOperations> packagesQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packagesQty');
    });
  }

  QueryBuilder<ProductOrder, int?, QQueryOperations>
      packagesQtyStoreProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'packagesQtyStore');
    });
  }

  QueryBuilder<ProductOrder, double?, QQueryOperations> piecePriceProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'piecePrice');
    });
  }

  QueryBuilder<ProductOrder, int?, QQueryOperations>
      piecesPerPackageProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'piecesPerPackage');
    });
  }

  QueryBuilder<ProductOrder, int?, QQueryOperations> piecesQtyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'piecesQty');
    });
  }

  QueryBuilder<ProductOrder, int?, QQueryOperations> productIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'productId');
    });
  }

  QueryBuilder<ProductOrder, bool?, QQueryOperations> stringifyProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stringify');
    });
  }
}
