// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  double get price =>
      throw _privateConstructorUsedError; // selling price per unit
  double get buyPrice => throw _privateConstructorUsedError; // cost per unit
  int get quantity => throw _privateConstructorUsedError; // total stock
  int get soldQuantity =>
      throw _privateConstructorUsedError; // units sold so far
  bool get isSaled => throw _privateConstructorUsedError; // true if fully sold
  Category get type => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get saledAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    double buyPrice,
    int quantity,
    int soldQuantity,
    bool isSaled,
    Category type,
    DateTime createdAt,
    DateTime? saledAt,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? buyPrice = null,
    Object? quantity = null,
    Object? soldQuantity = null,
    Object? isSaled = null,
    Object? type = null,
    Object? createdAt = null,
    Object? saledAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id:
                null == id
                    ? _value.id
                    : id // ignore: cast_nullable_to_non_nullable
                        as String,
            name:
                null == name
                    ? _value.name
                    : name // ignore: cast_nullable_to_non_nullable
                        as String,
            price:
                null == price
                    ? _value.price
                    : price // ignore: cast_nullable_to_non_nullable
                        as double,
            buyPrice:
                null == buyPrice
                    ? _value.buyPrice
                    : buyPrice // ignore: cast_nullable_to_non_nullable
                        as double,
            quantity:
                null == quantity
                    ? _value.quantity
                    : quantity // ignore: cast_nullable_to_non_nullable
                        as int,
            soldQuantity:
                null == soldQuantity
                    ? _value.soldQuantity
                    : soldQuantity // ignore: cast_nullable_to_non_nullable
                        as int,
            isSaled:
                null == isSaled
                    ? _value.isSaled
                    : isSaled // ignore: cast_nullable_to_non_nullable
                        as bool,
            type:
                null == type
                    ? _value.type
                    : type // ignore: cast_nullable_to_non_nullable
                        as Category,
            createdAt:
                null == createdAt
                    ? _value.createdAt
                    : createdAt // ignore: cast_nullable_to_non_nullable
                        as DateTime,
            saledAt:
                freezed == saledAt
                    ? _value.saledAt
                    : saledAt // ignore: cast_nullable_to_non_nullable
                        as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String name,
    double price,
    double buyPrice,
    int quantity,
    int soldQuantity,
    bool isSaled,
    Category type,
    DateTime createdAt,
    DateTime? saledAt,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? price = null,
    Object? buyPrice = null,
    Object? quantity = null,
    Object? soldQuantity = null,
    Object? isSaled = null,
    Object? type = null,
    Object? createdAt = null,
    Object? saledAt = freezed,
  }) {
    return _then(
      _$ProductImpl(
        id:
            null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                    as String,
        name:
            null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                    as String,
        price:
            null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                    as double,
        buyPrice:
            null == buyPrice
                ? _value.buyPrice
                : buyPrice // ignore: cast_nullable_to_non_nullable
                    as double,
        quantity:
            null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                    as int,
        soldQuantity:
            null == soldQuantity
                ? _value.soldQuantity
                : soldQuantity // ignore: cast_nullable_to_non_nullable
                    as int,
        isSaled:
            null == isSaled
                ? _value.isSaled
                : isSaled // ignore: cast_nullable_to_non_nullable
                    as bool,
        type:
            null == type
                ? _value.type
                : type // ignore: cast_nullable_to_non_nullable
                    as Category,
        createdAt:
            null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                    as DateTime,
        saledAt:
            freezed == saledAt
                ? _value.saledAt
                : saledAt // ignore: cast_nullable_to_non_nullable
                    as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.id,
    required this.name,
    required this.price,
    required this.buyPrice,
    required this.quantity,
    required this.soldQuantity,
    required this.isSaled,
    required this.type,
    required this.createdAt,
    this.saledAt,
  });

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final double price;
  // selling price per unit
  @override
  final double buyPrice;
  // cost per unit
  @override
  final int quantity;
  // total stock
  @override
  final int soldQuantity;
  // units sold so far
  @override
  final bool isSaled;
  // true if fully sold
  @override
  final Category type;
  @override
  final DateTime createdAt;
  @override
  final DateTime? saledAt;

  @override
  String toString() {
    return 'Product(id: $id, name: $name, price: $price, buyPrice: $buyPrice, quantity: $quantity, soldQuantity: $soldQuantity, isSaled: $isSaled, type: $type, createdAt: $createdAt, saledAt: $saledAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.buyPrice, buyPrice) ||
                other.buyPrice == buyPrice) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.soldQuantity, soldQuantity) ||
                other.soldQuantity == soldQuantity) &&
            (identical(other.isSaled, isSaled) || other.isSaled == isSaled) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.saledAt, saledAt) || other.saledAt == saledAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    name,
    price,
    buyPrice,
    quantity,
    soldQuantity,
    isSaled,
    type,
    createdAt,
    saledAt,
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String id,
    required final String name,
    required final double price,
    required final double buyPrice,
    required final int quantity,
    required final int soldQuantity,
    required final bool isSaled,
    required final Category type,
    required final DateTime createdAt,
    final DateTime? saledAt,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  double get price; // selling price per unit
  @override
  double get buyPrice; // cost per unit
  @override
  int get quantity; // total stock
  @override
  int get soldQuantity; // units sold so far
  @override
  bool get isSaled; // true if fully sold
  @override
  Category get type;
  @override
  DateTime get createdAt;
  @override
  DateTime? get saledAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
