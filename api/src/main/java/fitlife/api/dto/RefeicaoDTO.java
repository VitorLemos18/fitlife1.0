package fitlife.api.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class RefeicaoDTO {
    public record ItemRequest(String nome, double porcaoGramas, int calorias) {}
    
    public record RefeicaoRequest(UUID usuarioId, String tipoRefeicao, LocalDateTime dataHora, List<ItemRequest> itens) {}

    public record ItemResponse(UUID id, String nome, double porcaoGramas, int calorias) {}
    
    public record RefeicaoResponse(UUID id, String tipoRefeicao, LocalDateTime dataHora, int caloriasTotais, List<ItemResponse> itens) {}
}