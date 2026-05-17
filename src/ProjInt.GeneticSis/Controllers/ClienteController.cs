using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjInt.GeneticSis.DAL;
using ProjInt.GeneticSis.DAL.Entities;
using ProjInt.GeneticSis.Models;

namespace ProjInt.GeneticSis.Controllers
{
    [Authorize]
    public class ClienteController : Controller
    {
        private readonly AppDbContext context;

        public ClienteController(AppDbContext context)
        {
            this.context = context;
        }

        public async Task<IActionResult> Index(string? busca)
        {
            var query = context.Clientes.AsQueryable();
            if (!string.IsNullOrWhiteSpace(busca))
            {
                query = query.Where(x =>
                    x.Nome.Contains(busca) || (x.Celular ?? "")
                    .Contains(busca));
            }

            var clientes = await query
                .OrderBy(x => x.Nome)
                .ToListAsync();

            return View(clientes);
        }

        [HttpGet]
        public IActionResult Novo()
        {
            return View(new ClienteFormViewModel());
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Novo(ClienteFormViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            bool existe =
                await context.Clientes
                    .AnyAsync(x =>
                        x.Celular == model.Telefone);

            if (existe)
            {
                ModelState.AddModelError("",
                    "Já existe um cliente com este telefone.");

                return View(model);
            }

            var cliente = new Cliente
            {
                Nome = model.Nome,
                Celular = model.Telefone,
                Email = model.Email,
                Observacoes = model.Observacoes,
                Ativo = true,
                CreatedAt = DateTime.Now,
                UpdatedAt = DateTime.Now
            };

            context.Clientes.Add(cliente);
            await context.SaveChangesAsync();
            TempData["Sucesso"] = "Cliente cadastrado com sucesso.";
            return RedirectToAction(nameof(Index));
        }

        [HttpGet]
        public async Task<IActionResult> Editar(
            ulong id)
        {
            var cliente = await context.Clientes.FirstOrDefaultAsync(x => x.Id == id);
            if (cliente == null)
            {
                return RedirectToAction(nameof(Index));
            }

            var model = new ClienteFormViewModel
            {
                Id = cliente.Id,
                Nome = cliente.Nome,
                Telefone = cliente.Celular,
                Email = cliente.Email,
                Observacoes = cliente.Observacoes
            };

            return View(model);
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Editar(
            ClienteFormViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            var cliente =
                await context.Clientes
                    .FirstOrDefaultAsync(x =>
                        x.Id == model.Id);

            if (cliente == null)
            {
                return RedirectToAction(nameof(Index));
            }

            cliente.Nome = model.Nome;
            cliente.Celular = model.Telefone;
            cliente.Email = model.Email;
            cliente.Observacoes = model.Observacoes;
            cliente.UpdatedAt = DateTime.Now;
            context.Clientes.Update(cliente);
            await context.SaveChangesAsync();

            TempData["Sucesso"] = "Cliente atualizado com sucesso.";
            return RedirectToAction(nameof(Index));
        }
    }
}
