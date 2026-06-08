package fitlife.api.exception;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;

@ControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(RuntimeException.class)
    public ResponseEntity<String> handleRuntimeException(RuntimeException ex) {
        // Devolve o erro de forma limpa, em vez de mostrar o stack trace gigante
        return ResponseEntity.badRequest().body("Erro: " + ex.getMessage());
    }
}