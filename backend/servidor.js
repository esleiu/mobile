const express = require('express');
const cors = require('cors');

const app = express();
const PORT = 3000;

const categorias = [
  {
    id: 1,
    nome: 'Comidas',
    palavras: ['Pizza', 'Hamburguer', 'Sushi', 'Lasanha', 'Cuscuz', 'Tapioca'],
  },
  {
    id: 2,
    nome: 'Lugares',
    palavras: ['Praia', 'Shopping', 'Cinema', 'Escola', 'Aeroporto', 'Restaurante'],
  },
  {
    id: 3,
    nome: 'Objetos',
    palavras: ['Celular', 'Mochila', 'Cadeira', 'Relogio', 'Caneta', 'Notebook'],
  },
  {
    id: 4,
    nome: 'Animais',
    palavras: ['Cachorro', 'Gato', 'Leao', 'Tubarao', 'Elefante', 'Macaco'],
  },
  {
    id: 5,
    nome: 'Profissoes',
    palavras: ['Professor', 'Medico', 'Motorista', 'Programador', 'Cozinheiro', 'Designer'],
  },
  {
    id: 6,
    nome: 'Filmes e Series',
    palavras: ['Shrek', 'Titanic', 'Avatar', 'Barbie', 'Vingadores', 'Harry Potter'],
  },
];

const dicasPorCategoria = {
  Comidas: [
    'Tem cheiro e costuma aparecer em mesa de refeicao.',
    'Voce provavelmente ja pediu isso em delivery.',
    'E algo que as pessoas costumam comer, nao beber.',
  ],
  Lugares: [
    'E um local que normalmente recebe pessoas durante o dia.',
    'Pode ser um lugar fechado ou aberto, dependendo do caso.',
    'Voce consegue chegar nesse lugar sem passaporte.',
  ],
  Objetos: [
    'Da para pegar com as maos na maioria dos casos.',
    'Normalmente fica dentro de casa, escola ou trabalho.',
    'Nao e um ser vivo, e algo de uso cotidiano.',
  ],
  Animais: [
    'E um ser vivo do reino animal.',
    'Pode ser visto em casa, zoologico ou natureza.',
    'Tem comportamento proprio e nao e um objeto.',
  ],
  Profissoes: [
    'Depende de uma atividade de trabalho.',
    'Geralmente exige rotina, responsabilidades e tarefas.',
    'Esta relacionada a uma ocupacao profissional.',
  ],
  'Filmes e Series': [
    'E um titulo conhecido de audiovisual.',
    'Voce pode encontrar em cinema, TV ou streaming.',
    'As pessoas discutem personagens e enredo sobre isso.',
  ],
};

app.use(cors());

app.get('/', (_req, res) => {
  res.json({
    mensagem: 'API do jogo Quem e o Impostor esta funcionando',
    rotas: ['/categorias', '/dica?categoria=Comidas'],
  });
});

app.get('/categorias', (_req, res) => {
  res.json(categorias);
});

app.get('/dica', (req, res) => {
  const categoria = req.query.categoria;
  if (typeof categoria !== 'string' || categoria.trim().length === 0) {
    return res.status(400).json({
      erro: 'Informe a categoria na query. Exemplo: /dica?categoria=Comidas',
    });
  }

  const dicas = dicasPorCategoria[categoria];
  if (!dicas || dicas.length === 0) {
    return res.status(404).json({
      erro: 'Categoria nao encontrada para gerar dica',
    });
  }

  const indiceAleatorio = Math.floor(Math.random() * dicas.length);
  return res.json({
    categoria,
    dica: dicas[indiceAleatorio],
  });
});

app.use((_req, res) => {
  res.status(404).json({ erro: 'Rota nao encontrada' });
});

app.listen(PORT, () => {
  console.log(`API rodando na porta ${PORT}`);
});
