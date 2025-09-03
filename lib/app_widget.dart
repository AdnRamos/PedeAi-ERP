import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedeai/theme/app_theme.dart';

import 'package:pedeai/model/usuario.dart';
import 'package:pedeai/view/caixa/abertura.dart';
import 'package:pedeai/view/caixa/fechamento.dart';
import 'package:pedeai/view/empresa/empresa.dart';
import 'package:pedeai/view/estoque/estoque.dart';
import 'package:pedeai/view/cadastro/categoria/Categoria.dart';
import 'package:pedeai/view/cadastro/unidade/Unidade.dart';
import 'package:pedeai/view/cadastro/forma-pagamento/forma_pagamento.dart';
import 'package:pedeai/view/home/home.dart';
import 'package:pedeai/view/login/login.dart';
import 'package:pedeai/view/venda/listVendas.dart';
import 'package:pedeai/view/venda/pagamentoPdv.dart';
import 'package:pedeai/view/venda/pdv.dart';
import 'package:pedeai/view/cadastro/produto/cadastroProduto.dart';
import 'package:pedeai/view/cadastro/produto/listProdutos.dart';
import 'package:pedeai/view/cadastro/usuario/cadastroUsuario.dart';
import 'package:pedeai/view/cadastro/usuario/listUsuario.dart';
import 'package:pedeai/view/venda/vendaDetalhe.dart';
import 'package:pedeai/theme/theme_controller.dart';
import 'package:pedeai/view/configuracao/configuracao.dart';
import 'package:pedeai/view/cadastro/fornecedor/listFornecedores.dart';
import 'package:pedeai/view/cadastro/fornecedor/cadastroFornecedor.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = context.watch<ThemeController>();
    return MaterialApp(
      title: 'PedeAi ERP',
      debugShowCheckedModeBanner: false,
      theme: buildLightTheme(),
      darkTheme: buildDarkTheme(),
      themeMode: themeController.mode,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginPage(),
        '/home': (context) => HomePage(),
        '/listCategorias': (context) => CategoriasPage(),
        '/listUnidades': (context) => UnidadesPage(),
        '/listFormasPagamento': (context) => FormasPagamentoPage(),
        '/listProdutos': (context) => ProductsListPage(),
        '/cadastro-produto': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as int?;
          return CadastroProdutoPage(produtoId: args);
        },
        '/listFornecedores': (context) => const ListFornecedoresPage(),
        '/cadastroFornecedor': (context) {
          final fornecedorId =
              ModalRoute.of(context)!.settings.arguments as int?;
          return CadastroFornecedorPage(fornecedorId: fornecedorId);
        },
        '/listUsuarios': (context) => ListUsuarioPage(),
        '/cadastro-usuario': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Usuario?;
          return CadastroUsuarioPage(usuario: args);
        },
        '/estoque': (context) => EstoquePage(),
        '/pdv': (context) => PDVPage(),
        '/config': (context) => const ThemeSettingsPage(),
        '/pagamentoPdv': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return PagamentoPdvPage(
            subtotal: args?['subtotal'] ?? 0.0,
            desconto: args?['desconto'] ?? 0.0,
            total: args?['total'] ?? 0.0,
            carrinho: args?['carrinho'] ?? [],
          );
        },
        '/aberturaCaixa': (context) => AberturaCaixaPage(),
        '/fechamentoCaixa': (context) => FechamentoCaixaPage(),
        '/listVendas': (context) => ListagemVendasPage(),
        '/venda-detalhe': (context) {
          final args =
              ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
          return VendaDetalhePage(idVenda: args?['idVenda'] ?? 0);
        },
        '/empresa': (context) => EmpresaPage(),
      },
    );
  }
}

