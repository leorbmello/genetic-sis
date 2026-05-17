using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjInt.GeneticSis.DAL;
using ProjInt.GeneticSis.DAL.Entities;
using ProjInt.GeneticSis.Models;

namespace ProjInt.GeneticSis.Controllers
{
    [Authorize]
    public class AgendaController : Controller
    {
        private readonly AppDbContext context;

        private ulong? GetProfissionalLogado()
        {
            var claim = User.FindFirst("ProfissionalId");
            if (claim == null)
                return null;

            return ulong.Parse(claim.Value);
        }

        public AgendaController(AppDbContext context)
        {
            this.context = context;
        }

        public async Task<IActionResult> Index(ulong? profissionalId, DateOnly? data)
        {
            var profissionais = await context.Profissionais
                .Where(x => x.Ativo)
                .OrderBy(x => x.Nome)
                .ToListAsync();

            if (profissionalId == null)
            {
                profissionalId = profissionais.FirstOrDefault()?.Id;
            }

            if (data == null)
            {
                data = DateOnly.FromDateTime(DateTime.Now);
            }

            var profissional = await context.Profissionais.FirstOrDefaultAsync(x => x.Id == profissionalId);
            if (profissional == null)
            {
                return RedirectToAction(nameof(Index));
            }

            // horários já agendados
            var agendamentos =
                await context.Agendamentos
                    .Include(x => x.Cliente)
                    .Include(x => x.Servico)
                    .Where(x =>
                        x.ProfissionalId == profissionalId &&
                        x.DataAtendimento == data &&
                        x.Status != "CANCELADO")
                    .OrderBy(x => x.HoraInicio)
                    .ToListAsync();

            // horário trabalho
            var diaSemana = (byte)((int)data.Value.DayOfWeek);
            var horario =
                await context.HorariosTrabalhoProfissional
                    .FirstOrDefaultAsync(x =>
                        x.ProfissionalId == profissionalId &&
                        x.DiaSemana == diaSemana &&
                        x.Ativo);

            var horarios = new List<AgendaHorarioViewModel>();
            if (horario != null)
            {
                var atual = horario.HoraInicio;
                while (atual < horario.HoraFim)
                {
                    var existe = agendamentos.Any(x => x.HoraInicio == atual);
                    var item = agendamentos.FirstOrDefault(x => x.HoraInicio == atual);
                    horarios.Add(new AgendaHorarioViewModel
                    {
                        Hora = atual,
                        Disponivel = !existe,
                        Agendamento = item
                    });

                    atual = atual.AddMinutes(60);
                }
            }

            var model = new AgendaViewModel
            {
                Data = data.Value,

                ProfissionalId = profissionalId.Value,
                Profissionais = profissionais,
                Horarios = horarios
            };

            return View(model);
        }
        [HttpGet]
        public async Task<IActionResult> Novo(ulong profissionalId, DateOnly data, TimeOnly hora)
        {
            var diaSemana = (byte)((int)data.DayOfWeek);
            var expediente = await context.HorariosTrabalhoProfissional
                    .FirstOrDefaultAsync(x =>
                        x.ProfissionalId == profissionalId &&
                        x.DiaSemana == diaSemana &&
                        x.Ativo);

            if (expediente == null)
            {
                TempData["ErroAgenda"] = "O profissional não possui expediente configurado para este dia.";
                return RedirectToAction(nameof(Index),
                    new
                    {
                        profissionalId,
                        data = data.ToString("yyyy-MM-dd")
                    });
            }

            if (hora < expediente.HoraInicio ||
                hora >= expediente.HoraFim)
            {
                TempData["ErroAgenda"] = "Horário fora do expediente do profissional.";
                return RedirectToAction(nameof(Index),
                    new
                    {
                        profissionalId,
                        data = data.ToString("yyyy-MM-dd")
                    });
            }

            var clientes = await context.Clientes
                .Where(x => x.Ativo)
                .OrderBy(x => x.Nome)
                .ToListAsync();

            var servicos = await context.Servicos
                .Where(x => x.Ativo)
                .OrderBy(x => x.Nome)
                .ToListAsync();

            var model = new NovoAgendamentoViewModel
            {
                ProfissionalId = profissionalId,
                Data = data,
                HoraInicio = hora,

                Clientes = clientes,
                Servicos = servicos
            };

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Novo(NovoAgendamentoViewModel model)
        {
            async Task CarregarCombos()
            {
                model.Clientes = await context.Clientes
                    .Where(x => x.Ativo)
                    .OrderBy(x => x.Nome)
                    .ToListAsync();

                model.Servicos = await context.Servicos
                    .Where(x => x.Ativo)
                    .OrderBy(x => x.Nome)
                    .ToListAsync();
            }

            if (!ModelState.IsValid)
            {
                await CarregarCombos();
                return View(model);
            }

            var servico = await context.Servicos
                .FirstOrDefaultAsync(x => x.Id == model.ServicoId);

            if (servico == null)
            {
                ModelState.AddModelError("", "Serviço inválido.");
                await CarregarCombos();
                return View(model);
            }

            var horaFim = model.HoraInicio.AddMinutes((double)servico.DuracaoMinutos);
            var diaSemana = (byte)((int)model.Data.DayOfWeek);
            var expediente = await context.HorariosTrabalhoProfissional
                    .FirstOrDefaultAsync(x =>
                        x.ProfissionalId == model.ProfissionalId &&
                        x.DiaSemana == diaSemana &&
                        x.Ativo);

            if (expediente == null)
            {
                ModelState.AddModelError("", "O profissional não possui expediente configurado para este dia.");
                await CarregarCombos();
                return View(model);
            }

            if (model.HoraInicio < expediente.HoraInicio ||
                horaFim > expediente.HoraFim)
            {
                ModelState.AddModelError("", "Horário fora do expediente do profissional.");
                await CarregarCombos();
                return View(model);
            }

            bool existe = await context.Agendamentos
                    .AnyAsync(x =>
                        x.ProfissionalId == model.ProfissionalId &&
                        x.DataAtendimento == model.Data &&
                        x.HoraInicio == model.HoraInicio &&
                        x.Status != "CANCELADO");
            if (existe)
            {
                ModelState.AddModelError("", "Horário já ocupado.");
                await CarregarCombos();
                return View(model);
            }

            var agendamento = new Agendamento
            {
                ClienteId = model.ClienteId,
                ProfissionalId = model.ProfissionalId,
                ServicoId = model.ServicoId,
                DataAtendimento = model.Data,
                HoraInicio = model.HoraInicio,
                HoraFim = horaFim,
                DuracaoMinutos = servico.DuracaoMinutos,
                ValorCobrado = servico.ValorBase,
                Status = "AGENDADO",
                OrigemAgendamento = "MANUAL",
                CanalAgendamento = "WEB",
                Observacoes = model.Observacoes,
                CreatedAt = DateTime.Now,
                UpdatedAt = DateTime.Now
            };

            context.Agendamentos.Add(agendamento);
            await context.SaveChangesAsync();
            TempData["SucessoAgenda"] = "Agendamento realizado com sucesso.";
            return RedirectToAction(nameof(Index),
                new
                {
                    profissionalId = model.ProfissionalId,
                    data = model.Data.ToString("yyyy-MM-dd")
                });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> BloquearHorario(ulong profissionalId, DateOnly data, TimeOnly hora)
        {
            var profissionalLogado = GetProfissionalLogado();
            if (profissionalLogado != profissionalId)
            {
                return Forbid();
            }

            var horaFim = hora.AddMinutes(30);
            var existe =
                await context.Agendamentos
                    .AnyAsync(x =>
                        x.ProfissionalId == profissionalId &&
                        x.DataAtendimento == data &&
                        x.Status != "CANCELADO" &&

                        (
                            hora < x.HoraFim &&
                            horaFim > x.HoraInicio
                        ));

            if (existe)
            {
                return RedirectToAction(nameof(Index),
                    new
                    {
                        profissionalId,
                        data = data.ToString("yyyy-MM-dd")
                    });
            }

            var bloqueio = new Agendamento
            {
                ProfissionalId = profissionalId,
                DataAtendimento = data,
                HoraInicio = hora,
                HoraFim = hora.AddMinutes(30),
                DuracaoMinutos = 30,
                Status = "BLOQUEADO",
                OrigemAgendamento = "MANUAL",
                CanalAgendamento = "WEB",
                Observacoes = "Horário bloqueado",
                CreatedAt = DateTime.Now,
                UpdatedAt = DateTime.Now
            };

            context.Agendamentos.Add(bloqueio);
            await context.SaveChangesAsync();
            return RedirectToAction(nameof(Index),
                new
                {
                    profissionalId,
                    data = data.ToString("yyyy-MM-dd")
                });
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> CancelarAgendamento(ulong id, ulong profissionalId, DateOnly data)
        {
            var agendamento = await context.Agendamentos.FirstOrDefaultAsync(x => x.Id == id);
            if (agendamento == null)
            {
                return RedirectToAction(nameof(Index),
                    new
                    {
                        profissionalId,
                        data = data.ToString("yyyy-MM-dd")
                    });
            }

            var profissionalLogado = GetProfissionalLogado();
            if (agendamento.ProfissionalId != profissionalLogado)
            {
                return Forbid();
            }

            if (agendamento.Status == "BLOQUEADO")
            {
                context.Agendamentos.Remove(agendamento);
            }
            else
            {
                agendamento.Status = "CANCELADO";
                agendamento.UpdatedAt = DateTime.Now;
                context.Agendamentos.Update(agendamento);
            }

            await context.SaveChangesAsync();
            TempData["SucessoAgenda"] = "Agendamento cancelado com sucesso.";
            return RedirectToAction(nameof(Index),
                new
                {
                    profissionalId,
                    data = data.ToString("yyyy-MM-dd")
                });
        }
    }
}