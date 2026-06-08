package fitlife.api.controller;

import fitlife.api.dto.TreinoDTO.TreinoRequest;
import fitlife.api.dto.TreinoDTO.TreinoResponse;
import fitlife.api.service.TreinoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.UUID;

@RestController
@RequestMapping("/api/treinos")
public class TreinoController {

    private final TreinoService treinoService;

    public TreinoController(TreinoService treinoService) {
        this.treinoService = treinoService;
    }

    @PostMapping
    public ResponseEntity<TreinoResponse> registarTreino(@RequestBody TreinoRequest request) {
        TreinoResponse response = treinoService.criarTreino(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    @GetMapping("/usuario/{usuarioId}")
    public ResponseEntity<List<TreinoResponse>> listarPorUsuario(@PathVariable UUID usuarioId) {
        return ResponseEntity.ok(treinoService.listarTreinosDoUsuario(usuarioId));
    }
}