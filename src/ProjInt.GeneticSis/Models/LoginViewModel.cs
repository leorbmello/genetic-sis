using System.ComponentModel.DataAnnotations;

namespace ProjInt.GeneticSis.Models
{
    public class LoginViewModel
    {
        [Required(ErrorMessage = "Informe o e-mail")]
        [EmailAddress(ErrorMessage = "E-mail inválido")]
        public string Email { get; set; } = string.Empty;

        [Required(ErrorMessage = "Informe a senha")]
        public string Senha { get; set; } = string.Empty;

        public bool LembrarMe { get; set; }
    }
}
