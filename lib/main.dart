import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pedeai/Commom/supabaseConf.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pedeai/app_widget.dart';
import 'package:pedeai/theme/theme_controller.dart';
import 'package:pedeai/controller/caixaController.dart';
import 'package:pedeai/controller/produtoController.dart';
import 'package:pedeai/controller/usuarioController.dart';
import 'package:pedeai/controller/empresaController.dart';
import 'package:pedeai/controller/categoriaController.dart';
import 'package:pedeai/controller/unidadeController.dart';
import 'package:pedeai/controller/formaPagamentoController.dart';
import 'package:pedeai/controller/fornecedorController.dart';
import 'package:pedeai/controller/estoqueController.dart';
import 'package:pedeai/controller/vendaController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Supabase
  await Supabase.initialize(
    url: SupabaseConfig.supabaseUrl,
    anonKey: SupabaseConfig.supabaseAnonKey,
  );

  // Theme controller (1 única instância)
  final themeController = ThemeController();
  await themeController.load();

  // Rode o app registrando os controllers via Provider
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeController>.value(
          value: themeController,
        ),
        Provider(create: (_) => CaixaCotroller()),
        Provider(create: (_) => Produtocontroller()),
        Provider(create: (_) => UsuarioController()),
        Provider(create: (_) => EmpresaController()),
        Provider(create: (_) => Categoriacontroller()),
        Provider(create: (_) => Unidadecontroller()),
        Provider(create: (_) => FormaPagamentocontroller()),
        Provider(create: (_) => FornecedorController()),
        Provider(create: (_) => Estoquecontroller()),
        Provider(create: (_) => VendaController()),
      ],
      child: const AppWidget(),
    ),
  );
}
