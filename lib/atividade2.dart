// ignore_for_file: avoid_print
import 'dart:async';

class ErroDeUsuario implements Exception {
  const ErroDeUsuario();

  @override
  String toString() => 'Dados do usuário não encontrados.';
}

Future<String> fetchNewUsername() => Future.delayed(
      const Duration(milliseconds: 500),
      () => throw const ErroDeUsuario(),
    );

Future<String> deleteEmailFromServer() => Future.delayed(
      const Duration(milliseconds: 500),
      () => throw const ErroDeUsuario(),
    );

Future<String> changeUsername() async {
  try {
    final result = await fetchNewUsername();
    return result;
  } catch (err) {
    return err.toString();
  }
}

Future<String> deleteEmail() async {
  try {
    final result = await deleteEmailFromServer();
    return result;
  } catch (err) {
    return err.toString();
  }
}

Future<void> main() async {
  print(await changeUsername());
  print(await deleteEmail());
}
