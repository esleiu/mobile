class ActivityDemoStorageKeys {
  static const String apiLastFetchAt = 'demo_api_last_fetch_at';
  static const String localNote = 'demo_local_note';
}

class ActivityDemoTexts {
  static const String pageTitle = 'Exemplo API + Persistencia';
  static const String screenHeading =
      'Exemplo de Persistencia Local e Consumo da API';
  static const String screenDescription =
      'Esta tela prova o escopo academico: buscar dados de uma API e salvar dados localmente no dispositivo.';

  static const String apiCardTitle = 'Bloco API';
  static const String apiCardDescription =
      'Busca categorias do backend local em http://10.0.2.2:3000/categorias.';
  static const String apiFetchButton = 'Buscar categorias';
  static const String apiLoadingLabel = 'Carregando categorias...';
  static const String apiErrorPrefix = 'Erro na API:';
  static const String apiResultCountPrefix = 'Categorias carregadas:';
  static const String apiLastFetchPrefix = 'Ultima busca:';

  static const String persistenceCardTitle = 'Bloco Persistencia Local';
  static const String persistenceCardDescription =
      'Salva e recupera uma anotacao simples com SharedPreferences.';
  static const String noteFieldLabel = 'Anotacao de teste';
  static const String noteFieldHint =
      'Digite qualquer texto para salvar localmente';
  static const String saveButton = 'Salvar';
  static const String loadButton = 'Carregar';
  static const String clearButton = 'Limpar';

  static const String snackbarSaved = 'Anotacao salva localmente.';
  static const String snackbarLoaded = 'Anotacao carregada.';
  static const String snackbarCleared = 'Anotacao removida.';
  static const String noNoteLoaded = 'Nenhuma anotacao salva.';
  static const String currentNotePrefix = 'Valor atual:';
}
