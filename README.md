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

Configurada em [`api_config.dart`](C:/Users/bbbrr/Downloads/teste/quem_e_o_impostor/frontend/lib/core/services/api_config.dart):

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

Se abrir o JSON da API, a rede está ok.

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
