using ProjInt.GeneticSis.DAL.Entities;

namespace ProjInt.GeneticSis.Models
{
    public class AgendaViewModel
    {
        public ulong ProfissionalId { get; set; }
        public DateOnly Data { get; set; }
        public List<Profissional> Profissionais { get; set; } = new();
        public List<AgendaHorarioViewModel> Horarios { get; set; } = new();
    }
}
