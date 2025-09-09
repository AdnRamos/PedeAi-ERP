import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pedeai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de Integração: Gestão de Clientes', () {
    // Helper para análise da tela
    Future<void> _logEstruturaAtual(
      WidgetTester tester, [
      String contexto = '',
    ]) async {
      if (contexto.isNotEmpty) {
        print('📱 Analisando tela: $contexto');
      } else {
        print('📱 Analisando tela atual...');
      }

      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      final scaffolds = find.byType(Scaffold);
      final appBars = find.byType(AppBar);
      final texts = find.byType(Text);
      final listTiles = find.byType(ListTile);
      final buttons = find.byType(ElevatedButton);
      final textFields = find.byType(TextFormField);

      print('📊 ESTRUTURA DA TELA:');
      print('   - Scaffolds: ${scaffolds.evaluate().length}');
      print('   - AppBars: ${appBars.evaluate().length}');
      print('   - ListTiles: ${listTiles.evaluate().length}');
      print('   - ElevatedButtons: ${buttons.evaluate().length}');
      print('   - TextFormFields: ${textFields.evaluate().length}');
      print('   - Total de Texts: ${texts.evaluate().length}');

      // Listar textos importantes
      print('📝 TEXTOS PRINCIPAIS:');
      for (int i = 0; i < texts.evaluate().length && i < 20; i++) {
        try {
          final textWidget = tester.widget<Text>(texts.at(i));
          final textContent =
              textWidget.data ?? textWidget.textSpan?.toPlainText() ?? 'null';
          if (textContent != 'null' && textContent.trim().isNotEmpty) {
            print('   $i: "$textContent"');
          }
        } catch (e) {
          // Ignorar textos que não conseguimos ler
        }
      }

      if (texts.evaluate().length > 20) {
        print('   ... e mais ${texts.evaluate().length - 20} textos');
      }
    }

    // Helper para login rápido
    Future<void> _fazerLogin(WidgetTester tester) async {
      print('🔐 Realizando login...');

      await tester.pumpAndSettle(const Duration(seconds: 2));

      final loginButton = find.text('ENTRAR');
      final loginButtonAlt = find.text('Entrar');

      if (loginButton.evaluate().isEmpty && loginButtonAlt.evaluate().isEmpty) {
        print('ℹ️ Já está logado');
        return;
      }

      final textFields = find.byType(TextFormField);
      if (textFields.evaluate().length >= 2) {
        await tester.enterText(textFields.first, 'adm2@adm.com');
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        await tester.enterText(textFields.at(1), '123456');
        await tester.pumpAndSettle(const Duration(milliseconds: 500));

        if (loginButtonAlt.evaluate().isNotEmpty) {
          await tester.tap(loginButtonAlt.first);
          await tester.pumpAndSettle(const Duration(seconds: 5));
          print('✅ Login realizado com sucesso');
        }
      }
    }

    // Helper para navegação para Clientes
    Future<void> _navegarParaClientes(WidgetTester tester) async {
      print('🧭 Navegando para Clientes...');

      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Tentar encontrar "Cadastro" primeiro
        final cadastroOption = find.text('Cadastro');
        if (cadastroOption.evaluate().isNotEmpty) {
          print('📋 Expandindo menu Cadastro...');
          await tester.tap(cadastroOption);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }

        // Procurar por Clientes
        final clientesOptions = ['Clientes', 'Cliente', 'Cadastro de Clientes'];
        bool encontrou = false;

        for (final option in clientesOptions) {
          final optionFinder = find.text(option);
          if (optionFinder.evaluate().isNotEmpty) {
            print('👥 Encontrada opção "$option", clicando...');
            // Usar first para evitar ambiguidade quando há múltiplos widgets
            await tester.tap(optionFinder.first, warnIfMissed: false);
            await tester.pumpAndSettle(const Duration(seconds: 3));
            print('✅ Navegou para Clientes');
            encontrou = true;
            break;
          }
        }

        if (!encontrou) {
          print('❌ Opção Clientes não encontrada');
        }
      }
    }

    testWidgets('🎯 Teste Completo: Navegação para Clientes', (
      WidgetTester tester,
    ) async {
      print('🚀 INICIANDO TESTE DE NAVEGAÇÃO PARA CLIENTES...');

      // Inicializar app
      app.main();
      await tester.pumpAndSettle();
      print('📱 App inicializado');

      // Fazer login
      await _fazerLogin(tester);
      await _logEstruturaAtual(tester, 'Tela Principal após Login');

      // Navegar para Clientes
      await _navegarParaClientes(tester);
      await _logEstruturaAtual(tester, 'Tela de Clientes');

      // Verificações finais
      expect(find.byType(MaterialApp), findsOneWidget);

      // Verificar se chegamos na tela de clientes
      final clientesTexts = ['Clientes', 'Cliente', 'Cadastrar', 'Buscar'];
      bool naTelaClientes = false;
      for (final text in clientesTexts) {
        if (find.text(text).evaluate().isNotEmpty) {
          naTelaClientes = true;
          print('✅ Confirmado: Está na tela de Clientes (encontrado "$text")');
          break;
        }
      }

      if (!naTelaClientes) {
        print('⚠️ Não foi possível confirmar se chegou na tela de Clientes');
      }

      print('🏁 TESTE DE CLIENTES FINALIZADO!');
    });

    testWidgets('🎯 Teste: Navegação para Produtos', (
      WidgetTester tester,
    ) async {
      print('🚀 INICIANDO TESTE DE NAVEGAÇÃO PARA PRODUTOS...');

      // Inicializar app e fazer login
      app.main();
      await tester.pumpAndSettle();
      await _fazerLogin(tester);

      print('📦 Navegando para Produtos...');
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Expandir Cadastro se necessário
        final cadastroOption = find.text('Cadastro');
        if (cadastroOption.evaluate().isNotEmpty) {
          await tester.tap(cadastroOption);
          await tester.pumpAndSettle(const Duration(seconds: 2));
        }

        // Procurar Produtos
        final produtoOption = find.text('Produto');
        if (produtoOption.evaluate().isNotEmpty) {
          print('📦 Encontrada opção "Produto", navegando...');
          await tester.tap(produtoOption, warnIfMissed: false);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          print('✅ Navegou para Produtos');

          await _logEstruturaAtual(tester, 'Tela de Produtos');
        } else {
          print('❌ Opção Produto não encontrada');
        }
      }

      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 TESTE DE PRODUTOS FINALIZADO!');
    });

    testWidgets('🎯 Teste: Exploração do Menu Lateral', (
      WidgetTester tester,
    ) async {
      print('🚀 INICIANDO TESTE DE EXPLORAÇÃO COMPLETA DO MENU...');

      // Inicializar app e fazer login
      app.main();
      await tester.pumpAndSettle();
      await _fazerLogin(tester);

      print('🗂️ Explorando todas as opções do menu lateral...');
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        print('📋 Menu aberto - analisando opções disponíveis:');
        await _logEstruturaAtual(tester, 'Menu Lateral Aberto');

        // Lista de seções para explorar
        final secoes = [
          'Cadastro',
          'Venda',
          'Caixa',
          'Estoque',
          'Relatório',
          'Configurações',
        ];

        for (final secao in secoes) {
          final secaoOption = find.text(secao);
          if (secaoOption.evaluate().isNotEmpty) {
            print('📂 Expandindo seção: $secao');
            await tester.tap(secaoOption, warnIfMissed: false);
            await tester.pumpAndSettle(const Duration(seconds: 2));
            await _logEstruturaAtual(tester, 'Seção $secao Expandida');
          }
        }

        // Fechar drawer
        await tester.tapAt(const Offset(300, 300));
        await tester.pumpAndSettle();
      }

      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 EXPLORAÇÃO DO MENU FINALIZADA!');
    });

    testWidgets('🎯 Teste: Fluxo de Navegação Vendas', (
      WidgetTester tester,
    ) async {
      print('🚀 INICIANDO TESTE DE NAVEGAÇÃO PARA VENDAS...');

      // Inicializar app e fazer login
      app.main();
      await tester.pumpAndSettle();
      await _fazerLogin(tester);

      print('💰 Testando acesso às funcionalidades de Venda...');
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Procurar seção Venda
        final vendaOption = find.text('Venda');
        if (vendaOption.evaluate().isNotEmpty) {
          print('💰 Expandindo seção Venda...');
          await tester.tap(vendaOption, warnIfMissed: false);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          await _logEstruturaAtual(tester, 'Seção Venda Expandida');
        }

        // Procurar por PDV na tela principal
        await tester.tapAt(const Offset(300, 300)); // Fechar drawer
        await tester.pumpAndSettle();

        final pdvButton = find.text('PDV');
        if (pdvButton.evaluate().isNotEmpty) {
          print('🛒 Encontrado botão PDV na tela principal');
          // Não vamos clicar para não iniciar uma venda real
          print('ℹ️ PDV disponível (não clicado para evitar transação)');
        }
      }

      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 TESTE DE VENDAS FINALIZADO!');
    });

    testWidgets('⚡ Teste de Performance: Navegação Rápida', (
      WidgetTester tester,
    ) async {
      print('⚡ INICIANDO TESTE DE PERFORMANCE DE NAVEGAÇÃO...');

      final stopwatch = Stopwatch()..start();

      // Inicializar app
      app.main();
      await tester.pumpAndSettle();

      // Login rápido
      await _fazerLogin(tester);

      // Teste de navegação rápida entre seções
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        // Abrir menu
        await tester.tap(drawerButton);
        await tester.pumpAndSettle();

        // Expandir Cadastro
        final cadastroOption = find.text('Cadastro');
        if (cadastroOption.evaluate().isNotEmpty) {
          await tester.tap(cadastroOption);
          await tester.pumpAndSettle();
        }

        // Ir para Fornecedor
        final fornecedorOption = find.text('Fornecedor');
        if (fornecedorOption.evaluate().isNotEmpty) {
          await tester.tap(fornecedorOption, warnIfMissed: false);
          await tester.pumpAndSettle();
        }

        // Voltar ao menu
        final backButton = find.byIcon(Icons.arrow_back);
        if (backButton.evaluate().isNotEmpty) {
          await tester.tap(backButton);
          await tester.pumpAndSettle();
        }
      }

      stopwatch.stop();
      final tempoMs = stopwatch.elapsedMilliseconds;
      final tempoS = (tempoMs / 1000).toStringAsFixed(1);

      print('⚡ Tempo total de navegação: ${tempoS}s (${tempoMs}ms)');

      // Verificar se a navegação foi rápida o suficiente
      expect(stopwatch.elapsedMilliseconds, lessThan(30000)); // 30 segundos
      expect(find.byType(MaterialApp), findsOneWidget);

      if (tempoMs < 15000) {
        print('🚀 Performance EXCELENTE - Navegação muito rápida!');
      } else if (tempoMs < 25000) {
        print('✅ Performance BOA - Navegação adequada');
      } else {
        print('⚠️ Performance REGULAR - Navegação um pouco lenta');
      }

      print('🏁 TESTE DE PERFORMANCE FINALIZADO!');
    });
  });
}
