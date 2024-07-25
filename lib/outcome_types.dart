/// This package provides two utility classes, `Result` and `Option`,
/// inspired by Rust's [`Result`](https://doc.rust-lang.org/std/result/)
/// and [`Option`](https://doc.rust-lang.org/std/option/) types. These classes
/// are designed to help with error handling and representing optional values
/// in a more expressive and type-safe manner.
///
/// The `Result` class is used for returning and propagating errors. It is a sealed class
/// with two variants:
/// - `Success<T>`: Represents a successful operation and contains a value of type `T`.
/// - `Failure<E>`: Represents a failed operation and contains an error value of type `E`.
///
/// The `Option` class represents an optional value. It is a sealed class with two variants:
/// - `Some<T>`: Represents an optional value of type `T`.
/// - `None<T>`: Represents the absence of a value.
///
/// ## Usage Option:
///
/// ```dart
/// import 'package:result_option/result_option.dart';
///
/// extension FirstWhereOrNone<T> on Iterable<T> {
///   Option<T> firstWhereOrNone(bool Function(T element) test) {
///     for (final element in this) {
///       if (test(element)) return Some(element);
///     }
///     return const None();
///   }
/// }

/// void main() {
///   final names = ['Max', 'George', 'Tim'];
///   switch (names.firstWhereOrNone((name) => name.length == 3)) {
///     case Some(value: final name):
///       print('name with three letters: $name');
///     case None():
///       print('didn\'t find a name with three letters');
///   }
/// }
///
/// ```
///
/// ## Usage Result
///
/// ```dart
/// enum SignInFailure {
///   invalidCredentials,
///   unknown,
/// }
///
/// Future<Result<SignInFailure, UserInfo>> signIn(
///   String email,
///   String pass,
/// ) async {
///   try {
///     final userInfo = await loginGateway.signIn(email, pass);
///     return Success(userInfo);
///   } catch (exception) {
/// 	if (exception.message == 'invalid_credentials') {
///       return const Failure(SignInFailure.invalidCredentials);
///     }
///     return const Failure(SignInFailure.unknown);
///   }
/// }
///
/// Future<void> someFunction() async {
///   switch (await signInUsingLoginGateway('test@test.test', '1234')) {
///     case Success(value: final userInfo):
///       print(userInfo);
///     case Failure(value: final failure):
///       switch (failure) {
///         case SignInFailure.invalidCredentials:
///           print('invalid credentials');
///         case SignInFailure.unknown:
///           print('unknown failure');
///       }
///   }
/// }
/// ```
library outcome_types;

export 'src/option.dart';
export 'src/result.dart';
