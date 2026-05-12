// ignore_for_file: avoid_print
import 'dart:async';

const _halfSecond = Duration(milliseconds: 500);

const role = 'administrador';
Future<String> fetchRole() => Future.delayed(_halfSecond, () => role);

const numberOfLoginAttempts = 12;
Future<int> fetchLoginAmount() =>
    Future.delayed(_halfSecond, () => numberOfLoginAttempts);

Future<String> reportUserRole() async {
  final userRole = await fetchRole();
  return 'Papel do usuário: $userRole';
}

Future<String> reportLogins() async {
  final logins = await fetchLoginAmount();
  return 'Total de logins: $logins';
}

Future<void> main() async {
  print(await reportUserRole());
  print(await reportLogins());
}
