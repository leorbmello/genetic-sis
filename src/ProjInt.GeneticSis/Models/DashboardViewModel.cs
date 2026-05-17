namespace ProjInt.GeneticSis.Models
{
    public class DashboardCardViewModel
    {
        public ulong AgendamentoId { get; set; }
        public string Cliente { get; set; } = string.Empty;
        public string Servico { get; set; } = string.Empty;
        public string Profissional { get; set; } = string.Empty;
        public TimeOnly HoraInicio { get; set; }
        public TimeOnly HoraFim { get; set; }
        public string StatusVisual { get; set; } = "pending";
        public bool Atrasado { get; set; }
        public DateOnly Data { get; set; }
    }
}
