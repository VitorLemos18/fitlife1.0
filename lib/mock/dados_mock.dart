import '../models/usuario.dart';
import '../models/treino.dart';

class DadosMock {

  static Usuario usuarioAtual = Usuario(
    nome: "Arthur Ribeiro",
    email: "usuario@fitlife.com",
    idade: 24,
    peso: 75.5,
    altura: 1.78,
    objetivo: "Ganho de massa muscular",
  );

  static List<Treino> treinos = [
    Treino(nome: "Supino Reto", grupoMuscular: "Peito", series: 4, repeticoes: 12),
    Treino(nome: "Crucifixo com Halteres", grupoMuscular: "Peito", series: 3, repeticoes: 15),
    Treino(nome: "Agachamento Livre", grupoMuscular: "Pernas", series: 4, repeticoes: 10),
    Treino(nome: "Leg Press 45º", grupoMuscular: "Pernas", series: 3, repeticoes: 12),
    Treino(nome: "Puxada Alta", grupoMuscular: "Costas", series: 4, repeticoes: 12),
    Treino(nome: "Remada Curvada", grupoMuscular: "Costas", series: 3, repeticoes: 10),
    Treino(nome: "Rosca Direta", grupoMuscular: "Braços", series: 3, repeticoes: 12),
    Treino(nome: "Tríceps na Polia", grupoMuscular: "Braços", series: 3, repeticoes: 15),
  ];

  static List<Map<String, String>> refeicoes = [
    {"titulo": "Café da Manhã", "descricao": "Ovos mexidos com aveia e frutas vermelhas."},
    {"titulo": "Almoço", "descricao": "Peito de frango grelhado, batata doce e brócolis."},
    {"titulo": "Lanche pré-treino", "descricao": "Banana com pasta de amendoim."},
    {"titulo": "Jantar", "descricao": "Filé de peixe assado com salada completa e azeite."},
  ];

  static List<String> metas = [
    "Perda de peso",
    "Ganho de massa muscular",
    "Melhorar condicionamento físico",
    "Aumentar frequência de treinos"
  ];

  static List<String> historicoPesos = ["77.0 kg", "76.2 kg", "75.5 kg"];
}