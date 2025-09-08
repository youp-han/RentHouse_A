// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'bill_template.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

BillTemplate _$BillTemplateFromJson(Map<String, dynamic> json) {
  return _BillTemplate.fromJson(json);
}

/// @nodoc
mixin _$BillTemplate {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get category => throw _privateConstructorUsedError;
  int get amount => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;

  /// Serializes this BillTemplate to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of BillTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $BillTemplateCopyWith<BillTemplate> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BillTemplateCopyWith<$Res> {
  factory $BillTemplateCopyWith(
    BillTemplate value,
    $Res Function(BillTemplate) then,
  ) = _$BillTemplateCopyWithImpl<$Res, BillTemplate>;
  @useResult
  $Res call({
    String id,
    String name,
    String category,
    int amount,
    String? description,
  });
}

/// @nodoc
class _$BillTemplateCopyWithImpl<$Res, $Val extends BillTemplate>
    implements $BillTemplateCopyWith<$Res> {
  _$BillTemplateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of BillTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? amount = null,
    Object? description = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            category: null == category
                ? _value.category
                : category // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as int,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$BillTemplateImplCopyWith<$Res>
    implements $BillTemplateCopyWith<$Res> {
  factory _$$BillTemplateImplCopyWith(
    _$BillTemplateImpl value,
    $Res Function(_$BillTemplateImpl) then,
  ) = __$$BillTemplateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    String category,
    int amount,
    String? description,
  });
}

/// @nodoc
class __$$BillTemplateImplCopyWithImpl<$Res>
    extends _$BillTemplateCopyWithImpl<$Res, _$BillTemplateImpl>
    implements _$$BillTemplateImplCopyWith<$Res> {
  __$$BillTemplateImplCopyWithImpl(
    _$BillTemplateImpl _value,
    $Res Function(_$BillTemplateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of BillTemplate
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = null,
    Object? amount = null,
    Object? description = freezed,
  }) {
    return _then(
      _$BillTemplateImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        category: null == category
            ? _value.category
            : category // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as int,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$BillTemplateImpl implements _BillTemplate {
  const _$BillTemplateImpl({
    required this.id,
    required this.name,
    required this.category,
    required this.amount,
    this.description,
  });

  factory _$BillTemplateImpl.fromJson(Map<String, dynamic> json) =>
      _$$BillTemplateImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String category;
  @override
  final int amount;
  @override
  final String? description;

  @override
  String toString() {
    return 'BillTemplate(id: $id, name: $name, category: $category, amount: $amount, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BillTemplateImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, amount, description);

  /// Create a copy of BillTemplate
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$BillTemplateImplCopyWith<_$BillTemplateImpl> get copyWith =>
      __$$BillTemplateImplCopyWithImpl<_$BillTemplateImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BillTemplateImplToJson(this);
  }
}

abstract class _BillTemplate implements BillTemplate {
  const factory _BillTemplate({
    required final String id,
    required final String name,
    required final String category,
    required final int amount,
    final String? description,
  }) = _$BillTemplateImpl;

  factory _BillTemplate.fromJson(Map<String, dynamic> json) =
      _$BillTemplateImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get category;
  @override
  int get amount;
  @override
  String? get description;

  /// Create a copy of BillTemplate
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$BillTemplateImplCopyWith<_$BillTemplateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
