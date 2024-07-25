import 'package:meta/meta.dart';

/// Option represents an optional value: every Option is either Some and
/// contains a value, or None, and does not.
///
/// Inspired by https://doc.rust-lang.org/std/option/
sealed class Option<T> {}

/// Some value of type T.
@immutable
class Some<T> implements Option<T> {
  const Some(this.value);

  final T value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    if (other case Some<T>(:final value)) return this.value == value;
    return false;
  }
}

/// No value.
@immutable
class None<T> implements Option<T> {
  const None();

  @override
  int get hashCode => T.hashCode;

  @override
  bool operator ==(Object other) => other is None<T>;
}
