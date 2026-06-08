package fitlife.api.dto;

import java.time.LocalDate;

import fitlife.api.models.UserRole;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Positive;

public record UsuarioRequestDTO(

    @NotBlank(message = "Nome obrigatório")
    String nome,

    @Email(message = "Email inválido")
    @NotBlank(message = "Email obrigatório")
    String email,

    @NotBlank(message = "Senha obrigatória")
    String senha,

    @NotNull(message = "Perfil obrigatório")
    UserRole role,

    @NotBlank(message = "Telefone obrigatório")
    String telefone,

    String objetivo,

    @Positive(message = "Peso deve ser positivo")
    Double peso,

    @Positive(message = "Altura deve ser positiva")
    Double altura,

    LocalDate dataNascimento,

    String extra1,
    String extra2,
    String extra3
) {}