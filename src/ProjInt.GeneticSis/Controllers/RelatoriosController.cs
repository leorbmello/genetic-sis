using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjInt.GeneticSis.DAL;
using ProjInt.GeneticSis.Models;
using System.Security.Claims;

namespace ProjInt.GeneticSis.Controllers
{
    [Authorize]
    public class RelatoriosController : Controller
    {
        private readonly AppDbContext context;

        public RelatoriosController(AppDbContext context)
        {
            this.context = context;
        }

        public IActionResult Index()
        {
            return View();
        }

        /// <summary>
        /// Relatório de Atendimentos
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> Atendimentos(DateOnly inicio, DateOnly fim)
        {
            var role = User.FindFirst(ClaimTypes.Role)?.Value;
            var profissionalIdClaim = User.FindFirst("ProfissionalId")?.Value;
            ulong? profissionalId = null;
            if (!string.IsNullOrEmpty(profissionalIdClaim))
            {
                profissionalId = Convert.ToUInt64(profissionalIdClaim);
            }

            var query = context.Agendamentos
                .Include(x => x.Cliente)
                .Include(x => x.Servico)
                .Include(x => x.Profissional)
                .Where(x =>
                    x.DataAtendimento >= inicio &&
                    x.DataAtendimento <= fim)
                .AsQueryable();

            if (role != "ADMIN" && profissionalId.HasValue)
            {
                query = query.Where(x => x.ProfissionalId == profissionalId.Value);
            }

            var lista = await query
                .OrderBy(x => x.DataAtendimento)
                .ThenBy(x => x.HoraInicio)
                .ToListAsync();

            var model = new RelatorioAtendimentosViewModel
            {
                Inicio = inicio,
                Fim = fim,
                TotalAtendimentos = lista.Count,
                TotalConcluidos = lista.Count(x => x.Status == "CONCLUIDO"),
                TotalCancelados = lista.Count(x => x.Status == "CANCELADO"),
                Agendamentos = lista
            };

            return View(model);
        }

        /// <summary>
        /// Relatório financeiro
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> Financeiro(DateOnly inicio, DateOnly fim)
        {
            var role = User.FindFirst(ClaimTypes.Role)?.Value;
            var profissionalIdClaim = User.FindFirst("ProfissionalId")?.Value;
            ulong? profissionalId = null;
            if (!string.IsNullOrEmpty(profissionalIdClaim))
            {
                profissionalId = Convert.ToUInt64(profissionalIdClaim);
            }

            var query = context.Agendamentos
                .Include(x => x.Cliente)
                .Include(x => x.Servico)
                .Include(x => x.Profissional)
                .Where(x =>
                    x.DataAtendimento >= inicio &&
                    x.DataAtendimento <= fim &&
                    x.Status == "CONCLUIDO")
                .AsQueryable();

            if (role != "ADMIN" && profissionalId.HasValue)
            {
                query = query.Where(x => x.ProfissionalId == profissionalId.Value);
            }

            var lista = await query
                .OrderBy(x => x.DataAtendimento)
                .ThenBy(x => x.HoraInicio)
                .ToListAsync();

            decimal total = lista.Sum(x => x.ValorCobrado ?? 0);
            var model = new RelatorioFinanceiroViewModel
            {
                Inicio = inicio,
                Fim = fim,
                TotalAtendimentos = lista.Count,
                FaturamentoTotal = total,
                TicketMedio = lista.Count > 0 ? total / lista.Count : 0,
                Agendamentos = lista
            };

            return View(model);
        }
    }
}
