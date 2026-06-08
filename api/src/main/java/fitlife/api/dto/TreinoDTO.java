package fitlife.api.dto;

import java.time.LocalDateTime;
import java.util.List;
import java.util.UUID;

public class TreinoDTO {
    // O que vem da App (Request)
    public record ExercicioRequest(String nome, int series, int repeticoes, double cargaKg) {}
    
    public record TreinoRequest(UUID usuarioId, String titulo, LocalDateTime data, int duracaoMinutos, List<ExercicioRequest> exercicios) {}

    // O que volta para a App (Response)
    public record ExercicioResponse(UUID id, String nome, int series, int repeticoes, double cargaKg) {}
    
    public record TreinoResponse(UUID id, String titulo, LocalDateTime data, int duracaoMinutos, boolean concluido, List<ExercicioResponse> exercicios) {}
}