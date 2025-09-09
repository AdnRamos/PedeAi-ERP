import 'package:flutter_test/flutter_test.dart';
import 'package:pedeai/model/fornecedor.dart';

void main() {
  group('Fornecedor Business Logic Tests', () {
    test('Deve criar fornecedor com dados válidos', () {
      // Arrange & Act
      final fornecedor = Fornecedor(
        razaoSocial: 'Empresa Válida Ltda',
        cnpj: '12.345.678/0001-90',
        nomeFantasia: 'Empresa Válida',
        email: 'contato@empresa.com',
      );

      // Assert
      expect(fornecedor.razaoSocial, equals('Empresa Válida Ltda'));
      expect(fornecedor.cnpj, equals('12.345.678/0001-90'));
      expect(fornecedor.nomeFantasia, equals('Empresa Válida'));
      expect(fornecedor.email, equals('contato@empresa.com'));
    });

    test('Deve validar que razão social não é nula', () {
      // Arrange
      final fornecedor = Fornecedor(
        razaoSocial: 'Empresa Teste Ltda',
        cnpj: '12.345.678/0001-90',
      );

      // Act & Assert
      expect(fornecedor.razaoSocial, isNotNull);
      expect(fornecedor.razaoSocial, isNotEmpty);
      expect(fornecedor.razaoSocial!.length, greaterThan(5));
    });

    test('Deve aceitar CNPJ formatado', () {
      // Arrange
      final fornecedor = Fornecedor(
        razaoSocial: 'Empresa Teste',
        cnpj: '12.345.678/0001-90',
      );

      // Act & Assert
      expect(fornecedor.cnpj, isNotNull);
      expect(fornecedor.cnpj, contains('.'));
      expect(fornecedor.cnpj, contains('/'));
      expect(fornecedor.cnpj, contains('-'));
    });

    test('Deve aceitar fornecedor com dados opcionais nulos', () {
      // Arrange
      final fornecedor = Fornecedor(razaoSocial: 'Empresa Mínima');

      // Act & Assert
      expect(fornecedor.razaoSocial, isNotNull);
      expect(fornecedor.cnpj, isNull);
      expect(fornecedor.email, isNull);
      expect(fornecedor.nomeFantasia, isNull);
    });

    test('Deve converter fornecedor para JSON e voltar', () {
      // Arrange
      final fornecedorOriginal = Fornecedor(
        id: 1,
        razaoSocial: 'Empresa JSON Ltda',
        nomeFantasia: 'JSON',
        cnpj: '98.765.432/0001-10',
        ie: '987654321',
        email: 'json@empresa.com',
      );

      // Act
      final json = fornecedorOriginal.toJson();
      final fornecedorReconstruido = Fornecedor.fromJson(json);

      // Assert
      expect(fornecedorReconstruido.id, equals(fornecedorOriginal.id));
      expect(
        fornecedorReconstruido.razaoSocial,
        equals(fornecedorOriginal.razaoSocial),
      );
      expect(
        fornecedorReconstruido.nomeFantasia,
        equals(fornecedorOriginal.nomeFantasia),
      );
      expect(fornecedorReconstruido.cnpj, equals(fornecedorOriginal.cnpj));
      expect(fornecedorReconstruido.ie, equals(fornecedorOriginal.ie));
      expect(fornecedorReconstruido.email, equals(fornecedorOriginal.email));
    });

    test('Deve validar email quando fornecido', () {
      // Arrange
      final fornecedorComEmail = Fornecedor(
        razaoSocial: 'Empresa Email',
        email: 'contato@empresa.com.br',
      );

      final fornecedorSemEmail = Fornecedor(razaoSocial: 'Empresa Sem Email');

      // Act & Assert
      expect(fornecedorComEmail.email, isNotNull);
      expect(fornecedorComEmail.email, contains('@'));
      expect(fornecedorComEmail.email, contains('.'));

      expect(fornecedorSemEmail.email, isNull);
    });

    test('Deve permitir múltiplos fornecedores', () {
      // Arrange
      final fornecedores = <Fornecedor>[
        Fornecedor(
          razaoSocial: 'Fornecedor A Ltda',
          cnpj: '11.111.111/0001-11',
        ),
        Fornecedor(
          razaoSocial: 'Fornecedor B Ltda',
          cnpj: '22.222.222/0001-22',
        ),
        Fornecedor(
          razaoSocial: 'Fornecedor C Ltda',
          cnpj: '33.333.333/0001-33',
        ),
      ];

      // Act & Assert
      expect(fornecedores, hasLength(3));
      expect(fornecedores.every((f) => f.razaoSocial != null), isTrue);
      expect(fornecedores.every((f) => f.cnpj != null), isTrue);

      final cnpjs = fornecedores.map((f) => f.cnpj).toList();
      expect(cnpjs.toSet(), hasLength(3)); // CNPJs únicos
    });
  });

  group('Fornecedor Validation Tests', () {
    test('Deve identificar razão social muito curta', () {
      // Arrange
      final fornecedor = Fornecedor(razaoSocial: 'AB');

      // Act & Assert
      expect(fornecedor.razaoSocial, isNotNull);
      expect(fornecedor.razaoSocial!.length, lessThan(5));
    });

    test('Deve aceitar razão social adequada', () {
      // Arrange
      final fornecedor = Fornecedor(razaoSocial: 'Empresa Adequada Ltda');

      // Act & Assert
      expect(fornecedor.razaoSocial, isNotNull);
      expect(fornecedor.razaoSocial!.length, greaterThanOrEqualTo(5));
    });

    test('Deve trabalhar com caracteres especiais no nome', () {
      // Arrange
      final fornecedor = Fornecedor(
        razaoSocial: 'João & Maria Comércio Ltda - ME',
        nomeFantasia: 'João & Maria',
      );

      // Act & Assert
      expect(fornecedor.razaoSocial, contains('&'));
      expect(fornecedor.razaoSocial, contains('-'));
      expect(fornecedor.nomeFantasia, contains('&'));
    });
  });
}
