using ProjInt.GeneticSis.DAL.Entities;
using System.ComponentModel.DataAnnotations;

namespace ProjInt.GeneticSis.Models
{
    public class NovoAgendamentoViewModel
    {
        public ulong ProfissionalId { get; set; }
        [Required]
        public ulong ClienteId { get; set; }
        [Required]
        public ulong ServicoId { get; set; }
        public DateOnly Data { get; set; }
        public TimeOnly HoraInicio { get; set; }
        [StringLength(500)]
        public string? Observacoes { get; set; }
        public List<Cliente> Clientes { get; set; } = new();
        public List<Servico> Servicos { get; set; } = new();
    }
}
