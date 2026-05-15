# Quem e o Impostor?

Projeto com backend em Node.js + app mobile em Flutter para o jogo local **Quem e o Impostor?**, com estilo visual Win95.

## Estrutura

```text
quem_e_o_impostor/
  backend/
  frontend/
```

## Stack

- **Backend:** Node.js + Express + CORS
- **Frontend:** Flutter (Material)
- **Persistencia local:** SharedPreferences
- **HTTP client:** `http`
- **Audio:** `audioplayers`

## Backend

Pasta: [`backend`](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/backend)

### Rotas

- `GET /`
- `GET /categorias`
- `GET /dica?categoria=Comidas`
- fallback `404`:

```json
{ "erro": "Rota nao encontrada" }
```

### Rodar backend

```bash
cd backend
npm install
npm start
```

Servidor sobe em: `http://localhost:3000`

## Frontend (Flutter)

Pasta: [`frontend`](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend)

### URL da API

Configurada em [`configuracao_api.dart`](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/core/services/configuracao_api.dart):

- Padrao (emulador Android): `http://10.0.2.2:3000`
- Pode sobrescrever com `--dart-define=API_BASE_URL=...`

### Rodar no emulador Android

```bash
cd frontend
flutter pub get
flutter run
```

> Importante: o backend precisa estar rodando na porta `3000`.

### Rodar em celular Android fisico (mesma rede Wi-Fi)

1. **Mac/PC e celular precisam estar na mesma rede Wi-Fi** (evite rede Guest/isolada).
2. Suba o backend:

```bash
cd backend
npm start
```

3. Descubra o IP local do seu computador (ex.: `192.168.0.20`).
4. No celular, teste no navegador:

```text
http://192.168.0.20:3000
```

Se abrir o JSON da API, a rede esta ok.

5. Rode o app Flutter apontando para esse IP com `--dart-define`:

```bash
flutter run --dart-define=API_BASE_URL=http://192.168.0.20:3000
```

> `10.0.2.2` funciona apenas no emulador Android.  
> Em celular fisico, use sempre `http://IP_DO_COMPUTADOR:3000`.

6. Se nao conectar, verifique:
- firewall liberando a porta `3000`;
- celular e computador na mesma sub-rede;
- roteador sem isolamento entre clientes Wi-Fi.

## Fluxo do jogo

1. Cadastrar jogadores
2. Carregar categorias da API
3. Sortear categoria/palavra/impostor
4. Revelacao secreta por jogador (flip card)
5. Discussao
6. Resultado
7. Salvamento no historico local

## Persistencia local (SharedPreferences)

- `ultimos_jogadores`
- `historico_partidas`
- `tema_escuro`
- chaves de demo (atividade API + persistencia)

## Telas principais

- Home
- Jogadores (estilo terminal)
- Configuracao da partida
- Revelacao
- Discussao
- Resultado
- Historico
- Configuracoes
- Atividade Layout
- Atividade Eventos
- Atividade API + Persistencia

## Detalhamento das telas de atividade

### 1) Atividade de Layout Responsivo

- **Tela:** [pagina_atividade_layout.dart](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/features/activities/presentation/pagina_atividade_layout.dart)
- **Objetivo:** demonstrar estrutura de widgets e responsividade minima.
- **O que ela mostra:**
  - 3 secoes visuais (cabecalho, conteudo e acoes);
  - uso de `Column`/`Row`, `Expanded`/`Flexible`, `Padding`/`SizedBox`;
  - troca de layout por largura com `LayoutBuilder`:
    - `< 600`: layout mobile;
    - `>= 600`: layout wide.
- **Observacao:** tela didatica, sem API e sem persistencia.

### 2) Atividade de Tratamento de Eventos

- **Tela:** [pagina_atividade_eventos.dart](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/features/activities/presentation/pagina_atividade_eventos.dart)
- **Objetivo:** demonstrar ciclo de eventos (acao -> processamento -> feedback).
- **Eventos implementados:**
  - `TextField` com `onChanged` e validacao em tempo real (minimo 3 caracteres);
  - botao **Adicionar jogador** com `onPressed` condicional;
  - botao **Limpar lista** com confirmacao via `AlertDialog`;
  - area de gesto com `InkWell`:
    - `onTap` (SnackBar com dica);
    - `onLongPress` (AlertDialog com regras).
- **Encadeamento:** ao adicionar o 3o jogador, dispara automaticamente dialogo de minimo atingido.

### 3) Atividade de API + Persistencia Local

- **Tela:** [pagina_atividade_api_persistencia.dart](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/features/activities/presentation/pagina_atividade_api_persistencia.dart)
- **Objetivo:** comprovar consumo de API e armazenamento local no dispositivo.
- **Bloco API:**
  - busca categorias no backend (`GET /categorias`);
  - trata loading, sucesso e erro amigavel.
- **Bloco Persistencia Local:**
  - salva, carrega e limpa anotacao de teste com `SharedPreferences`;
  - feedback visual com `SnackBar`.
- **Servicos relacionados:**
  - [servico_api_palavra.dart](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/core/services/servico_api_palavra.dart)
  - [servico_armazenamento.dart](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/core/services/servico_armazenamento.dart)

## Comandos uteis

### Backend

```bash
cd backend
npm start
```

### Frontend

```bash
cd frontend
flutter pub get
flutter analyze
flutter test
flutter run
```
