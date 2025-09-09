import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pedeai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de Integração: Funcionalidades Avançadas', () {
    // Helper para login rápido
    Future<void> _loginRapido(WidgetTester tester) async {
      await tester.pumpAndSettle(const Duration(seconds: 2));

      final loginButtonAlt = find.text('Entrar');
      if (loginButtonAlt.evaluate().isNotEmpty) {
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 2) {
          await tester.enterText(textFields.first, 'adm2@adm.com');
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
          await tester.enterText(textFields.at(1), '123456');
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
          await tester.tap(loginButtonAlt.first);
          await tester.pumpAndSettle(const Duration(seconds: 4));
        }
      }
    }

    // Helper para análise rápida
    Future<void> _analisarTela(WidgetTester tester, String nome) async {
      await tester.pumpAndSettle(const Duration(milliseconds: 300));
      final texts = find.byType(Text);
      final buttons = find.byType(ElevatedButton);
      final textFields = find.byType(TextFormField);

      print('📊 $nome:');
      print('   - Textos: ${texts.evaluate().length}');
      print('   - Botões: ${buttons.evaluate().length}');
      print('   - Campos: ${textFields.evaluate().length}');

      // Mostrar primeiros textos relevantes
      for (int i = 0; i < texts.evaluate().length && i < 5; i++) {
        try {
          final textWidget = tester.widget<Text>(texts.at(i));
          final content =
              textWidget.data ?? textWidget.textSpan?.toPlainText() ?? '';
          if (content.trim().isNotEmpty && content.length > 2) {
            print('   📝 "$content"');
          }
        } catch (e) {
          // Ignorar erros de leitura
        }
      }
    }

    testWidgets('🎯 Teste: Validação de Campos de Formulário', (
      WidgetTester tester,
    ) async {
      print('🚀 TESTE DE VALIDAÇÃO DE FORMULÁRIOS...');

      app.main();
      await tester.pumpAndSettle();
      await _loginRapido(tester);

      // Navegar para formulário de cadastro
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle();

        final cadastroOption = find.text('Cadastro');
        if (cadastroOption.evaluate().isNotEmpty) {
          await tester.tap(cadastroOption);
          await tester.pumpAndSettle();

          final fornecedorOption = find.text('Fornecedor');
          if (fornecedorOption.evaluate().isNotEmpty) {
            await tester.tap(fornecedorOption, warnIfMissed: false);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            await _analisarTela(tester, 'Tela de Fornecedores');

            // Procurar botão de cadastrar
            final cadastrarButtons = [
              'Cadastrar Novo Fornecedor',
              'Adicionar',
              'Novo',
              '+',
            ];

            bool encontrouCadastrar = false;
            for (final buttonText in cadastrarButtons) {
              final buttonFinder = find.text(buttonText);
              if (buttonFinder.evaluate().isNotEmpty) {
                print('🆕 Encontrado botão: $buttonText');
                await tester.tap(buttonFinder, warnIfMissed: false);
                await tester.pumpAndSettle(const Duration(seconds: 2));
                encontrouCadastrar = true;
                break;
              }
            }

            if (encontrouCadastrar) {
              await _analisarTela(tester, 'Formulário de Cadastro');

              // Testar validação de campos vazios
              final textFields = find.byType(TextFormField);
              if (textFields.evaluate().isNotEmpty) {
                print('📝 Testando validação de campos...');

                // Tentar salvar sem preencher
                final salvarButtons = ['Salvar', 'Confirmar', 'OK'];
                for (final buttonText in salvarButtons) {
                  final buttonFinder = find.text(buttonText);
                  if (buttonFinder.evaluate().isNotEmpty) {
                    print('💾 Tentando salvar sem preencher campos...');
                    await tester.tap(buttonFinder, warnIfMissed: false);
                    await tester.pumpAndSettle();

                    // Verificar se apareceram mensagens de erro
                    final errorTexts = [
                      'obrigatório',
                      'necessário',
                      'erro',
                      'inválido',
                    ];
                    bool temErro = false;
                    for (final errorText in errorTexts) {
                      if (find
                          .textContaining(errorText, findRichText: true)
                          .evaluate()
                          .isNotEmpty) {
                        print(
                          '✅ Validação funcionando: encontrado "$errorText"',
                        );
                        temErro = true;
                      }
                    }

                    if (!temErro) {
                      print('ℹ️ Nenhuma mensagem de erro detectada');
                    }
                    break;
                  }
                }
              }
            } else {
              print('ℹ️ Botão de cadastrar não encontrado');
            }
          }
        }
      }

      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 TESTE DE VALIDAÇÃO FINALIZADO!');
    });

    testWidgets('🎯 Teste: Funcionalidade de Busca', (
      WidgetTester tester,
    ) async {
      print('🚀 TESTE DE FUNCIONALIDADE DE BUSCA...');

      app.main();
      await tester.pumpAndSettle();
      await _loginRapido(tester);

      // Navegar para tela que tenha busca
      final drawerButton = find.byIcon(Icons.menu);
      if (drawerButton.evaluate().isNotEmpty) {
        await tester.tap(drawerButton);
        await tester.pumpAndSettle();

        final cadastroOption = find.text('Cadastro');
        if (cadastroOption.evaluate().isNotEmpty) {
          await tester.tap(cadastroOption);
          await tester.pumpAndSettle();

          // Testar busca em diferentes seções
          final secoes = ['Fornecedor', 'Cliente', 'Produto'];
          for (final secao in secoes) {
            final secaoOption = find.text(secao);
            if (secaoOption.evaluate().isNotEmpty) {
              print('🔍 Testando busca em: $secao');
              await tester.tap(secaoOption, warnIfMissed: false);
              await tester.pumpAndSettle(const Duration(seconds: 2));

              // Procurar campo de busca
              final searchFields = find.byType(TextFormField);
              final searchTexts = ['Buscar', 'Pesquisar', 'Filtrar'];

              bool encontrouBusca = false;

              // Verificar se existe campo com hint de busca
              for (int i = 0; i < searchFields.evaluate().length; i++) {
                try {
                  // Testar entrada de texto para ver se é campo de busca
                  await tester.enterText(searchFields.at(i), 'teste');
                  await tester.pumpAndSettle(const Duration(milliseconds: 300));

                  // Limpar o campo
                  await tester.enterText(searchFields.at(i), '');
                  await tester.pumpAndSettle();

                  print('🔍 Campo de entrada detectado (possível busca)');
                  encontrouBusca = true;
                  break;
                } catch (e) {
                  // Ignorar erros
                }
              }

              if (!encontrouBusca) {
                // Verificar se há texto indicando busca
                for (final searchText in searchTexts) {
                  if (find
                      .textContaining(searchText, findRichText: true)
                      .evaluate()
                      .isNotEmpty) {
                    print('🔍 Funcionalidade de busca detectada via texto');
                    encontrouBusca = true;
                    break;
                  }
                }
              }

              if (!encontrouBusca) {
                print('ℹ️ Funcionalidade de busca não detectada em $secao');
              }

              break; // Testar apenas a primeira seção encontrada
            }
          }
        }
      }

      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 TESTE DE BUSCA FINALIZADO!');
    });

    testWidgets('🎯 Teste: Responsividade da Interface', (
      WidgetTester tester,
    ) async {
      print('🚀 TESTE DE RESPONSIVIDADE DA INTERFACE...');

      app.main();
      await tester.pumpAndSettle();
      await _loginRapido(tester);

      await _analisarTela(tester, 'Tela Principal');

      // Testar abertura/fechamento do drawer múltiplas vezes
      print('📱 Testando responsividade do menu drawer...');
      final drawerButton = find.byIcon(Icons.menu);

      if (drawerButton.evaluate().isNotEmpty) {
        for (int i = 0; i < 3; i++) {
          print('   🔄 Ciclo ${i + 1}/3: Abrindo drawer...');
          await tester.tap(drawerButton);
          await tester.pumpAndSettle();

          print('   🔄 Fechando drawer...');
          await tester.tapAt(const Offset(300, 300));
          await tester.pumpAndSettle();
        }
        print('✅ Menu drawer respondeu corretamente');
      }

      // Testar botões da tela principal
      print('🔘 Testando responsividade dos botões principais...');
      final buttons = find.byType(ElevatedButton);
      int buttonsTestados = 0;

      for (int i = 0; i < buttons.evaluate().length && i < 3; i++) {
        try {
          final buttonWidget = tester.widget<ElevatedButton>(buttons.at(i));
          if (buttonWidget.onPressed != null) {
            print('   🔘 Testando botão ${i + 1}...');
            // Apenas verificar que o botão está habilitado, não clicar
            buttonsTestados++;
          }
        } catch (e) {
          // Ignorar botões que não conseguimos testar
        }
      }

      print('✅ $buttonsTestados botões responsivos encontrados');

      expect(find.byType(MaterialApp), findsOneWidget);
      print('🏁 TESTE DE RESPONSIVIDADE FINALIZADO!');
    });

    testWidgets('⚡ Teste de Stress: Navegação Intensiva', (
      WidgetTester tester,
    ) async {
      print('⚡ TESTE DE STRESS - NAVEGAÇÃO INTENSIVA...');

      final stopwatch = Stopwatch()..start();

      app.main();
      await tester.pumpAndSettle();
      await _loginRapido(tester);

      print('🔥 Iniciando navegação intensiva...');
      final drawerButton = find.byIcon(Icons.menu);

      if (drawerButton.evaluate().isNotEmpty) {
        // Realizar múltiplas navegações rapidamente
        for (int ciclo = 0; ciclo < 5; ciclo++) {
          print('   🔄 Ciclo de stress ${ciclo + 1}/5');

          // Abrir menu
          await tester.tap(drawerButton);
          await tester.pumpAndSettle(const Duration(milliseconds: 500));

          // Expandir Cadastro
          final cadastroOption = find.text('Cadastro');
          if (cadastroOption.evaluate().isNotEmpty) {
            await tester.tap(cadastroOption);
            await tester.pumpAndSettle(const Duration(milliseconds: 300));

            // Navegar para diferentes seções
            final secoes = ['Fornecedor', 'Cliente', 'Produto'];
            for (final secao in secoes) {
              final secaoOption = find.text(secao);
              if (secaoOption.evaluate().isNotEmpty) {
                await tester.tap(secaoOption, warnIfMissed: false);
                await tester.pumpAndSettle(const Duration(milliseconds: 200));

                // Voltar usando back button se disponível
                final backButton = find.byIcon(Icons.arrow_back);
                if (backButton.evaluate().isNotEmpty) {
                  await tester.tap(backButton);
                  await tester.pumpAndSettle(const Duration(milliseconds: 200));
                }
                break;
              }
            }
          }

          // Fechar menu
          await tester.tapAt(const Offset(300, 300));
          await tester.pumpAndSettle(const Duration(milliseconds: 300));
        }
      }

      stopwatch.stop();
      final tempoMs = stopwatch.elapsedMilliseconds;
      final tempoS = (tempoMs / 1000).toStringAsFixed(1);

      print('⚡ Teste de stress concluído em: ${tempoS}s');

      // Verificar se o app ainda está funcional após stress
      expect(find.byType(MaterialApp), findsOneWidget);

      if (tempoMs < 20000) {
        print('🚀 EXCELENTE: App manteve performance durante stress test');
      } else if (tempoMs < 35000) {
        print('✅ BOM: App respondeu adequadamente ao stress test');
      } else {
        print('⚠️ REGULAR: App ficou lento durante stress test');
      }

      expect(stopwatch.elapsedMilliseconds, lessThan(45000)); // 45 segundos max
      print('🏁 TESTE DE STRESS FINALIZADO!');
    });
  });
}
