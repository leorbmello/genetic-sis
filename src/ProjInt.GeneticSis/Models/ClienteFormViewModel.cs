using System.ComponentModel.DataAnnotations;

namespace ProjInt.GeneticSis.Models
{
    public class ClienteFormViewModel
    {
        public ulong Id { get; set; }

        [Required(ErrorMessage = "Informe o nome.")]
        [StringLength(120)]
        public string Nome { get; set; } = string.Empty;

        [Required(ErrorMessage = "Informe o telefone.")]
        [StringLength(20)]
        public string Telefone { get; set; } = string.Empty;

        [StringLength(120)]
        public string? Email { get; set; }

        [StringLength(500)]
        public string? Observacoes { get; set; }
    }
}
