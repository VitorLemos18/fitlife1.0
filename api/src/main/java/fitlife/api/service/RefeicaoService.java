package fitlife.api.service;

import fitlife.api.dto.RefeicaoDTO.*;
import fitlife.api.models.ItemAlimentar;
import fitlife.api.models.Refeicao;
import fitlife.api.models.Usuario;
import fitlife.api.repository.RefeicaoRepository;
import fitlife.api.repository.UsuarioRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class RefeicaoService {

    private final RefeicaoRepository refeicaoRepository;
    private final UsuarioRepository usuarioRepository;

    public RefeicaoService(RefeicaoRepository refeicaoRepository, UsuarioRepository usuarioRepository) {
        this.refeicaoRepository = refeicaoRepository;
        this.usuarioRepository = usuarioRepository;
    }

    @Transactional
    public RefeicaoResponse registarRefeicao(RefeicaoRequest request) {
        Usuario usuario = usuarioRepository.findById(request.usuarioId())
                .orElseThrow(() -> new RuntimeException("Utilizador não encontrado"));

        Refeicao refeicao = new Refeicao();
        refeicao.setUsuario(usuario);
        refeicao.setTipoRefeicao(request.tipoRefeicao());
        refeicao.setDataHora(request.dataHora());

        List<ItemAlimentar> itens = request.itens().stream().map(dto -> {
            ItemAlimentar item = new ItemAlimentar();
            item.setNome(dto.nome());
            item.setPorcaoGramas(dto.porcaoGramas());
            item.setCalorias(dto.calorias());
            item.setRefeicao(refeicao);
            return item;
        }).collect(Collectors.toList());

        refeicao.setItens(itens);

        // Regra de Negócio: Calcula o total de calorias somando os itens
        int caloriasTotais = itens.stream().mapToInt(ItemAlimentar::getCalorias).sum();
        refeicao.setCaloriasTotais(caloriasTotais);

        Refeicao guardada = refeicaoRepository.save(refeicao);

        return mapearParaResponse(guardada);
    }

    private RefeicaoResponse mapearParaResponse(Refeicao refeicao) {
        List<ItemResponse> itensResponse = refeicao.getItens().stream()
                .map(item -> new ItemResponse(item.getId(), item.getNome(), item.getPorcaoGramas(), item.getCalorias()))
                .collect(Collectors.toList());

        return new RefeicaoResponse(refeicao.getId(), refeicao.getTipoRefeicao(), refeicao.getDataHora(), refeicao.getCaloriasTotais(), itensResponse);
    }
}