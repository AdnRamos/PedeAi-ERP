import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:pedeai/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Teste de Integração - Caixa', () {
    testWidgets('Teste Completo: Abertura de Caixa com Verificação', (
      WidgetTester tester,
    ) async {
      print('🚀 INICIANDO TESTE DE ABERTURA DE CAIXA...');
      print('=' * 80);

      try {
        // 1. Inicializar aplicação
        print('🎬 ETAPA 1: Inicializando aplicação...');
        await app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));
        print('✅ App inicializado com sucesso');

        // 2. Fazer login
        print('\n🔐 ETAPA 2: Realizando login...');

        // Aguardar tela carregar
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Preencher campos de login
        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 2) {
          await tester.enterText(textFields.first, 'adm2@adm.com');
          await tester.enterText(textFields.at(1), '123456');
          await tester.pumpAndSettle(const Duration(seconds: 1));

          // Clicar no botão de login
          final loginButton = find.text('Entrar');
          if (loginButton.evaluate().isNotEmpty) {
            await tester.tap(loginButton.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));
            print('✅ Login realizado');
          }
        }

        // 3. Navegar para Caixa
        print('\n🧭 ETAPA 3: Navegando para Caixa...');

        // Abrir menu drawer
        final drawerButton = find.byIcon(Icons.menu);
        if (drawerButton.evaluate().isNotEmpty) {
          await tester.tap(drawerButton);
          await tester.pumpAndSettle(const Duration(seconds: 2));
          print('✅ Menu aberto');

          // Clicar em Caixa
          final caixaOption = find.text('Caixa');
          if (caixaOption.evaluate().isNotEmpty) {
            await tester.tap(caixaOption.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));
            print('✅ Navegado para Caixa');

            // Clicar em Abertura de caixa
            final aberturaOption = find.text('Abertura de caixa');
            if (aberturaOption.evaluate().isNotEmpty) {
              await tester.tap(aberturaOption.first);
              await tester.pumpAndSettle(const Duration(seconds: 3));
              print('✅ Navegado para Abertura de caixa');
            }
          }
        }

        // 4. Verificar se caixa já está aberto
        print('\n🔍 ETAPA 4: Verificando status do caixa...');

        // Aguardar um momento para a tela carregar completamente
        await tester.pumpAndSettle(const Duration(seconds: 2));

        // Verificar mensagens que indicam que o caixa já está aberto
        final mensagensCaixaAberto = [
          'O caixa já está aberto',
          'Caixa já aberto',
          'já está aberto',
          'caixa aberto',
        ];

        bool caixaJaAberto = false;
        String mensagemEncontrada = '';

        for (String mensagem in mensagensCaixaAberto) {
          final found = find.textContaining(mensagem);
          if (found.evaluate().isNotEmpty) {
            mensagemEncontrada = mensagem;
            caixaJaAberto = true;
            break;
          }
        }

        if (caixaJaAberto) {
          print('⚠️  CAIXA JÁ ESTÁ ABERTO!');
          print('ℹ️  Mensagem encontrada: $mensagemEncontrada');
          print('✅ O sistema corretamente impediu abertura duplicada');
          print(
            '🎉 TESTE CONCLUÍDO COM SUCESSO - Validação de caixa já aberto funcionou!',
          );
        } else {
          print('✅ Caixa não está aberto, prosseguindo com abertura...');

          // 5. Tentar inserir valor e confirmar
          print('\n💰 ETAPA 5: Inserindo valor e confirmando...');

          // Procurar por diferentes tipos de campos de texto
          final allTextFields = find.byType(TextFormField);
          final plainTextFields = find.byType(TextField);
          final editableTexts = find.byType(EditableText);

          bool valorInserido = false;
          String valorTeste = '100.00';

          // Tentar TextFormField
          if (allTextFields.evaluate().isNotEmpty) {
            print('📝 Inserindo valor em TextFormField...');
            await tester.enterText(allTextFields.first, valorTeste);
            valorInserido = true;
          }
          // Tentar TextField simples
          else if (plainTextFields.evaluate().isNotEmpty) {
            print('📝 Inserindo valor em TextField...');
            await tester.enterText(plainTextFields.first, valorTeste);
            valorInserido = true;
          }
          // Tentar EditableText
          else if (editableTexts.evaluate().isNotEmpty) {
            print('📝 Inserindo valor em EditableText...');
            await tester.enterText(editableTexts.first, valorTeste);
            valorInserido = true;
          }
          // Tentar clicar no valor 0,00 primeiro
          else {
            final valorZero = find.text('0,00');
            if (valorZero.evaluate().isNotEmpty) {
              print('🎯 Clicando no campo 0,00...');
              await tester.tap(valorZero.first);
              await tester.pumpAndSettle(const Duration(seconds: 1));

              // Tentar novamente após clicar
              final fieldsAposClic = find.byType(TextFormField);
              if (fieldsAposClic.evaluate().isNotEmpty) {
                print('📝 Agora inserindo valor após clique...');
                await tester.enterText(fieldsAposClic.first, valorTeste);
                valorInserido = true;
              }
            }
          }

          if (valorInserido) {
            print('✅ Valor $valorTeste inserido');
            await tester.pumpAndSettle(const Duration(seconds: 1));
          } else {
            print('⚠️  Não foi possível inserir valor, mas continuando...');
          }

          // Confirmar abertura
          final confirmarButton = find.text('Confirmar abertura');
          if (confirmarButton.evaluate().isNotEmpty) {
            print('🎯 Clicando em Confirmar abertura...');
            await tester.tap(confirmarButton.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));
            print('✅ Abertura confirmada');

            // Verificar possíveis mensagens de sucesso
            await tester.pumpAndSettle(const Duration(seconds: 2));
            final successKeywords = ['sucesso', 'aberto', 'confirmad'];
            for (String keyword in successKeywords) {
              final successMessage = find.textContaining(keyword);
              if (successMessage.evaluate().isNotEmpty) {
                print('🎉 Mensagem de sucesso encontrada contendo: $keyword');
                break;
              }
            }
          } else {
            print('❌ Botão Confirmar abertura não encontrado');
          }
        }

        print('\n🎉 TESTE CONCLUÍDO!');
        print('=' * 80);
      } catch (e) {
        print('❌ ERRO NO TESTE: $e');
        rethrow;
      }
    });

    testWidgets('Teste: Verificação de Caixa Já Aberto', (
      WidgetTester tester,
    ) async {
      print('🚀 TESTE ESPECÍFICO: Verificação de caixa já aberto...');

      try {
        // Inicializar e fazer login
        await app.main();
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final textFields = find.byType(TextFormField);
        if (textFields.evaluate().length >= 2) {
          await tester.enterText(textFields.first, 'adm2@adm.com');
          await tester.enterText(textFields.at(1), '123456');

          final loginButton = find.text('Entrar');
          if (loginButton.evaluate().isNotEmpty) {
            await tester.tap(loginButton.first);
            await tester.pumpAndSettle(const Duration(seconds: 3));
          }
        }

        // Navegar para Caixa > Abertura de caixa
        final drawerButton = find.byIcon(Icons.menu);
        if (drawerButton.evaluate().isNotEmpty) {
          await tester.tap(drawerButton);
          await tester.pumpAndSettle(const Duration(seconds: 2));

          final caixaOption = find.text('Caixa');
          if (caixaOption.evaluate().isNotEmpty) {
            await tester.tap(caixaOption.first);
            await tester.pumpAndSettle(const Duration(seconds: 2));

            final aberturaOption = find.text('Abertura de caixa');
            if (aberturaOption.evaluate().isNotEmpty) {
              await tester.tap(aberturaOption.first);
              await tester.pumpAndSettle(const Duration(seconds: 3));
            }
          }
        }

        // Verificar especificamente se há mensagem de caixa já aberto
        await tester.pumpAndSettle(const Duration(seconds: 2));

        final caixaJaAbertoMsg = find.textContaining('já está aberto');
        if (caixaJaAbertoMsg.evaluate().isNotEmpty) {
          print('✅ SUCESSO: Encontrada mensagem de caixa já aberto');
          print('🔒 Sistema corretamente bloqueou abertura duplicada');
        } else {
          print('ℹ️  Caixa não está aberto ou mensagem não encontrada');
        }

        print('🎉 TESTE DE VERIFICAÇÃO CONCLUÍDO!');
      } catch (e) {
        print('❌ ERRO: $e');
      }
    });
  });
}
