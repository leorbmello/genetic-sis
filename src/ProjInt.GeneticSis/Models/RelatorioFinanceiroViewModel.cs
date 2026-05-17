using ProjInt.GeneticSis.DAL.Entities;

namespace ProjInt.GeneticSis.Models
{
    public class RelatorioFinanceiroViewModel
    {
        public DateOnly Inicio { get; set; }
        public DateOnly Fim { get; set; }
        public int TotalAtendimentos { get; set; }
        public decimal FaturamentoTotal { get; set; }
        public decimal TicketMedio { get; set; }
        public List<Agendamento> Agendamentos { get; set; } = new();
    }
}