using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("clientes")]
    public class Cliente
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Required]
        [StringLength(150)]
        [Column("nome")]
        public string Nome { get; set; } = string.Empty;

        [StringLength(20)]
        [Column("celular")]
        public string? Celular { get; set; }

        [StringLength(150)]
        [Column("email")]
        public string? Email { get; set; }

        [Column("data_nascimento")]
        public DateOnly? DataNascimento { get; set; }

        [StringLength(500)]
        [Column("observacoes")]
        public string? Observacoes { get; set; }

        [Column("ativo")]
        public bool Ativo { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }
    }
}
