package fitlife.api.service;

import org.springframework.stereotype.Service;

import fitlife.api.dto.UsuarioRequestDTO;
import fitlife.api.dto.UsuarioResponseDTO;
import fitlife.api.models.Usuario;
import fitlife.api.repository.UsuarioRepository;

@Service
public class UsuarioService {

    private final UsuarioRepository repository;

    public UsuarioService(UsuarioRepository repository) {
        this.repository = repository;
    }

    public UsuarioResponseDTO criar(UsuarioRequestDTO dto) {
        Usuario usuario = new Usuario();

        usuario.setNome(dto.nome());
        usuario.setEmail(dto.email());
        usuario.setSenha(dto.senha());
        usuario.setRole(dto.role());
        usuario.setTelefone(dto.telefone());
        usuario.setObjetivo(dto.objetivo());
        usuario.setPeso(dto.peso());
        usuario.setAltura(dto.altura());
        usuario.setDataNascimento(dto.dataNascimento());
        usuario.setExtra1(dto.extra1());
        usuario.setExtra2(dto.extra2());
        usuario.setExtra3(dto.extra3());

        usuario = repository.save(usuario);

        Double imc = calcularImc(usuario.getPeso(), usuario.getAltura());

        return new UsuarioResponseDTO(
            usuario.getId(),
            usuario.getNome(),
            usuario.getEmail(),
            usuario.getRole(),
            usuario.getTelefone(),
            usuario.getObjetivo(),
            usuario.getPeso(),
            usuario.getAltura(),
            usuario.getDataNascimento(),
            usuario.getExtra1(),
            usuario.getExtra2(),
            usuario.getExtra3(),
            imc
        );
    }

    private Double calcularImc(Double peso, Double altura) {
        if (peso == null || altura == null || altura <= 0) {
            return null;
        }

        return peso / (altura * altura);
    }
}