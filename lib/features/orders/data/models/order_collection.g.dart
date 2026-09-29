// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_collection.dart';

// **************************************************************************
// IsarCollectionGenerator
// **************************************************************************

// coverage:ignore-file
// ignore_for_file: duplicate_ignore, non_constant_identifier_names, constant_identifier_names, invalid_use_of_protected_member, unnecessary_cast, prefer_const_constructors, lines_longer_than_80_chars, require_trailing_commas, inference_failure_on_function_invocation, unnecessary_parenthesis, unnecessary_raw_strings, unnecessary_null_checks, join_return_with_assignment, prefer_final_locals, avoid_js_rounded_ints, avoid_positional_boolean_parameters, always_specify_types

extension GetOrderCollectionCollection on Isar {
  IsarCollection<OrderCollection> get orderCollections => this.collection();
}

const OrderCollectionSchema = CollectionSchema(
  name: r'OrderCollection',
  id: -17946153983657778,
  properties: {
    r'advancePaid': PropertySchema(
      id: 0,
      name: r'advancePaid',
      type: IsarType.double,
    ),
    r'balanceDue': PropertySchema(
      id: 1,
      name: r'balanceDue',
      type: IsarType.double,
    ),
    r'bookingDate': PropertySchema(
      id: 2,
      name: r'bookingDate',
      type: IsarType.dateTime,
    ),
    r'customerId': PropertySchema(
      id: 3,
      name: r'customerId',
      type: IsarType.long,
    ),
    r'customerName': PropertySchema(
      id: 4,
      name: r'customerName',
      type: IsarType.string,
    ),
    r'customerPhone': PropertySchema(
      id: 5,
      name: r'customerPhone',
      type: IsarType.string,
    ),
    r'deletedAt': PropertySchema(
      id: 6,
      name: r'deletedAt',
      type: IsarType.dateTime,
    ),
    r'fabricCharges': PropertySchema(
      id: 7,
      name: r'fabricCharges',
      type: IsarType.double,
    ),
    r'garmentType': PropertySchema(
      id: 8,
      name: r'garmentType',
      type: IsarType.string,
    ),
    r'isDeleted': PropertySchema(
      id: 9,
      name: r'isDeleted',
      type: IsarType.bool,
    ),
    r'isUrgent': PropertySchema(
      id: 10,
      name: r'isUrgent',
      type: IsarType.bool,
    ),
    r'orderToken': PropertySchema(
      id: 11,
      name: r'orderToken',
      type: IsarType.string,
    ),
    r'status': PropertySchema(
      id: 12,
      name: r'status',
      type: IsarType.long,
    ),
    r'stitchingRate': PropertySchema(
      id: 13,
      name: r'stitchingRate',
      type: IsarType.double,
    ),
    r'targetDeadline': PropertySchema(
      id: 14,
      name: r'targetDeadline',
      type: IsarType.dateTime,
    ),
    r'urgentSurcharge': PropertySchema(
      id: 15,
      name: r'urgentSurcharge',
      type: IsarType.double,
    )
  },
  estimateSize: _orderCollectionEstimateSize,
  serialize: _orderCollectionSerialize,
  deserialize: _orderCollectionDeserialize,
  deserializeProp: _orderCollectionDeserializeProp,
  idName: r'id',
  indexes: {
    r'orderToken': IndexSchema(
      id: -2685489614045301294,
      name: r'orderToken',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'orderToken',
          type: IndexType.hash,
          caseSensitive: true,
        )
      ],
    ),
    r'targetDeadline': IndexSchema(
      id: -5061452879862784594,
      name: r'targetDeadline',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'targetDeadline',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'status': IndexSchema(
      id: -107785170620420283,
      name: r'status',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'status',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    ),
    r'isDeleted': IndexSchema(
      id: -786475870904832312,
      name: r'isDeleted',
      unique: false,
      replace: false,
      properties: [
        IndexPropertySchema(
          name: r'isDeleted',
          type: IndexType.value,
          caseSensitive: false,
        )
      ],
    )
  },
  links: {},
  embeddedSchemas: {},
  getId: _orderCollectionGetId,
  getLinks: _orderCollectionGetLinks,
  attach: _orderCollectionAttach,
  version: '3.1.0+1',
);

int _orderCollectionEstimateSize(
  OrderCollection object,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  var bytesCount = offsets.last;
  bytesCount += 3 + object.customerName.length * 3;
  bytesCount += 3 + object.customerPhone.length * 3;
  bytesCount += 3 + object.garmentType.length * 3;
  bytesCount += 3 + object.orderToken.length * 3;
  return bytesCount;
}

