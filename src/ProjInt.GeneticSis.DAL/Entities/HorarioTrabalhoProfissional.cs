using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("horarios_trabalho_profissional")]
    public class HorarioTrabalhoProfissional
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Column("profissional_id")]
        public ulong ProfissionalId { get; set; }

        [Column("dia_semana")]
        public byte DiaSemana { get; set; }

        [Column("hora_inicio")]
        public TimeOnly HoraInicio { get; set; }

        [Column("hora_fim")]
        public TimeOnly HoraFim { get; set; }

        [Column("intervalo_inicio")]
        public TimeOnly? IntervaloInicio { get; set; }

        [Column("intervalo_fim")]
        public TimeOnly? IntervaloFim { get; set; }

        [Column("ativo")]
        public bool Ativo { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }

        [ForeignKey(nameof(ProfissionalId))]
        public virtual Profissional Profissional { get; set; } = null!;
    }
}
