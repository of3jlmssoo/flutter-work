// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'report.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Report _$ReportFromJson(Map<String, dynamic> json) {
  return _Report.fromJson(json);
}

/// @nodoc
mixin _$Report {
  String get userID => throw _privateConstructorUsedError;
  String get reportID => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  DateTime get createdDate =>
      throw _privateConstructorUsedError; // required String Expence,
  String get col1 => throw _privateConstructorUsedError;
  int get totalPrice => throw _privateConstructorUsedError;
  String? get totalPriceStr => throw _privateConstructorUsedError;
  Status get status => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ReportCopyWith<Report> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportCopyWith<$Res> {
  factory $ReportCopyWith(Report value, $Res Function(Report) then) =
      _$ReportCopyWithImpl<$Res, Report>;
  @useResult
  $Res call(
      {String userID,
      String reportID,
      String name,
      DateTime createdDate,
      String col1,
      int totalPrice,
      String? totalPriceStr,
      Status status});
}

/// @nodoc
class _$ReportCopyWithImpl<$Res, $Val extends Report>
    implements $ReportCopyWith<$Res> {
  _$ReportCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = null,
    Object? reportID = null,
    Object? name = null,
    Object? createdDate = null,
    Object? col1 = null,
    Object? totalPrice = null,
    Object? totalPriceStr = freezed,
    Object? status = null,
  }) {
    return _then(_value.copyWith(
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      reportID: null == reportID
          ? _value.reportID
          : reportID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdDate: null == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      col1: null == col1
          ? _value.col1
          : col1 // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      totalPriceStr: freezed == totalPriceStr
          ? _value.totalPriceStr
          : totalPriceStr // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReportImplCopyWith<$Res> implements $ReportCopyWith<$Res> {
  factory _$$ReportImplCopyWith(
          _$ReportImpl value, $Res Function(_$ReportImpl) then) =
      __$$ReportImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String userID,
      String reportID,
      String name,
      DateTime createdDate,
      String col1,
      int totalPrice,
      String? totalPriceStr,
      Status status});
}

/// @nodoc
class __$$ReportImplCopyWithImpl<$Res>
    extends _$ReportCopyWithImpl<$Res, _$ReportImpl>
    implements _$$ReportImplCopyWith<$Res> {
  __$$ReportImplCopyWithImpl(
      _$ReportImpl _value, $Res Function(_$ReportImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? userID = null,
    Object? reportID = null,
    Object? name = null,
    Object? createdDate = null,
    Object? col1 = null,
    Object? totalPrice = null,
    Object? totalPriceStr = freezed,
    Object? status = null,
  }) {
    return _then(_$ReportImpl(
      userID: null == userID
          ? _value.userID
          : userID // ignore: cast_nullable_to_non_nullable
              as String,
      reportID: null == reportID
          ? _value.reportID
          : reportID // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      createdDate: null == createdDate
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      col1: null == col1
          ? _value.col1
          : col1 // ignore: cast_nullable_to_non_nullable
              as String,
      totalPrice: null == totalPrice
          ? _value.totalPrice
          : totalPrice // ignore: cast_nullable_to_non_nullable
              as int,
      totalPriceStr: freezed == totalPriceStr
          ? _value.totalPriceStr
          : totalPriceStr // ignore: cast_nullable_to_non_nullable
              as String?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as Status,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportImpl implements _Report {
  _$ReportImpl(
      {required this.userID,
      required this.reportID,
      required this.name,
      required this.createdDate,
      required this.col1,
      required this.totalPrice,
      this.totalPriceStr,
      required this.status});

  factory _$ReportImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportImplFromJson(json);

  @override
  final String userID;
  @override
  final String reportID;
  @override
  final String name;
  @override
  final DateTime createdDate;
// required String Expence,
  @override
  final String col1;
  @override
  final int totalPrice;
  @override
  final String? totalPriceStr;
  @override
  final Status status;

  @override
  String toString() {
    return 'Report(userID: $userID, reportID: $reportID, name: $name, createdDate: $createdDate, col1: $col1, totalPrice: $totalPrice, totalPriceStr: $totalPriceStr, status: $status)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportImpl &&
            (identical(other.userID, userID) || other.userID == userID) &&
            (identical(other.reportID, reportID) ||
                other.reportID == reportID) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.createdDate, createdDate) ||
                other.createdDate == createdDate) &&
            (identical(other.col1, col1) || other.col1 == col1) &&
            (identical(other.totalPrice, totalPrice) ||
                other.totalPrice == totalPrice) &&
            (identical(other.totalPriceStr, totalPriceStr) ||
                other.totalPriceStr == totalPriceStr) &&
            (identical(other.status, status) || other.status == status));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, userID, reportID, name,
      createdDate, col1, totalPrice, totalPriceStr, status);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      __$$ReportImplCopyWithImpl<_$ReportImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportImplToJson(
      this,
    );
  }
}

abstract class _Report implements Report {
  factory _Report(
      {required final String userID,
      required final String reportID,
      required final String name,
      required final DateTime createdDate,
      required final String col1,
      required final int totalPrice,
      final String? totalPriceStr,
      required final Status status}) = _$ReportImpl;

  factory _Report.fromJson(Map<String, dynamic> json) = _$ReportImpl.fromJson;

  @override
  String get userID;
  @override
  String get reportID;
  @override
  String get name;
  @override
  DateTime get createdDate;
  @override // required String Expence,
  String get col1;
  @override
  int get totalPrice;
  @override
  String? get totalPriceStr;
  @override
  Status get status;
  @override
  @JsonKey(ignore: true)
  _$$ReportImplCopyWith<_$ReportImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