void _orderCollectionSerialize(
  OrderCollection object,
  IsarWriter writer,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  writer.writeDouble(offsets[0], object.advancePaid);
  writer.writeDouble(offsets[1], object.balanceDue);
  writer.writeDateTime(offsets[2], object.bookingDate);
  writer.writeLong(offsets[3], object.customerId);
  writer.writeString(offsets[4], object.customerName);
  writer.writeString(offsets[5], object.customerPhone);
  writer.writeDateTime(offsets[6], object.deletedAt);
  writer.writeDouble(offsets[7], object.fabricCharges);
  writer.writeString(offsets[8], object.garmentType);
  writer.writeBool(offsets[9], object.isDeleted);
  writer.writeBool(offsets[10], object.isUrgent);
  writer.writeString(offsets[11], object.orderToken);
  writer.writeLong(offsets[12], object.status);
  writer.writeDouble(offsets[13], object.stitchingRate);
  writer.writeDateTime(offsets[14], object.targetDeadline);
  writer.writeDouble(offsets[15], object.urgentSurcharge);
}

OrderCollection _orderCollectionDeserialize(
  Id id,
  IsarReader reader,
  List<int> offsets,
  Map<Type, List<int>> allOffsets,
) {
  final object = OrderCollection();
  object.advancePaid = reader.readDouble(offsets[0]);
  object.balanceDue = reader.readDouble(offsets[1]);
  object.bookingDate = reader.readDateTime(offsets[2]);
  object.customerId = reader.readLong(offsets[3]);
  object.customerName = reader.readString(offsets[4]);
  object.customerPhone = reader.readString(offsets[5]);
  object.deletedAt = reader.readDateTimeOrNull(offsets[6]);
  object.fabricCharges = reader.readDouble(offsets[7]);
  object.garmentType = reader.readString(offsets[8]);
  object.id = id;
  object.isDeleted = reader.readBool(offsets[9]);
  object.isUrgent = reader.readBool(offsets[10]);
  object.orderToken = reader.readString(offsets[11]);
  object.status = reader.readLong(offsets[12]);
  object.stitchingRate = reader.readDouble(offsets[13]);
  object.targetDeadline = reader.readDateTime(offsets[14]);
  object.urgentSurcharge = reader.readDouble(offsets[15]);
  return object;
}

P _orderCollectionDeserializeProp<P>(
  IsarReader reader,
  int propertyId,
  int offset,
  Map<Type, List<int>> allOffsets,
) {
  switch (propertyId) {
    case 0:
      return (reader.readDouble(offset)) as P;
    case 1:
      return (reader.readDouble(offset)) as P;
    case 2:
      return (reader.readDateTime(offset)) as P;
    case 3:
      return (reader.readLong(offset)) as P;
    case 4:
      return (reader.readString(offset)) as P;
    case 5:
      return (reader.readString(offset)) as P;
    case 6:
      return (reader.readDateTimeOrNull(offset)) as P;
    case 7:
      return (reader.readDouble(offset)) as P;
    case 8:
      return (reader.readString(offset)) as P;
    case 9:
      return (reader.readBool(offset)) as P;
    case 10:
      return (reader.readBool(offset)) as P;
    case 11:
      return (reader.readString(offset)) as P;
    case 12:
      return (reader.readLong(offset)) as P;
    case 13:
      return (reader.readDouble(offset)) as P;
    case 14:
      return (reader.readDateTime(offset)) as P;
    case 15:
      return (reader.readDouble(offset)) as P;
    default:
      throw IsarError('Unknown property with id $propertyId');
  }
}

Id _orderCollectionGetId(OrderCollection object) {
  return object.id;
}

List<IsarLinkBase<dynamic>> _orderCollectionGetLinks(OrderCollection object) {
  return [];
}

void _orderCollectionAttach(
    IsarCollection<dynamic> col, Id id, OrderCollection object) {
  object.id = id;
}

extension OrderCollectionQueryWhereSort
    on QueryBuilder<OrderCollection, OrderCollection, QWhere> {
  QueryBuilder<OrderCollection, OrderCollection, QAfterWhere> anyId() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(const IdWhereClause.any());
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhere>
      anyTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'targetDeadline'),
      );
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhere> anyStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'status'),
      );
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhere> anyIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        const IndexWhereClause.any(indexName: r'isDeleted'),
      );
    });
  }
}

