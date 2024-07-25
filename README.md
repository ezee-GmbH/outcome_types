# Result and Option Package

This package provides two utility classes, `Result` and `Option`, inspired by Rust's [`Result`](https://doc.rust-lang.org/std/result/) and [`Option`](https://doc.rust-lang.org/std/option/) types. These classes are designed to help with error handling and representing optional values in a more expressive and type-safe manner.

## Features

**Result**: A sealed class with two variants:
-  `Success<T>`: Represents a successful operation and contains a value of type `T`.
-  `Failure<E>`: Represents a failed operation and contains an error value of type `E`.

**Option**: A sealed class with two variants:
-  `Some<T>`: Represents an optional value of type `T`.
-  `None<T>`: Represents the absence of a value.


## Motivation

A few words on the motivation for these types.

Result allows you to propagate all possible results of a function through its return value. When you define the return value of a function to be Result<E,T>, where T is the value returned on success and E is the value returned on failure, you explicitely define everything that could go right or wrong as a result of this function call (E is usually going to be either an enum or a sealed class so you can do an exhaustive switch on all possible failures). If you now also make your function a pure function that does not throw (e.g. have a catch all block that returns E), your function signature contains all the information about every possible scenario that needs to be handled. This style of coding is a bliss to write and read because it is very explicit and leaves little room for "forgetting to handle scenario X" or "forgetting to catch exception Y". It may sound a bit confusing but it is actually not, just have a look at the "Usage Result" example and see how we intuitively handle all scenarios in `someFunction()` .

Option is basically just a way to avoid dealing with nullables. There are many reasons why null sucks and I am sure you have already in the past had bad headaches due to nullable values. Option encourages developers to handle both cases (Some and None) explicitly. Explicit handling results in better error checking and more robust code. Additionally, Option integrates seamlessly with functional
programming paradigms. Overall, using Option instead of nullables enhances type safety, reduces the likelihood of runtime errors, and promotes a more disciplined approach to handling optional values.

## Usage Option
```dart
extension FirstWhereOrNone<T> on Iterable<T> {
  Option<T> firstWhereOrNone(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return Some(element);
    }
    return const None();
  }
}

void main() {
  final names = ['Max', 'George', 'Tim'];
  switch (names.firstWhereOrNone((name) => name.length == 3)) {
    case Some(value: final name):
      print('name with three letters: $name');
    case None():
      print('didn\'t find a name with three letters');
  }
}

```

## Usage Result
```dart
enum SignInFailure {
  invalidCredentials,
  unknown,
}

Future<Result<SignInFailure, UserInfo>> signIn(
  String email,
  String pass,
) async {
  try {
    final userInfo = await loginGateway.signIn(email, pass);
    return Success(userInfo);
  } catch (exception) {
	if (exception.message == 'invalid_credentials') {
      return const Failure(SignInFailure.invalidCredentials);
    }
    return const Failure(SignInFailure.unknown);
  }
}

Future<void> someFunction() async {
  switch (await signInUsingLoginGateway('test@test.test', '1234')) {
    case Success(value: final userInfo):
      print(userInfo);
    case Failure(value: final failure):
      switch (failure) {
        case SignInFailure.invalidCredentials:
          print('invalid credentials');
        case SignInFailure.unknown:
          print('unknown failure');
      }
  }
}
```