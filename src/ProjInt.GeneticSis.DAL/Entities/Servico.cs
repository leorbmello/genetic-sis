using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace ProjInt.GeneticSis.DAL.Entities
{
    [Table("servicos")]
    public class Servico
    {
        [Key]
        [Column("id")]
        public ulong Id { get; set; }

        [Required]
        [StringLength(150)]
        [Column("nome")]
        public string Nome { get; set; } = string.Empty;

        [StringLength(300)]
        [Column("descricao")]
        public string? Descricao { get; set; }

        [Column("duracao_minutos")]
        public uint DuracaoMinutos { get; set; }

        [Column("valor_base")]
        public decimal? ValorBase { get; set; }

        [StringLength(7)]
        [Column("cor_agenda")]
        public string CorAgenda { get; set; } = "#0d6efd";

        [Column("ativo")]
        public bool Ativo { get; set; }

        [Column("created_at")]
        public DateTime CreatedAt { get; set; }

        [Column("updated_at")]
        public DateTime UpdatedAt { get; set; }
    }
}
