import 'package:pattoomobile/models/agent.dart';
import 'package:pattoomobile/models/dataPointAgent.dart';
import 'package:pattoomobile/models/timestamp.dart';
import 'package:pattoomobile/util/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Login Validator Test', () {
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

    test('Empty Source Test', () {
      var result = FieldValidator.validateSourceInput('');
      expect(result, 'Enter Source!');
    });

    test('Valid Source Test', () {
      var result = FieldValidator.validateSourceInput('abc');
      expect(result, null);
    });
  });

  group('Agent Test', () {
    test('Test Agent Attributes', () {
      Agent result = new Agent("4", "SomeProgram");
      expect(result.id, "4");
      expect(result.program, "SomeProgram");
      expect(result.target_agents is List && result.target_agents.length == 0,
          true);
    });

    test('Test Adding Datapoints to Agent', () {
      Agent result = new Agent("4", "SomeProgram");
      DataPointAgent agent = new DataPointAgent("1", "2");
      result.addTarget(agent);
      expect(
          result.target_agents[0] == agent && result.target_agents.length == 1,
          true);
    });

    test('Test Agent String Form', () {
      Agent result = new Agent("4", "SomeProgram");
      expect(result.toString(), 'Agent(id: 4, program: SomeProgram)');
    });

    test('Test Agent MAP form', () {
      Agent result = new Agent("4", "SomeProgram");
      Map map = {
        'id': "4",
        'program': "SomeProgram",
      };
      expect(result.toMap(), map);
    });
  });

  group('Datapoint Agents Test', () {
    test('Test Datapoint Agent Attributes', () {
      DataPointAgent result = new DataPointAgent('1', '2');
      expect(result.agent_id, "1");
      expect(result.datapoint_id, "2");
      expect(
          result.agent_struct is Map && result.agent_struct.length == 0, true);
    });
    test('Datapoint Agent datapoints', () {
      DataPointAgent result = new DataPointAgent('1', '2');
      result.agent_struct.putIfAbsent("key", () => "value");
      expect(
          result.agent_struct is Map && result.agent_struct.length == 1, true);
      expect(result.agent_struct["key"], "value");
    });
  });

  group('Timestamp Test',(){
    test('Test Timestamp attributes ',(){
        TimeStamp result = new TimeStamp(value: 1, timestamp: 1593134112007);
        expect(result.value,1);
        expect(result.timestamp,1593134112007);
    });

    test('Test Timestamp conversion from EPOCH to YY/MM/DD/HH/MIN/SS',(){
        TimeStamp result = new TimeStamp(value: 1, timestamp: 1593134112007);
        expect(result.Timestamp,DateTime.parse("2020-06-25 20:15:12.000007"));
    });
  });
}
