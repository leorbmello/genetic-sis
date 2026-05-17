using Microsoft.EntityFrameworkCore;
using ProjInt.GeneticSis.DAL.Entities;

namespace ProjInt.GeneticSis.DAL
{
    public class AppDbContext : DbContext
    {
        public AppDbContext(DbContextOptions<AppDbContext> options)
            : base(options)
        {
        }

        public DbSet<Usuario> Usuarios => Set<Usuario>();

        public DbSet<Profissional> Profissionais => Set<Profissional>();

        public DbSet<Cliente> Clientes => Set<Cliente>();

        public DbSet<Servico> Servicos => Set<Servico>();

        public DbSet<Agendamento> Agendamentos => Set<Agendamento>();

        public DbSet<HorarioTrabalhoProfissional> HorariosTrabalhoProfissional => Set<HorarioTrabalhoProfissional>();

        public DbSet<BloqueioAgenda> BloqueiosAgenda => Set<BloqueioAgenda>();

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            base.OnModelCreating(modelBuilder);
        }
    }
}
