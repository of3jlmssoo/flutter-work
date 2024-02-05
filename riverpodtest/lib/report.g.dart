// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportImpl _$$ReportImplFromJson(Map<String, dynamic> json) => _$ReportImpl(
      userID: json['userID'] as String,
      reportID: json['reportID'] as String,
      name: json['name'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      col1: json['col1'] as String,
      totalPrice: json['totalPrice'] as int,
      totalPriceStr: json['totalPriceStr'] as String?,
      status: $enumDecode(_$StatusEnumMap, json['status']),
    );

Map<String, dynamic> _$$ReportImplToJson(_$ReportImpl instance) =>
    <String, dynamic>{
      'userID': instance.userID,
      'reportID': instance.reportID,
      'name': instance.name,
      'createdDate': instance.createdDate.toIso8601String(),
      'col1': instance.col1,
      'totalPrice': instance.totalPrice,
      'totalPriceStr': instance.totalPriceStr,
      'status': _$StatusEnumMap[instance.status]!,
    };

const _$StatusEnumMap = {
  Status.making: 'making',
  Status.submitted: 'submitted',
  Status.other: 'other',
};
