using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjInt.GeneticSis.DAL;
using ProjInt.GeneticSis.Models;

namespace ProjInt.GeneticSis.Controllers
{
    [Authorize]
    public class HomeController : Controller
    {
        private readonly AppDbContext context;
        private readonly ILogger<HomeController> logger;

        public HomeController(AppDbContext context, ILogger<HomeController> logger)
        {
            this.context = context;
            this.logger = logger;
        }

        public async Task<IActionResult> Index(    DateOnly? data)
        {
            var hoje =                data ?? DateOnly.FromDateTime(DateTime.Now);
            var agora =                TimeOnly.FromDateTime(DateTime.Now);
            try
            {
                var agendamentos = await context.Agendamentos
                    .Include(x => x.Cliente)
                    .Include(x => x.Servico)
                    .Include(x => x.Profissional)
                    .Where(x =>
                        x.DataAtendimento == hoje &&
                        x.Status != "CONCLUIDO" &&
                        x.Status != "CANCELADO")
                    .OrderBy(x => x.HoraInicio)
                    .ToListAsync();

                var model = agendamentos
                    .Select(x =>
                    {
                        string statusVisual = "pending";
                        bool atrasado = false;
                        if (x.HoraFim.HasValue)
                        {
                            if (agora >= x.HoraInicio &&
                                agora <= x.HoraFim.Value)
                            {
                                statusVisual = "progress";
                            }
                            else if (agora > x.HoraFim.Value)
                            {
                                statusVisual = "late";
                                atrasado = true;
                            }
                        }

                        return new DashboardCardViewModel
                        {
                            AgendamentoId = x.Id,
                            Cliente = x.Cliente.Nome,
                            Servico = x.Servico.Nome,
                            Profissional = x.Profissional.Nome,
                            HoraInicio = x.HoraInicio,
                            HoraFim = x.HoraFim ?? x.HoraInicio,
                            StatusVisual = statusVisual,
                            Atrasado = atrasado,
                            Data = hoje
                        };
                    })
                    .ToList();

                ViewBag.DataSelecionada = hoje;

                return View(model);
            }
            catch (Exception ex)
            {
                logger.LogError(ex,
                    "Erro ao carregar dashboard");

                return View(new List<DashboardCardViewModel>());
            }
        }
    }
}
