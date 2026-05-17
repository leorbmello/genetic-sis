using ProjInt.GeneticSis.DAL.Entities;

namespace ProjInt.GeneticSis.Models
{
    public class RelatorioAtendimentosViewModel
    {
        public DateOnly Inicio { get; set; }
        public DateOnly Fim { get; set; }
        public int TotalAtendimentos { get; set; }
        public int TotalConcluidos { get; set; }
        public int TotalCancelados { get; set; }
        public List<Agendamento> Agendamentos { get; set; } = new();
    }
}
