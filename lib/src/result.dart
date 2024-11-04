import 'package:meta/meta.dart';

/// Result<E, T> is used for returning and propagating errors.
/// It is a sealed class with the variants, Success(T), representing success
/// and containing a value, and Failure(E), representing error and containing
/// an optional error value.
///
/// Inspired by https://doc.rust-lang.org/std/result/
sealed class Result<E, T> {
  const Result();

  T operator ~() {
    switch (this) {
      case Success(value: final value):
        return value;
      case Failure(value: final failure):
        // ignore: only_throw_errors
        throw Failure<E, T>(failure);
    }
  }
}

/// Contains the success value.
@immutable
class Success<E, T> extends Result<E, T> {
  const Success(this.value);

  static Success<E, void> empty<E>() => Success<E, void>(null);

  final T value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    if (other case Success<E, T>(:final value)) return this.value == value;
    return false;
  }
}

/// Optionally contains the error value.
@immutable
class Failure<E, T> extends Result<E, T> {
  const Failure(this.value);

  static Failure<void, T> empty<T>() => Failure<void, T>(null);

  final E value;

  @override
  int get hashCode => value.hashCode;

  @override
  bool operator ==(Object other) {
    if (other case Failure<E, T>(:final value)) return this.value == value;
    return false;
  }
}

/// An attempt to replicate Rusts question mark operator
/// https://doc.rust-lang.org/std/result/#the-question-mark-operator-

Result<E, T> bailOnFail<E, T>(Result<E, T> Function() f) {
  try {
    return f();
  } on Failure<E, T> catch (failure) {
    return failure;
  }
}

Future<Result<E, T>> bailOnFailAsync<E, T>(
  Future<Result<E, T>> Function() f,
) async {
  try {
    return await f();
  } on Failure<E, T> catch (failure) {
    return failure;
  }
}
