# Testes do PedeAi - ERP

Este documento descreve a implementação dos testes no projeto PedeAi ERP.

## Estrutura dos Testes

O projeto implementa uma estrutura completa de testes seguindo as melhores práticas do Flutter:

### 1. Testes de Unidade (Unit Tests)
**Localização**: `test/`
**Quantidade**: 4 testes

#### 1.1 Fornecedor Model Test (`test/fornecedor_model_test.dart`)
- **Propósito**: Testa o modelo de dados Fornecedor
- **Cenários testados**:
  - Criação de fornecedor com todos os dados
  - Conversão para JSON
  - Criação de fornecedor a partir de JSON
  - Validação de relacionamentos (Endereco e Telefone)

### 2. Testes de Controlador (Controller Tests)
**Localização**: `test/`
**Quantidade**: 10 testes

#### 2.1 Fornecedor Controller Test (`test/fornecedor_controller_test.dart`)
- **Propósito**: Testa a lógica de negócio do controlador de fornecedores
- **Cenários testados**:
  - Criação de fornecedor com dados válidos
  - Validação de razão social
  - Validação de CNPJ formatado
  - Aceitação de dados opcionais nulos
  - Validação de email
  - Teste de cópia de fornecedor
  - Validação de igualdade entre objetos
  - Validação de dados únicos
  - Tratamento de casos extremos
  - Validação de regras de negócio

### 3. Testes de Widget (Widget Tests)
**Localização**: `test/`
**Quantidade**: 7 testes

#### 3.1 Simple Widget Test (`test/simple_widget_test.dart`)
- **Propósito**: Testa componentes básicos da interface
- **Cenários testados**:
  - Criação de widget Text básico
  - Formulário básico com campos
  - Botões e interações
  - Validação de formulários
  - Widgets customizados
  - Estados de loading
  - Navegação entre telas

### 4. Testes de Integração (Integration Tests)
**Localização**: `integration_test/`
**Quantidade**: 9 testes funcionando

#### 4.1 Fornecedor Integration Test (`integration_test/fornecedor_integration_test_final.dart`)
- **Propósito**: Testa fluxo completo de navegação para fornecedores
- **Cenários testados**:
  - Login completo no sistema
  - Navegação Menu → Cadastro → Fornecedor
  - Análise detalhada da estrutura de telas
  - Validação de elementos da interface

#### 4.2 Caixa Integration Test (`integration_test/caixa_integration_test.dart`)
- **Propósito**: Testa operações de caixa com validação de estados
- **Cenários testados**:
  - Abertura de caixa com inserção de valor
  - Verificação de caixa já aberto
  - Validação de duplicatas
  - Fluxo completo de abertura de caixa

#### 4.3 Funcionalidades Integration Test (`integration_test/funcionalidades_integration_test.dart`)
- **Propósito**: Testa funcionalidades avançadas do sistema
- **Cenários testados**:
  - Validação de campos de formulário
  - Funcionalidade de busca
  - Responsividade da interface
  - Teste de stress de navegação (com métricas de performance)

#### 4.4 Navigation Integration Test (`integration_test/navigation_integration_test.dart`)
- **Propósito**: Testa navegação entre diferentes módulos
- **Cenários testados**:
  - Navegação para Clientes
  - Navegação para Produtos
  - Exploração completa do menu lateral

## Execução dos Testes

### Executar todos os testes de unidade e widget:
```bash
flutter test
```

### Executar apenas testes de unidade:
```bash
flutter test test/fornecedor_model_test.dart
flutter test test/fornecedor_controller_test.dart
flutter test test/simple_widget_test.dart
```

### Executar apenas testes de integração:
```bash
flutter test integration_test/
```

### Executar um arquivo específico de integração:
```bash
flutter test integration_test/fornecedor_integration_test_final.dart
flutter test integration_test/caixa_integration_test.dart
flutter test integration_test/funcionalidades_integration_test.dart
flutter test integration_test/navigation_integration_test.dart
```

## Status dos Testes

### ✅ Funcionando Corretamente:
- **Testes de Unidade**: 4/4 passando
- **Testes de Controlador**: 10/10 passando  
- **Testes de Widget**: 7/7 passando
- **Testes de Integração**: 9 testes funcionando com recursos avançados

### ⚠️ Testes com Problemas:
- `test/cadastro_fornecedor_widget_test.dart`: Falha na inicialização do Supabase (8 testes falhando)

## Cobertura

- **Testes de Unidade**: 4 testes cobrindo modelo Fornecedor
- **Testes de Controlador**: 10 testes cobrindo lógica de negócio
- **Testes de Widget**: 7 testes cobrindo componentes de interface
- **Testes de Integração**: 9 testes cobrindo fluxos end-to-end

**Total**: 30 testes implementados (21 funcionando perfeitamente)

## Recursos Avançados dos Testes

### 🔍 Análise Detalhada de Telas
- Logging completo da estrutura de widgets
- Contagem de elementos por tipo
- Listagem de todos os textos encontrados
- Análise de responsividade

### ⚡ Testes de Performance
- Medição de tempo de navegação
- Teste de stress com 5 ciclos intensivos
- Validação de performance (< 45s para navegação intensiva)
- Métricas de responsividade

### 🔐 Autenticação Real
- Login com credenciais reais (`adm2@adm.com` / `123456`)
- Integração completa com backend Supabase
- Validação de estados de autenticação

### 🧭 Navegação Complexa
- Navegação multicamadas (Menu → Submenu → Tela final)
- Validação de todos os elementos de interface
- Teste de abertura/fechamento de menus
- Exploração completa do sistema

## Tecnologias e Frameworks

- **flutter_test**: Framework padrão do Flutter para testes
- **integration_test**: Plugin oficial para testes de integração
- **Supabase**: Backend real para autenticação e dados
- **Material Design**: Interface do usuário testada

## Estrutura de Arquivos

```
test/
├── fornecedor_model_test.dart              # 4 testes - Modelo de dados
├── fornecedor_controller_test.dart         # 10 testes - Lógica de negócio
├── simple_widget_test.dart                 # 7 testes - Widgets básicos
└── cadastro_fornecedor_widget_test.dart    # 8 testes - ⚠️ Com problemas

integration_test/
├── fornecedor_integration_test_final.dart  # 1 teste - Navegação Fornecedores
├── caixa_integration_test.dart             # 2 testes - Operações de caixa
├── funcionalidades_integration_test.dart   # 4 testes - Funcionalidades avançadas
└── navigation_integration_test.dart        # 3 testes - Navegação geral
```

## Configuração para Desenvolvimento

Para executar os testes em ambiente de desenvolvimento:

1. Certifique-se de que o Flutter SDK está atualizado
2. Configure as variáveis de ambiente do Supabase
3. Execute `flutter pub get` para instalar dependências
4. Para testes de integração, certifique-se de ter um dispositivo/emulador conectado
5. Execute os testes conforme os comandos acima

## Considerações Importantes

- Os testes de integração requerem um dispositivo ou emulador rodando Android
- Testes de integração fazem conexões reais com o backend Supabase
- Alguns testes incluem métricas de performance e podem falhar se o sistema estiver lento
- Os testes incluem logging detalhado para debugging
- Recomenda-se executar testes de integração individualmente para melhor análise
