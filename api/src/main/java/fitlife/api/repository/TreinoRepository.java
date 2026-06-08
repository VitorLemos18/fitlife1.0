package fitlife.api.repository;

import fitlife.api.models.Treino;
import org.springframework.data.jpa.repository.JpaRepository;
import java.util.List;
import java.util.UUID;

public interface TreinoRepository extends JpaRepository<Treino, UUID> {
    List<Treino> findByUsuarioId(UUID usuarioId); // Método mágico do Spring para buscar treinos de um utilizador
}