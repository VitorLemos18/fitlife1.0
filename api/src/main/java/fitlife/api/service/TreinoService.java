package fitlife.api.service;

import fitlife.api.dto.TreinoDTO.*;
import fitlife.api.models.Exercicio;
import fitlife.api.models.Treino;
import fitlife.api.models.Usuario;
import fitlife.api.repository.TreinoRepository;
import fitlife.api.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class TreinoService {

    private final TreinoRepository treinoRepository;
    private final UsuarioRepository usuarioRepository;

    public TreinoService(TreinoRepository treinoRepository, UsuarioRepository usuarioRepository) {
        this.treinoRepository = treinoRepository;
        this.usuarioRepository = usuarioRepository;
    }

    @Transactional
    public TreinoResponse criarTreino(TreinoRequest request) {
        // 1. Vai buscar o utilizador à base de dados
        Usuario usuario = usuarioRepository.findById(request.usuarioId())
                .orElseThrow(() -> new RuntimeException("Utilizador não encontrado"));

        // 2. Cria o Treino
        Treino treino = new Treino();
        treino.setUsuario(usuario);
        treino.setTitulo(request.titulo());
        treino.setData(request.data());
        treino.setDuracaoMinutos(request.duracaoMinutos());
        treino.setConcluido(false);

        // 3. Converte os Exercícios recebidos e associa-os ao Treino
        List<Exercicio> exercicios = request.exercicios().stream().map(dto -> {
            Exercicio ex = new Exercicio();
            ex.setNome(dto.nome());
            ex.setSeries(dto.series());
            ex.setRepeticoes(dto.repeticoes());
            ex.setCargaKg(dto.cargaKg());
            ex.setTreino(treino); // Relação muito importante para a base de dados!
            return ex;
        }).collect(Collectors.toList());

        treino.setExercicios(exercicios);

        // 4. Grava tudo na base de dados (O Hibernate grava o Treino e os Exercícios em cascata)
        Treino treinoGuardado = treinoRepository.save(treino);

        // 5. Devolve a resposta limpa para a App
        return mapearParaResponse(treinoGuardado);
    }

    public List<TreinoResponse> listarTreinosDoUsuario(UUID usuarioId) {
        return treinoRepository.findByUsuarioId(usuarioId).stream()
                .map(this::mapearParaResponse)
                .collect(Collectors.toList());
    }

    private TreinoResponse mapearParaResponse(Treino treino) {
        List<ExercicioResponse> exerciciosResponse = treino.getExercicios().stream()
                .map(ex -> new ExercicioResponse(ex.getId(), ex.getNome(), ex.getSeries(), ex.getRepeticoes(), ex.getCargaKg()))
                .collect(Collectors.toList());

        return new TreinoResponse(treino.getId(), treino.getTitulo(), treino.getData(), treino.getDuracaoMinutos(), treino.isConcluido(), exerciciosResponse);
    }
}