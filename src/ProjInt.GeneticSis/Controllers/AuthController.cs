using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using ProjInt.GeneticSis.DAL;
using ProjInt.GeneticSis.Models;
using System.Security.Claims;

namespace ProjInt.GeneticSis.Controllers
{
    public class AuthController : Controller
    {
        private readonly AppDbContext db;

        public AuthController(AppDbContext context)
        {
            db = context;
        }

        [HttpGet]
        public IActionResult Login()
        {
            if (User.Identity?.IsAuthenticated == true)
            {
                return RedirectToAction("Index", "Home");
            }

            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Login(LoginViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);

            var usuario = await db.Usuarios
                .Include(x => x.Profissional)
                .FirstOrDefaultAsync(x => x.Email == model.Email && x.Ativo);

            if (usuario == null)
            {
                ModelState.AddModelError(string.Empty, "E-mail ou senha inválidos");
                return View(model);
            }

            bool senhaValida = BCrypt.Net.BCrypt.Verify(model.Senha, usuario.SenhaHash);
            if (!senhaValida)
            {
                ModelState.AddModelError(string.Empty, "E-mail ou senha inválidos");
                return View(model);
            }

            usuario.UltimoLoginEm = DateTime.Now;
            await db.SaveChangesAsync();

            var claims = new List<Claim>
            {
                new(ClaimTypes.NameIdentifier, usuario.Id.ToString()),
                new(ClaimTypes.Name, usuario.Nome),
                new(ClaimTypes.Email, usuario.Email),
                new(ClaimTypes.Role, usuario.Perfil)
            };

            if (usuario.ProfissionalId.HasValue)
            {
                claims.Add(new Claim("ProfissionalId", usuario.ProfissionalId.Value.ToString()));
            }

            var identity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
            var principal = new ClaimsPrincipal(identity);
            await HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                principal,
                new AuthenticationProperties
                {
                    IsPersistent = model.LembrarMe,
                    ExpiresUtc = DateTime.UtcNow.AddDays(30)
                });

            return RedirectToAction("Index", "Home");
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<IActionResult> Logout()
        {
            await HttpContext.SignOutAsync(CookieAuthenticationDefaults.AuthenticationScheme);
            return RedirectToAction(nameof(Login));
        }

        public IActionResult AcessoNegado()
        {
            return View();
        }
    }
}
