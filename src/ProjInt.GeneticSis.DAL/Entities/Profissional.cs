using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("profissionais")]
    public class Profissional
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Required]
        [StringLength(150)]
        [Column("nome")]
        public string Nome { get; set; } = string.Empty;

        [StringLength(20)]
        [Column("telefone")]
        public string? Telefone { get; set; }

        [StringLength(150)]
        [Column("email")]
        public string? Email { get; set; }

        [StringLength(7)]
        [Column("cor_agenda")]
        public string CorAgenda { get; set; } = "#6f42c1";

        [Column("ativo")]
        public bool Ativo { get; set; }

        [StringLength(500)]
        [Column("observacoes")]
        public string? Observacoes { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }

        public virtual Usuario? Usuario { get; set; }
    }
}
