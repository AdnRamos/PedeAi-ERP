import 'package:flutter_test/flutter_test.dart';
import 'package:pedeai/model/fornecedor.dart';
import 'package:pedeai/model/endereco.dart';
import 'package:pedeai/model/telefone.dart';

void main() {
  group('Fornecedor Model Tests', () {
    test('Deve criar um fornecedor com todos os dados', () {
      // Arrange
      final endereco = Endereco(
        logradouro: 'Rua das Flores, 123',
        bairro: 'Centro',
        cidade: 'São Paulo',
        uf: 'SP',
        cep: '01234-567',
      );

      final telefone = Telefone(numero: '(11) 98765-4321');

      // Act
      final fornecedor = Fornecedor(
        id: 1,
        razaoSocial: 'Empresa XYZ Ltda',
        nomeFantasia: 'XYZ',
        cnpj: '12.345.678/0001-90',
        ie: '123.456.789',
        email: 'contato@xyz.com',
        endereco: endereco,
        telefone: telefone,
      );

      // Assert
      expect(fornecedor.id, equals(1));
      expect(fornecedor.razaoSocial, equals('Empresa XYZ Ltda'));
      expect(fornecedor.nomeFantasia, equals('XYZ'));
      expect(fornecedor.cnpj, equals('12.345.678/0001-90'));
      expect(fornecedor.ie, equals('123.456.789'));
      expect(fornecedor.email, equals('contato@xyz.com'));
      expect(fornecedor.endereco, isNotNull);
      expect(fornecedor.telefone, isNotNull);
    });

    test('Deve converter fornecedor para JSON corretamente', () {
      // Arrange
      final endereco = Endereco(
        logradouro: 'Rua das Flores, 123',
        bairro: 'Centro',
        cidade: 'São Paulo',
        uf: 'SP',
        cep: '01234-567',
      );

      final telefone = Telefone(numero: '(11) 98765-4321');

      final fornecedor = Fornecedor(
        id: 1,
        razaoSocial: 'Empresa XYZ Ltda',
        nomeFantasia: 'XYZ',
        cnpj: '12.345.678/0001-90',
        ie: '123.456.789',
        email: 'contato@xyz.com',
        endereco: endereco,
        telefone: telefone,
      );

      // Act
      final json = fornecedor.toJson();

      // Assert
      expect(json['id'], equals(1));
      expect(json['nome_razao'], equals('Empresa XYZ Ltda'));
      expect(json['nome_popular'], equals('XYZ'));
      expect(json['cpf_cnpj'], equals('12.345.678/0001-90'));
      expect(json['rg_ie'], equals('123.456.789'));
      expect(json['email'], equals('contato@xyz.com'));
      expect(json['endereco'], isNotNull);
      expect(json['telefone'], isNotNull);
    });

    test('Deve criar fornecedor a partir de JSON', () {
      // Arrange
      final json = {
        'id': 1,
        'nome_razao': 'Empresa ABC Ltda',
        'nome_popular': 'ABC',
        'cpf_cnpj': '98.765.432/0001-10',
        'rg_ie': '987.654.321',
        'email': 'contato@abc.com',
      };

      // Act
      final fornecedor = Fornecedor.fromJson(json);

      // Assert
      expect(fornecedor.id, equals(1));
      expect(fornecedor.razaoSocial, equals('Empresa ABC Ltda'));
      expect(fornecedor.nomeFantasia, equals('ABC'));
      expect(fornecedor.cnpj, equals('98.765.432/0001-10'));
      expect(fornecedor.ie, equals('987.654.321'));
      expect(fornecedor.email, equals('contato@abc.com'));
    });

    test('Deve criar fornecedor com dados nulos', () {
      // Act
      final fornecedor = Fornecedor();

      // Assert
      expect(fornecedor.id, isNull);
      expect(fornecedor.razaoSocial, isNull);
      expect(fornecedor.nomeFantasia, isNull);
      expect(fornecedor.cnpj, isNull);
      expect(fornecedor.ie, isNull);
      expect(fornecedor.email, isNull);
      expect(fornecedor.endereco, isNull);
      expect(fornecedor.telefone, isNull);
    });
  });
}
