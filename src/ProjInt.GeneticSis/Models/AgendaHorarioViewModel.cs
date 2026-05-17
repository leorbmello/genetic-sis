using ProjInt.GeneticSis.DAL.Entities;

namespace ProjInt.GeneticSis.Models
{
    public class AgendaHorarioViewModel
    {
        public TimeOnly Hora { get; set; }
        public bool Disponivel { get; set; }
        public Agendamento? Agendamento { get; set; }
    }
}
