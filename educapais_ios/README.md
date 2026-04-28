# EducaPais iOS (SwiftUI)

Projeto Swift + SwiftUI em pasta separada, fiel ao visual da referência e adaptado ao contexto escolar.

## Recursos implementados

- `NavigationStack + TabView` (3 abas):
  - Boletim
  - Frequencia
  - Comunicados
- login fixo:
  - email: `pai@email.com`
  - senha: `123456`
- tela de selecao de filho imediatamente apos login, com aviso de troca posterior
- troca de filho a qualquer momento no topo do dashboard
- consumo HTTP da API:
  `https://69effdd0112e1b968e251fe2.mockapi.io/api/educapais`
- persistencia local com `UserDefaults`
- funcionamento offline apos primeira carga
- estilo iOS moderno com uso de blur/transparencia (`.ultraThinMaterial`)

## Estrutura principal

```text
educapais_ios/
  EducaPais/
    EducaPaisApp.swift
    Models/SchoolModels.swift
    Services/
      APIService.swift
      CacheService.swift
      SessionViewModel.swift
    Theme/AppColors.swift
    Views/
      RootView.swift
      LoginView.swift
      ChildSelectionView.swift
      DashboardView.swift
      Components/
        GlassCard.swift
        ChildAvatar.swift
      Tabs/
        BoletimView.swift
        FrequenciaView.swift
        ComunicadosView.swift
```

## Como rodar no Xcode

1. No macOS, abra o Xcode e crie um novo projeto:
   - iOS App
   - Nome: `EducaPais`
   - Interface: `SwiftUI`
   - Language: `Swift`
2. Substitua os arquivos Swift criados pelo conteúdo da pasta:
   `educapais_ios/EducaPais/`
3. Garanta deployment target iOS 17+ (recomendado para recursos visuais modernos).
4. Execute no simulador iPhone.
