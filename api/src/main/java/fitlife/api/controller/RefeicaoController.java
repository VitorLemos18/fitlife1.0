package fitlife.api.controller;

import fitlife.api.dto.RefeicaoDTO.RefeicaoRequest;
import fitlife.api.dto.RefeicaoDTO.RefeicaoResponse;
import fitlife.api.service.RefeicaoService;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/refeicoes")
public class RefeicaoController {

    private final RefeicaoService refeicaoService;

    public RefeicaoController(RefeicaoService refeicaoService) {
        this.refeicaoService = refeicaoService;
    }

    @PostMapping
    public ResponseEntity<RefeicaoResponse> registar(@RequestBody RefeicaoRequest request) {
        return ResponseEntity.status(HttpStatus.CREATED).body(refeicaoService.registarRefeicao(request));
    }
}