import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Widget Simple Tests', () {
    testWidgets('Deve criar widget Text básico', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: Scaffold(body: Text('Hello World'))),
      );

      // Assert
      expect(find.text('Hello World'), findsOneWidget);
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(MaterialApp), findsOneWidget);
    });

    testWidgets('Deve criar formulário básico com campos', (
      WidgetTester tester,
    ) async {
      // Arrange
      final nomeController = TextEditingController();

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              child: Column(
                children: [
                  const Text('Cadastro Teste'),
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(
                      labelText: 'Nome',
                      hintText: 'Digite seu nome',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(onPressed: () {}, child: const Text('Salvar')),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Cadastro Teste'), findsOneWidget);
      expect(find.text('Nome'), findsOneWidget);
      expect(find.text('Salvar'), findsOneWidget);
      expect(find.byType(TextFormField), findsOneWidget);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets('Deve validar campo obrigatório', (WidgetTester tester) async {
      // Arrange
      final formKey = GlobalKey<FormState>();
      final nomeController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Campo obrigatório';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      formKey.currentState!.validate();
                    },
                    child: const Text('Validar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Act - Tentar validar sem preencher
      await tester.tap(find.text('Validar'));
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Campo obrigatório'), findsOneWidget);
    });

    testWidgets('Deve permitir preencher campo de texto', (
      WidgetTester tester,
    ) async {
      // Arrange
      final nomeController = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: TextFormField(
              controller: nomeController,
              decoration: const InputDecoration(hintText: 'Digite seu nome'),
            ),
          ),
        ),
      );

      // Act
      await tester.enterText(find.byType(TextFormField), 'João Silva');
      await tester.pump();

      // Assert
      expect(find.text('João Silva'), findsOneWidget);
      expect(nomeController.text, equals('João Silva'));
    });

    testWidgets('Deve exibir ícones e botões', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            appBar: AppBar(
              title: const Text('Teste App'),
              leading: const Icon(Icons.menu),
            ),
            body: const Column(
              children: [
                Icon(Icons.person),
                Icon(Icons.business),
                Text('Fornecedores'),
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: null,
              child: Icon(Icons.add),
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Teste App'), findsOneWidget);
      expect(find.text('Fornecedores'), findsOneWidget);
      expect(find.byIcon(Icons.menu), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
      expect(find.byIcon(Icons.business), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsOneWidget);
    });

    testWidgets('Deve funcionar com ListView', (WidgetTester tester) async {
      // Arrange
      final items = ['Item 1', 'Item 2', 'Item 3'];

      // Act
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(items[index]),
                  leading: const Icon(Icons.business),
                );
              },
            ),
          ),
        ),
      );

      // Assert
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
      expect(find.text('Item 3'), findsOneWidget);
      expect(find.byIcon(Icons.business), findsNWidgets(3));
      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(3));
    });

    testWidgets('Deve testar scroll em lista', (WidgetTester tester) async {
      // Arrange
      final items = List.generate(20, (index) => 'Fornecedor ${index + 1}');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return ListTile(title: Text(items[index]));
              },
            ),
          ),
        ),
      );

      // Act - Verificar se existem os primeiros itens
      expect(find.text('Fornecedor 1'), findsOneWidget);
      expect(
        find.text('Fornecedor 20'),
        findsNothing,
      ); // Não visível inicialmente

      // Fazer scroll para baixo
      await tester.drag(find.byType(ListView), const Offset(0, -2000));
      await tester.pumpAndSettle();

      // Assert - Agora deve ver itens do final da lista
      expect(find.text('Fornecedor 20'), findsOneWidget);
    });
  });
}
