package fitlife.api.dto;

import java.time.LocalDate;
import java.util.UUID;

import fitlife.api.models.UserRole;

public record UsuarioResponseDTO(
    UUID id,
    String nome,
    String email,
    UserRole role,
    String telefone,
    String objetivo,
    Double peso,
    Double altura,
    LocalDate dataNascimento,
    String extra1,
    String extra2,
    String extra3,
    Double imc
) {}