using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("usuarios")]
    public class Usuario
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Required]
        [StringLength(150)]
        [Column("nome")]
        public string Nome { get; set; } = string.Empty;

        [Required]
        [StringLength(150)]
        [Column("email")]
        public string Email { get; set; } = string.Empty;

        [Required]
        [Column("senha_hash")]
        public string SenhaHash { get; set; } = string.Empty;

        [Required]
        [StringLength(20)]
        [Column("perfil")]
        public string Perfil { get; set; } = string.Empty;

        [Column("profissional_id")]
        public ulong? ProfissionalId { get; set; }

        [Column("ativo")]
        public bool Ativo { get; set; }

        [Column("ultimo_login_em")]
        public DateTime? UltimoLoginEm { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }

        [ForeignKey(nameof(ProfissionalId))]
        public virtual Profissional? Profissional { get; set; }
    }
}
