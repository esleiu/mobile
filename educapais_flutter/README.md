# EducaPais Flutter

Projeto Flutter (Dart + Material 3) inspirado no layout da referencia, com:

- login fixo (`pai@email.com` / `123456`)
- selecao obrigatoria de filho logo apos login
- troca de filho a qualquer momento no topo do app
- abas `Boletim`, `Frequencia`, `Comunicados` com `NavigationBar`
- consumo da API:
  `https://69effdd0112e1b968e251fe2.mockapi.io/api/educapais`
- cache offline usando `shared_preferences`

## Rodar

1. Entre na pasta:
   `cd educapais_flutter`
2. Instale dependencias:
   `flutter pub get`
3. Execute:
   `flutter run`

## Estrutura principal

```text
lib/
  controllers/session_controller.dart
  models/school_data.dart
  services/
    api_service.dart
    data_repository.dart
    storage_service.dart
  theme/app_theme.dart
  views/
    login_page.dart
    child_selection_page.dart
    dashboard_page.dart
    tabs/
      boletim_tab.dart
      frequencia_tab.dart
      comunicados_tab.dart
```
