import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pedeai/view/cadastro/fornecedor/cadastroFornecedor.dart';

void main() {
  group('CadastroFornecedor Widget Tests', () {
    testWidgets('Deve exibir título correto para novo cadastro', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage()),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Cadastrar Fornecedor'), findsOneWidget);
    });

    testWidgets('Deve exibir título correto para edição', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage(fornecedorId: 1)),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Editar Fornecedor'), findsOneWidget);
    });

    testWidgets('Deve exibir todos os campos obrigatórios', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage()),
      );
      await tester.pumpAndSettle();

      // Assert - Verificar se os campos principais estão presentes
      expect(find.text('Razão Social'), findsOneWidget);
      expect(find.text('Nome Fantasia'), findsOneWidget);
      expect(find.text('CNPJ'), findsOneWidget);
      expect(find.text('Inscrição Estadual'), findsOneWidget);
      expect(find.text('Telefone'), findsOneWidget);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('CEP'), findsOneWidget);
      expect(find.text('Logradouro'), findsOneWidget);
      expect(find.text('Número'), findsOneWidget);
      expect(find.text('Bairro'), findsOneWidget);
      expect(find.text('Cidade'), findsOneWidget);
      expect(find.text('UF'), findsOneWidget);
    });

    testWidgets('Deve exibir botão de salvar', (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage()),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.text('Cadastrar Fornecedor'), findsWidgets);
      expect(find.byType(ElevatedButton), findsOneWidget);
    });

    testWidgets(
      'Deve mostrar erro de validação quando campos obrigatórios estão vazios',
      (WidgetTester tester) async {
        // Arrange
        await tester.pumpWidget(
          const MaterialApp(home: CadastroFornecedorPage()),
        );
        await tester.pumpAndSettle();

        // Act - Tentar salvar sem preencher campos obrigatórios
        final saveButton = find.byType(ElevatedButton);
        await tester.tap(saveButton);
        await tester.pumpAndSettle();

        // Assert - Verificar se mensagens de erro aparecem
        expect(find.text('Obrigatório'), findsWidgets);
      },
    );

    testWidgets('Deve permitir preencher campo de razão social', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage()),
      );
      await tester.pumpAndSettle();

      // Act
      final razaoSocialField = find.widgetWithText(
        TextFormField,
        'Digite a razão social do fornecedor',
      );
      await tester.enterText(razaoSocialField, 'Empresa Teste Ltda');
      await tester.pump();

      // Assert
      expect(find.text('Empresa Teste Ltda'), findsOneWidget);
    });

    testWidgets('Deve permitir preencher campo de CNPJ', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage()),
      );
      await tester.pumpAndSettle();

      // Act
      final cnpjField = find.widgetWithText(TextFormField, 'Digite o CNPJ');
      await tester.enterText(cnpjField, '12.345.678/0001-90');
      await tester.pump();

      // Assert
      expect(find.text('12.345.678/0001-90'), findsOneWidget);
    });

    testWidgets('Deve exibir loading quando carregando dados', (
      WidgetTester tester,
    ) async {
      // Arrange & Act
      await tester.pumpWidget(
        const MaterialApp(home: CadastroFornecedorPage(fornecedorId: 1)),
      );

      // Assert - Deve mostrar loading inicialmente
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
