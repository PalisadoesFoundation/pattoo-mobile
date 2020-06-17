import 'package:pattoomobile/util/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Empty Email Test', () {
    var result = FieldValidator.validateEmail('');
    expect(result, 'Enter Email!');
  });

  test('Invalid Email Test', () {
    var result = FieldValidator.validateEmail('ajay');
    expect(result, 'Enter Valid Email!');
  });

  test('Valid Email Test', () {
    var result = FieldValidator.validateEmail('test@gmail.com');
    expect(result, null);
  });

  test('Empty Password Test', () {
    var result = FieldValidator.validatePassword('');
    expect(result, 'Enter Password!');
  });

  test('Invalid Password Test', () {
    var result = FieldValidator.validatePassword('123');
    expect(result, 'Password must be more than 6 characters');
  });

  test('Valid Password Test', () {
    var result = FieldValidator.validatePassword('test12345');
    expect(result, null);
  });

  test('Invalid Email Test', () {
    var result = FieldValidator.validateEmail('ajay');
    expect(result, 'Enter Valid Email!');
  });

  test('Empty Source Test', ()
  {
    var result = FieldValidator.validateSourceInput('');
    expect(result, 'Enter Source!');
  });

  test('Valid Source Test', ()
  {
    var result = FieldValidator.validateSourceInput('abc');
    expect(result, null);
  });

}