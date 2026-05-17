using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("agendamentos")]
    public class Agendamento
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Column("cliente_id")]
        public ulong? ClienteId { get; set; }

        [Column("profissional_id")]
        public ulong ProfissionalId { get; set; }

        [Column("servico_id")]
        public ulong? ServicoId { get; set; }

        [Column("data_atendimento")]
        public DateOnly DataAtendimento { get; set; }

        [Column("hora_inicio")]
        public TimeOnly HoraInicio { get; set; }

        [Column("hora_fim")]
        public TimeOnly? HoraFim { get; set; }

        [Column("duracao_minutos")]
        public uint? DuracaoMinutos { get; set; }

        [Column("valor_cobrado")]
        public decimal? ValorCobrado { get; set; }

        [Required]
        [StringLength(20)]
        [Column("status")]
        public string Status { get; set; } = string.Empty;

        [Required]
        [StringLength(20)]
        [Column("origem_agendamento")]
        public string OrigemAgendamento { get; set; } = string.Empty;

        [Required]
        [StringLength(20)]
        [Column("canal_agendamento")]
        public string CanalAgendamento { get; set; } = string.Empty;

        [StringLength(500)]
        [Column("observacoes")]
        public string? Observacoes { get; set; }

        [StringLength(250)]
        [Column("motivo_cancelamento")]
        public string? MotivoCancelamento { get; set; }

        [Column("criado_por_usuario_id")]
        public ulong? CriadoPorUsuarioId { get; set; }

        [Column("confirmado_em")]
        public DateTime? ConfirmadoEm { get; set; }

        [Column("concluido_em")]
        public DateTime? ConcluidoEm { get; set; }

        [Column("cancelado_em")]
        public DateTime? CanceladoEm { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }

        [ForeignKey(nameof(ClienteId))]
        public virtual Cliente? Cliente { get; set; }

        [ForeignKey(nameof(ProfissionalId))]
        public virtual Profissional Profissional { get; set; } = null!;

        [ForeignKey(nameof(ServicoId))]
        public virtual Servico? Servico { get; set; }

        [ForeignKey(nameof(CriadoPorUsuarioId))]
        public virtual Usuario? CriadoPorUsuario { get; set; }
    }
}