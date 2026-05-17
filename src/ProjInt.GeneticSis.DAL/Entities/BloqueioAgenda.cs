using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("bloqueios_agenda")]
    public class BloqueioAgenda
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Column("profissional_id")]
        public ulong ProfissionalId { get; set; }

        [Column("data_bloqueio")]
        public DateOnly DataBloqueio { get; set; }

        [Column("hora_inicio")]
        public TimeOnly HoraInicio { get; set; }

        [Column("hora_fim")]
        public TimeOnly HoraFim { get; set; }

        [Required]
        [StringLength(200)]
        [Column("motivo")]
        public string Motivo { get; set; } = string.Empty;

        [Required]
        [StringLength(50)]
        [Column("tipo_bloqueio")]
        public string TipoBloqueio { get; set; } = string.Empty;

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }

        [ForeignKey(nameof(ProfissionalId))]
        public virtual Profissional Profissional { get; set; } = null!;
    }
}
