# Exercícios Flutter – BRADEMO

## Como usar
Cada arquivo é um app Flutter independente com seu próprio `main()`.
Copie o conteúdo de cada arquivo para o `lib/main.dart` do seu projeto
e execute com `flutter run`.

---

## Exercício 1 – GridView (`ex01_gridview.dart`)
**Widgets principais:** `GridView.builder`, `SliverGridDelegateWithFixedCrossAxisCount`,
`Stack`, `Positioned`, `Image.network`

- Grid 2 colunas com 6 imagens via `Image.network(url)`
- Caption sobreposto com degradê usando `Stack` + `Positioned`
- Tratamento de loading e erro na imagem

---

## Exercício 2 – Responsividade (`ex02_responsive.dart`)
**Widgets principais:** `OrientationBuilder`, `Column`, `Row`, `ListView`,
`ElevatedButton`, `VerticalDivider`

- **Retrato:** título + 2 botões em `Row` → lista abaixo
- **Paisagem:** lado esquerdo com título + botões empilhados, `VerticalDivider`, lado direito com lista

---

## Exercício 3 – Restrições de Layout (`ex03_constraints.dart`)
**Conceito:** *Constraints go down. Sizes go up. Parent sets position.*

10 exemplos comentados demonstrando:
- Constraints tight vs loose
- `Center`, `Align`, `Expanded`, `Row`
- `UnconstrainedBox`, `OverflowBox`, `FittedBox`, `SizedBox.expand`

Referência: https://docs.flutter.dev/ui/layout/constraints

---

## Exercício 4 – Formulário (`ex04_form.dart`)
**Widgets principais:** `Form`, `TextFormField`, `showDatePicker`,
`ScaffoldMessenger`, `SnackBar`

- Campos: Nome, Telefone, Data de Nascimento (DatePicker)
- Ícones em `Row` junto a cada campo
- `SnackBar` com os dados ao pressionar Submit
- Validação básica dos campos

---

## Exercício 5 – BottomAppBar com FAB (`ex05_bottom_fab.dart`)
**Widgets principais:** `BottomAppBar`, `CircularNotchedRectangle`,
`FloatingActionButton`, `AnimationController`, `ScaleTransition`

- FAB centralizado encaixado na `BottomAppBar`
- Ao clicar no FAB, mini-FABs de speed-dial aparecem com animação
- FAB principal gira 45° ao expandir
- 4 tabs na barra inferior (2 de cada lado do FAB)

---

## Exercício 6 – Lista de Tarefas (`ex06_task_list.dart`)
**Widgets principais:** `MaterialApp`, `Scaffold`, `ListView.builder`, `Card`,
`Checkbox`, `ElevatedButton`, `FloatingActionButton`, `AlertDialog`

- Lista de tarefas com `Card` amarelo e `CheckBox`
- Tarefas concluídas ficam com texto tachado
- Botão "View Completed Tasks" alterna visibilidade
- FAB abre `AlertDialog` com mensagem sobre o app
- Contador de tarefas pendentes no topo