extension OrderCollectionQueryWhere
    on QueryBuilder<OrderCollection, OrderCollection, QWhereClause> {
  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause> idEqualTo(
      Id id) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IdWhereClause.between(
        lower: id,
        upper: id,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      idNotEqualTo(Id id) {
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

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      idGreaterThan(Id id, {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.greaterThan(lower: id, includeLower: include),
      );
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause> idLessThan(
      Id id,
      {bool include = false}) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(
        IdWhereClause.lessThan(upper: id, includeUpper: include),
      );
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause> idBetween(
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

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      orderTokenEqualTo(String orderToken) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'orderToken',
        value: [orderToken],
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      orderTokenNotEqualTo(String orderToken) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderToken',
              lower: [],
              upper: [orderToken],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderToken',
              lower: [orderToken],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderToken',
              lower: [orderToken],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'orderToken',
              lower: [],
              upper: [orderToken],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      targetDeadlineEqualTo(DateTime targetDeadline) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'targetDeadline',
        value: [targetDeadline],
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      targetDeadlineNotEqualTo(DateTime targetDeadline) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetDeadline',
              lower: [],
              upper: [targetDeadline],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetDeadline',
              lower: [targetDeadline],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetDeadline',
              lower: [targetDeadline],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'targetDeadline',
              lower: [],
              upper: [targetDeadline],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      targetDeadlineGreaterThan(
    DateTime targetDeadline, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetDeadline',
        lower: [targetDeadline],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      targetDeadlineLessThan(
    DateTime targetDeadline, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetDeadline',
        lower: [],
        upper: [targetDeadline],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      targetDeadlineBetween(
    DateTime lowerTargetDeadline,
    DateTime upperTargetDeadline, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'targetDeadline',
        lower: [lowerTargetDeadline],
        includeLower: includeLower,
        upper: [upperTargetDeadline],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      statusEqualTo(int status) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'status',
        value: [status],
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      statusNotEqualTo(int status) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [status],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'status',
              lower: [],
              upper: [status],
              includeUpper: false,
            ));
      }
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      statusGreaterThan(
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [status],
        includeLower: include,
        upper: [],
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      statusLessThan(
    int status, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [],
        upper: [status],
        includeUpper: include,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      statusBetween(
    int lowerStatus,
    int upperStatus, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.between(
        indexName: r'status',
        lower: [lowerStatus],
        includeLower: includeLower,
        upper: [upperStatus],
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      isDeletedEqualTo(bool isDeleted) {
    return QueryBuilder.apply(this, (query) {
      return query.addWhereClause(IndexWhereClause.equalTo(
        indexName: r'isDeleted',
        value: [isDeleted],
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterWhereClause>
      isDeletedNotEqualTo(bool isDeleted) {
    return QueryBuilder.apply(this, (query) {
      if (query.whereSort == Sort.asc) {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDeleted',
              lower: [],
              upper: [isDeleted],
              includeUpper: false,
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDeleted',
              lower: [isDeleted],
              includeLower: false,
              upper: [],
            ));
      } else {
        return query
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDeleted',
              lower: [isDeleted],
              includeLower: false,
              upper: [],
            ))
            .addWhereClause(IndexWhereClause.between(
              indexName: r'isDeleted',
              lower: [],
              upper: [isDeleted],
              includeUpper: false,
            ));
      }
    });
  }
}

extension OrderCollectionQueryFilter
    on QueryBuilder<OrderCollection, OrderCollection, QFilterCondition> {
  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      advancePaidEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'advancePaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      advancePaidGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'advancePaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      advancePaidLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'advancePaid',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      advancePaidBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'advancePaid',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      balanceDueEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'balanceDue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      balanceDueGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'balanceDue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      balanceDueLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'balanceDue',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      balanceDueBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'balanceDue',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      bookingDateEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'bookingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      bookingDateGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'bookingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      bookingDateLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'bookingDate',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      bookingDateBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'bookingDate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerIdEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerIdGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerIdLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerId',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerIdBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerId',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerName',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerName',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerName',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerNameIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerName',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'customerPhone',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'customerPhone',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'customerPhone',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'customerPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      customerPhoneIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'customerPhone',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      deletedAtIsNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      deletedAtIsNotNull() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(const FilterCondition.isNotNull(
        property: r'deletedAt',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      deletedAtEqualTo(DateTime? value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      deletedAtGreaterThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      deletedAtLessThan(
    DateTime? value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'deletedAt',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      deletedAtBetween(
    DateTime? lower,
    DateTime? upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'deletedAt',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      fabricChargesEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'fabricCharges',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      fabricChargesGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'fabricCharges',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      fabricChargesLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'fabricCharges',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      fabricChargesBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'fabricCharges',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'garmentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'garmentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'garmentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'garmentType',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'garmentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'garmentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'garmentType',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'garmentType',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'garmentType',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      garmentTypeIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'garmentType',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      idEqualTo(Id value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'id',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
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

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      idLessThan(
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

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      idBetween(
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

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      isDeletedEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isDeleted',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      isUrgentEqualTo(bool value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'isUrgent',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenEqualTo(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenGreaterThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'orderToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenLessThan(
    String value, {
    bool include = false,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'orderToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenBetween(
    String lower,
    String upper, {
    bool includeLower = true,
    bool includeUpper = true,
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'orderToken',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenStartsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.startsWith(
        property: r'orderToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenEndsWith(
    String value, {
    bool caseSensitive = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.endsWith(
        property: r'orderToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenContains(String value, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.contains(
        property: r'orderToken',
        value: value,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenMatches(String pattern, {bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.matches(
        property: r'orderToken',
        wildcard: pattern,
        caseSensitive: caseSensitive,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenIsEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'orderToken',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      orderTokenIsNotEmpty() {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        property: r'orderToken',
        value: '',
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      statusEqualTo(int value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      statusGreaterThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      statusLessThan(
    int value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'status',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      statusBetween(
    int lower,
    int upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'status',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      stitchingRateEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'stitchingRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      stitchingRateGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'stitchingRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      stitchingRateLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'stitchingRate',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      stitchingRateBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'stitchingRate',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      targetDeadlineEqualTo(DateTime value) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'targetDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      targetDeadlineGreaterThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'targetDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      targetDeadlineLessThan(
    DateTime value, {
    bool include = false,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'targetDeadline',
        value: value,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      targetDeadlineBetween(
    DateTime lower,
    DateTime upper, {
    bool includeLower = true,
    bool includeUpper = true,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'targetDeadline',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      urgentSurchargeEqualTo(
    double value, {
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.equalTo(
        property: r'urgentSurcharge',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      urgentSurchargeGreaterThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.greaterThan(
        include: include,
        property: r'urgentSurcharge',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      urgentSurchargeLessThan(
    double value, {
    bool include = false,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.lessThan(
        include: include,
        property: r'urgentSurcharge',
        value: value,
        epsilon: epsilon,
      ));
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterFilterCondition>
      urgentSurchargeBetween(
    double lower,
    double upper, {
    bool includeLower = true,
    bool includeUpper = true,
    double epsilon = Query.epsilon,
  }) {
    return QueryBuilder.apply(this, (query) {
      return query.addFilterCondition(FilterCondition.between(
        property: r'urgentSurcharge',
        lower: lower,
        includeLower: includeLower,
        upper: upper,
        includeUpper: includeUpper,
        epsilon: epsilon,
      ));
    });
  }
}

extension OrderCollectionQueryObject
    on QueryBuilder<OrderCollection, OrderCollection, QFilterCondition> {}

extension OrderCollectionQueryLinks
    on QueryBuilder<OrderCollection, OrderCollection, QFilterCondition> {}

extension OrderCollectionQuerySortBy
    on QueryBuilder<OrderCollection, OrderCollection, QSortBy> {
  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByAdvancePaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByAdvancePaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByBalanceDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceDue', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByBalanceDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceDue', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByBookingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByFabricCharges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricCharges', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByFabricChargesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricCharges', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByGarmentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentType', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByGarmentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentType', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByIsUrgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUrgent', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByIsUrgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUrgent', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByOrderToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderToken', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByOrderTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderToken', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy> sortByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByStitchingRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stitchingRate', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByStitchingRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stitchingRate', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByTargetDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByUrgentSurcharge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentSurcharge', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      sortByUrgentSurchargeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentSurcharge', Sort.desc);
    });
  }
}

extension OrderCollectionQuerySortThenBy
    on QueryBuilder<OrderCollection, OrderCollection, QSortThenBy> {
  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByAdvancePaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByAdvancePaidDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'advancePaid', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByBalanceDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceDue', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByBalanceDueDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'balanceDue', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByBookingDateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'bookingDate', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByCustomerIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerId', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByCustomerName() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByCustomerNameDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerName', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByCustomerPhone() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByCustomerPhoneDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'customerPhone', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByDeletedAtDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'deletedAt', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByFabricCharges() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricCharges', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByFabricChargesDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'fabricCharges', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByGarmentType() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentType', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByGarmentTypeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'garmentType', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy> thenById() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy> thenByIdDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'id', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByIsDeletedDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isDeleted', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByIsUrgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUrgent', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByIsUrgentDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'isUrgent', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByOrderToken() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderToken', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByOrderTokenDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'orderToken', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy> thenByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByStatusDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'status', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByStitchingRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stitchingRate', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByStitchingRateDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'stitchingRate', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByTargetDeadlineDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'targetDeadline', Sort.desc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByUrgentSurcharge() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentSurcharge', Sort.asc);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QAfterSortBy>
      thenByUrgentSurchargeDesc() {
    return QueryBuilder.apply(this, (query) {
      return query.addSortBy(r'urgentSurcharge', Sort.desc);
    });
  }
}

extension OrderCollectionQueryWhereDistinct
    on QueryBuilder<OrderCollection, OrderCollection, QDistinct> {
  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByAdvancePaid() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'advancePaid');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByBalanceDue() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'balanceDue');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByBookingDate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'bookingDate');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByCustomerId() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerId');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByCustomerName({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerName', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByCustomerPhone({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'customerPhone',
          caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByDeletedAt() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'deletedAt');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByFabricCharges() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'fabricCharges');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByGarmentType({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'garmentType', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByIsDeleted() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isDeleted');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByIsUrgent() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'isUrgent');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByOrderToken({bool caseSensitive = true}) {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'orderToken', caseSensitive: caseSensitive);
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct> distinctByStatus() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'status');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByStitchingRate() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'stitchingRate');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByTargetDeadline() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'targetDeadline');
    });
  }

  QueryBuilder<OrderCollection, OrderCollection, QDistinct>
      distinctByUrgentSurcharge() {
    return QueryBuilder.apply(this, (query) {
      return query.addDistinctBy(r'urgentSurcharge');
    });
  }
}

extension OrderCollectionQueryProperty
    on QueryBuilder<OrderCollection, OrderCollection, QQueryProperty> {
  QueryBuilder<OrderCollection, int, QQueryOperations> idProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'id');
    });
  }

  QueryBuilder<OrderCollection, double, QQueryOperations>
      advancePaidProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'advancePaid');
    });
  }

  QueryBuilder<OrderCollection, double, QQueryOperations> balanceDueProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'balanceDue');
    });
  }

  QueryBuilder<OrderCollection, DateTime, QQueryOperations>
      bookingDateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'bookingDate');
    });
  }

  QueryBuilder<OrderCollection, int, QQueryOperations> customerIdProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerId');
    });
  }

  QueryBuilder<OrderCollection, String, QQueryOperations>
      customerNameProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerName');
    });
  }

  QueryBuilder<OrderCollection, String, QQueryOperations>
      customerPhoneProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'customerPhone');
    });
  }

  QueryBuilder<OrderCollection, DateTime?, QQueryOperations>
      deletedAtProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'deletedAt');
    });
  }

  QueryBuilder<OrderCollection, double, QQueryOperations>
      fabricChargesProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'fabricCharges');
    });
  }

  QueryBuilder<OrderCollection, String, QQueryOperations>
      garmentTypeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'garmentType');
    });
  }

  QueryBuilder<OrderCollection, bool, QQueryOperations> isDeletedProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isDeleted');
    });
  }

  QueryBuilder<OrderCollection, bool, QQueryOperations> isUrgentProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'isUrgent');
    });
  }

  QueryBuilder<OrderCollection, String, QQueryOperations> orderTokenProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'orderToken');
    });
  }

  QueryBuilder<OrderCollection, int, QQueryOperations> statusProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'status');
    });
  }

  QueryBuilder<OrderCollection, double, QQueryOperations>
      stitchingRateProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'stitchingRate');
    });
  }

  QueryBuilder<OrderCollection, DateTime, QQueryOperations>
      targetDeadlineProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'targetDeadline');
    });
  }

  QueryBuilder<OrderCollection, double, QQueryOperations>
      urgentSurchargeProperty() {
    return QueryBuilder.apply(this, (query) {
      return query.addPropertyName(r'urgentSurcharge');
    });
  }
}
