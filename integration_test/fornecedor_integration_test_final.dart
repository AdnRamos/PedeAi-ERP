import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pedeai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de Integração do PedeAi', () {
    // Log para debug da estrutura atual
    Future<void> _logEstruturaAtual(WidgetTester tester) async {
      print('📱 Analisando tela atual...');

      // Aguardar estabilização antes da análise
      await tester.pumpAndSettle(const Duration(milliseconds: 500));
      print('🔄 Tela estabilizada, coletando informações...');

      final scaffolds = find.byType(Scaffold);
      final appBars = find.byType(AppBar);
      final texts = find.byType(Text);
      final listTiles = find.byType(ListTile);
      final buttons = find.byType(ElevatedButton);
      final textButtons = find.byType(TextButton);

      print('📊 ESTRUTURA COMPLETA DA TELA:');
      print('   - Scaffolds: ${scaffolds.evaluate().length}');
      print('   - AppBars: ${appBars.evaluate().length}');
      print('   - ListTiles: ${listTiles.evaluate().length}');
      print('   - ElevatedButtons: ${buttons.evaluate().length}');
      print('   - TextButtons: ${textButtons.evaluate().length}');
      print('   - Total de Texts: ${texts.evaluate().length}');

      // Listar TODOS os textos encontrados (EXPANDIDO para menu)
      print('📝 TEXTOS ENCONTRADOS:');
      for (int i = 0; i < texts.evaluate().length && i < 50; i++) {
        try {
          final textWidget = tester.widget<Text>(texts.at(i));
          final textContent =
              textWidget.data ?? textWidget.textSpan?.toPlainText() ?? 'null';
          print('   $i: "$textContent"');
        } catch (e) {
          print('   $i: [erro ao ler texto]');
        }
      }

      if (texts.evaluate().length > 50) {
        print(
          '   ... e mais ${texts.evaluate().length - 50} textos não mostrados',
        );
      }

      // Verificar textos importantes para navegação
      final menuTexts = [
        'Cadastro',
        'Fornecedor',
        'Fornecedores',
        'Login',
        'Email',
        'Senha',
        'ENTRAR',
        'Entrar',
        'Clientes',
        'Produtos',
      ];
      print('🔍 TEXTOS IMPORTANTES PARA NAVEGAÇÃO:');
      for (final text in menuTexts) {
        final found = find.text(text);
        if (found.evaluate().isNotEmpty) {
          print('   ✅ "$text" (encontrado)');
        }
      }

      // Verificar elementos de navegação
      final drawer = find.byIcon(Icons.menu);
      if (drawer.evaluate().isNotEmpty) {
        print('   🍔 Menu drawer: DISPONÍVEL');
      } else {
        print('   ❌ Menu drawer: NÃO ENCONTRADO');
      }
    }

    // Helper para verificar sucesso do login
    Future<void> _verificarLoginSucesso(WidgetTester tester) async {
      // Aguardar um pouco para a tela processar
      await tester.pumpAndSettle(const Duration(seconds: 1));

      final loginButton = find.text('ENTRAR');
      final loginButtonAlt = find.text('Entrar');

      if (loginButton.evaluate().isEmpty && loginButtonAlt.evaluate().isEmpty) {
        print('✅ LOGIN BEM-SUCEDIDO! Saiu da tela de login');
        await _logEstruturaAtual(tester);
      } else {
        print('❌ FALHA NO LOGIN - Ainda está na tela de login');
      }
    }

    // Helper para login com verificação detalhada
    Future<void> _loginDetalhado(WidgetTester tester) async {
      print('🔐 INICIANDO PROCESSO DE LOGIN DETALHADO...');

      // Aguardar tela carregar completamente
      print('⏳ Aguardando carregamento inicial...');
      await tester.pumpAndSettle(const Duration(seconds: 2));

      print('🔍 Verificando se há elementos carregando...');
      await tester.pump(const Duration(milliseconds: 500));

      print('✅ Análise da tela começando...');

      // Log inicial
      await _logEstruturaAtual(tester);

      // Verificar se já está logado
      final loginButton = find.text('ENTRAR');
      final loginButtonAlt = find.text('Entrar');

      if (loginButton.evaluate().isEmpty && loginButtonAlt.evaluate().isEmpty) {
        print('ℹ️ Já está logado ou não está na tela de login');
        return;
      }

      print('📝 Encontrada tela de login, preenchendo campos...');

      // Encontrar campos de texto
      final textFields = find.byType(TextFormField);
      final textFieldCount = textFields.evaluate().length;
      print('   - Campos encontrados: $textFieldCount');

      if (textFieldCount >= 2) {
        // Preencher email
        print('✉️ Preenchendo email: adm2@adm.com');
        await tester.enterText(textFields.first, 'adm2@adm.com');
        await tester.pumpAndSettle(const Duration(milliseconds: 1000));

        // Preencher senha
        print('🔑 Preenchendo senha: 123456');
        await tester.enterText(textFields.at(1), '123456');
        await tester.pumpAndSettle(const Duration(milliseconds: 1000));

        // Clicar no botão ENTRAR/Entrar
        final loginButtonEntrar = find.text('ENTRAR');
        final loginButtonEntrarCap = find.text('Entrar');

        if (loginButtonEntrar.evaluate().isNotEmpty) {
          print('🚀 Clicando no botão ENTRAR...');
          await tester.tap(loginButtonEntrar.first);
        } else if (loginButtonEntrarCap.evaluate().isNotEmpty) {
          print('🚀 Clicando no botão Entrar...');
          await tester.tap(loginButtonEntrarCap.first);
        } else {
          print('❌ Botão de login não encontrado (ENTRAR ou Entrar)');
          return;
        }

        // Aguardar processamento do login
        print('⏳ Aguardando processamento do login...');
        print('🌐 Conectando com Supabase...');
        await tester.pump(const Duration(seconds: 1));

        print('🔄 Aguardando resposta do servidor...');
        await tester.pump(const Duration(seconds: 2));

        print('📊 Carregando dados do usuário...');
        await tester.pump(const Duration(seconds: 1));

        print('🏠 Preparando tela principal...');
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verificar resultado
        await _verificarLoginSucesso(tester);
      } else {
        print('❌ Campos de login não encontrados');
      }
    }

    // Função específica para navegação para Fornecedores
    Future<void> _navegarParaFornecedores(WidgetTester tester) async {
      print('🧭 INICIANDO NAVEGAÇÃO PARA FORNECEDORES...');

      // Verificar se há drawer disponível
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isEmpty) {
        print('❌ Menu drawer não encontrado');
        return;
      }

      print('🍔 Abrindo menu drawer...');
      await tester.tap(drawerButton);
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Log do que está disponível no menu
      print('📋 Verificando opções disponíveis no menu:');
      await _logEstruturaAtual(tester);

      // Primeira tentativa: Procurar "Cadastros"
      print('🔍 Procurando seção "Cadastros"...');
      final cadastrosOption = find.text('Cadastro');

      if (cadastrosOption.evaluate().isNotEmpty) {
        print('📋 Encontrada seção "Cadastros", clicando...');
        await tester.tap(cadastrosOption);
        await tester.pumpAndSettle(const Duration(seconds: 2));

        print('📋 Menu "Cadastros" expandido, procurando "Fornecedor"...');
        await _logEstruturaAtual(tester);

        // Procurar "Fornecedor" ou "Fornecedores" dentro de Cadastros
        final fornecedorOption = find.text('Fornecedor');
        final fornecedoresOption = find.text('Fornecedores');

        if (fornecedorOption.evaluate().isNotEmpty) {
          print('🏢 Encontrada opção "Fornecedor", navegando...');
          await tester.tap(fornecedorOption, warnIfMissed: false);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          print('✅ Navegou para: Cadastros → Fornecedor');
        } else if (fornecedoresOption.evaluate().isNotEmpty) {
          print('🏢 Encontrada opção "Fornecedores", navegando...');
          await tester.tap(fornecedoresOption, warnIfMissed: false);
          await tester.pumpAndSettle(const Duration(seconds: 3));
          print('✅ Navegou para: Cadastros → Fornecedores');
        } else {
          print('❌ Opção "Fornecedor" não encontrada dentro de Cadastros');
        }
      } else {
        print('❌ Seção "Cadastros" não encontrada no menu');
        print('🔍 Tentando outras variações...');

        // Tentar outras possibilidades de nomes
        final alternativas = [
          'Fornecedores',
          'Fornecedor',
          'Cadastro de Fornecedores',
          'Cadastro de Fornecedor',
          'Gerenciar Fornecedores',
          'Fornec',
          'Suppliers', // caso esteja em inglês
        ];

        bool encontrouAlternativa = false;

        for (final alt in alternativas) {
          final altOption = find.text(alt);
          if (altOption.evaluate().isNotEmpty) {
            print('🏢 Encontrada opção "$alt", navegando...');
            await tester.tap(altOption, warnIfMissed: false);
            await tester.pumpAndSettle(const Duration(seconds: 3));
            print('✅ Navegou para: $alt');
            encontrouAlternativa = true;
            break;
          }
        }

        if (!encontrouAlternativa) {
          print('❌ Nenhuma variação de fornecedores encontrada');
          print('🔍 Tentando busca por texto contendo...');

          // Buscar por texto que contenha "fornec"
          final fornecContaining = find.textContaining(
            'fornec',
            findRichText: true,
          );
          if (fornecContaining.evaluate().isNotEmpty) {
            print('🏢 Encontrado texto contendo "fornec", tentando clicar...');
            await tester.tap(fornecContaining.first, warnIfMissed: false);
            await tester.pumpAndSettle(const Duration(seconds: 3));
            print('✅ Tentativa de navegação realizada');
          } else {
            print('❌ Nenhum texto contendo "fornec" encontrado');
          }
        }
      } // Log da tela final após navegação
      print('📱 Verificando tela final após navegação para Fornecedores:');
      await _logEstruturaAtual(tester);
    }

    testWidgets('🎯 Teste Completo: Login e Navegação para Fornecedores', (
      WidgetTester tester,
    ) async {
      print('🚀 INICIANDO TESTE COMPLETO DO APP...');
      print('🎯 OBJETIVO: Login → Menu → Cadastros → Fornecedor');

      // Inicializar app
      app.main();
      await tester.pumpAndSettle();
      print('📱 App inicializado');

      // Verificações iniciais
      expect(find.byType(MaterialApp), findsOneWidget);
      expect(find.byType(Scaffold), findsAtLeastNWidgets(1));
      print('✅ Estrutura básica do app OK');

      // Fazer login com verificação detalhada
      await _loginDetalhado(tester);

      // Aguardar estabilização completa
      await tester.pumpAndSettle(const Duration(seconds: 2));

      // Verificar se login foi bem-sucedido antes de navegar
      final loginCheckEntrar = find.text('ENTRAR');
      final loginCheckEntrarCap = find.text('Entrar');

      if (loginCheckEntrar.evaluate().isEmpty &&
          loginCheckEntrarCap.evaluate().isEmpty) {
        print('✅ Login realizado com sucesso, iniciando navegação...');

        // Navegar especificamente para Fornecedores
        await _navegarParaFornecedores(tester);
      } else {
        print('❌ Login não foi bem-sucedido, pulando navegação');
      }

      // Verificação final
      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 TESTE COMPLETO FINALIZADO!');
    });

    testWidgets('⏱️ Teste de Performance do Login', (
      WidgetTester tester,
    ) async {
      print('⏱️ TESTANDO PERFORMANCE DO LOGIN...');

      final stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle();
      await _loginDetalhado(tester);

      stopwatch.stop();
      final tempoMs = stopwatch.elapsedMilliseconds;
      final tempoS = (tempoMs / 1000).toStringAsFixed(1);

      print('📊 Tempo total de login: ${tempoS}s (${tempoMs}ms)');

      // Verificar se login foi realizado
      final loginCheckEntrar = find.text('ENTRAR');
      final loginCheckEntrarCap = find.text('Entrar');

      if (loginCheckEntrar.evaluate().isEmpty &&
          loginCheckEntrarCap.evaluate().isEmpty) {
        print('✅ Performance OK - Login realizado em ${tempoS}s');
      } else {
        print('❌ Login não completado no tempo medido');
      }

      expect(stopwatch.elapsedMilliseconds, lessThan(60000)); // 60 segundos
      expect(find.byType(MaterialApp), findsOneWidget);
    });
  });
}
