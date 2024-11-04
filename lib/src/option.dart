import 'package:meta/meta.dart';

/// Option represents an optional value: every Option is either Some and
/// contains a value, or None, and does not.
///
/// Inspired by https://doc.rust-lang.org/std/option/
sealed class Option<T> {
  const Option();

  T operator ~() {
    switch (this) {
      case Some(value: final value):
        return value;
      case None():
        // ignore: only_throw_errors
        throw None<T>();
    }
  }
}

/// Some value of type T.
@immutable
class Some<T> extends Option<T> {
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
class None<T> extends Option<T> {
  const None();

  @override
  int get hashCode => T.hashCode;

  @override
  bool operator ==(Object other) => other is None<T>;
}

/// An attempt to replicate Rusts question mark operator
/// https://doc.rust-lang.org/std/option/#the-question-mark-operator-

Option<T> bailOnNone<T>(Option<T> Function() f) {
  try {
    return f();
  } on None<T> catch (_) {
    return const None();
  }
}

Future<Option<T>> bailOnNoneAsync<T>(Future<Option<T>> Function() f) async {
  try {
    return await f();
  } on None<T> catch (_) {
    return const None();
  }
}
