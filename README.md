# FlowKey Mobile

## Introdução

O FlowKey Mobile é uma aplicação desenvolvida para a Universidade Federal do Oeste do Pará (UFOPA) que permite o gerenciamento do empréstimo de chaves de salas e laboratórios.

## Requisitos

Para executar este projeto, você precisará ter instalado em sua máquina:

- [Flutter](https://flutter.dev/docs/get-started/install)
- Um dispositivo Android físico com depuração USB configurada ou um dispositivo virtual Android (emulador)

> **Nota:** A configuração de um dispositivo físico para depuração ou a criação de um dispositivo virtual não está no escopo deste guia.

## Instalação e Configuração

Siga os passos abaixo para clonar e configurar o projeto:

1. **Clonar o repositório:**

```bash
git clone https://github.com/jpsantosbembe/flowkey_mobile.git
```

2. **Acessar o diretório do projeto:**

```bash
cd flowkey_mobile
```

3. **Instalar dependências do Flutter:**

```bash
flutter pub get
```

4. **Configurar a API:** Antes de executar o aplicativo, é necessário verificar e ajustar a URL da API no arquivo:

```
lib/services/api_services.dart
```

Abra este arquivo e localize a linha:

```dart
var apiUrl = 'sua url da api';
```

Atualize o valor para apontar para a instância correta da API FlowKey. Por exemplo:

```dart
// Para desenvolvimento local, você pode usar:
// var apiUrl = 'http://192.168.1.100:8000';
// ou
// var apiUrl = 'http://10.0.2.2:8000'; // Para emuladores Android
```

## Execução do Projeto

Siga os passos abaixo para executar o projeto:

1. **Verificar dispositivos disponíveis:**

```bash
flutter devices
```

2. **Executar o aplicativo:**

```bash
flutter run
```

---

O FlowKey Mobile é um aplicativo Flutter que utiliza a API fornecida pelo sistema [FlowKey](https://github.com/jpsantosbembe/flowkey).