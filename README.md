# Sistema de Agenda Estética

Sistema web mobile-first para gerenciamento de agendas, atendimentos e controle operacional de profissionais da área estética.

Desenvolvido em ASP.NET Core MVC com MySQL, focado em uso via navegador mobile (Android/iPhone), utilizando layout responsivo e fluxo simplificado para operação diária.

---

# Projeto Integrador

Este sistema está sendo desenvolvido como trabalho acadêmico do Projeto Integrador da faculdade.

O objetivo do projeto é aplicar conceitos reais de:

* Desenvolvimento Web
* Arquitetura MVC
* Banco de Dados Relacional
* Segurança e Autenticação
* Controle de Permissões
* UX Mobile
* Integração entre Frontend e Backend
* Persistência de Dados
* Regras de Negócio

---

# Tecnologias Utilizadas

* ASP.NET Core MVC (.NET 8)
* Entity Framework Core
* Pomelo EntityFramework MySQL
* MySQL
* Bootstrap 5
* CSS3
* BCrypt.Net
* Razor Views

---

# Características do Sistema

## Mobile First

O sistema foi projetado para uso principalmente em dispositivos móveis:

* Android
* iPhone
* Tablets

Com:

* Menu hamburguer
* Cards responsivos
* Navegação simplificada
* Layout otimizado para toque

---

# Funcionalidades Implementadas

## 🔐 Autenticação

* Login de usuários
* Logout
* Controle de sessão
* Hash de senha com BCrypt
* Controle de permissões por perfil

---

## 👥 Controle de Perfis

Atualmente o sistema possui:

### Administrador

Pode:

* Gerenciar usuários
* Gerenciar profissionais
* Visualizar agendas

### Profissional

Pode:

* Visualizar agendas
* Agendar horários
* Cancelar próprios atendimentos
* Bloquear próprios horários
* Agendar para outros profissionais

### Recepção (planejado)

Poderá:

* Visualizar todas agendas
* Criar/remover agendamentos

---

# 📅 Agenda Inteligente

## Funcionalidades atuais

* Agenda por profissional
* Agenda por data
* Seleção de data via calendário
* Visualização de horários
* Dashboard diário
* Controle visual por status

---

## Expediente Profissional

Valida:

* Dia da semana
* Horário de início
* Horário de término
* Existência de expediente

---

# 👤 Cadastro de Clientes

Implementado:

* Cadastro simples
* Edição
* Busca
* Telefone
* Email
* Observações

---

# 📊 Relatórios

Implementados:

* Relatório de atendimentos
* Relatório de faturamento por período

Gerados diretamente em tela para impressão via navegador.

---

# 🗄️ Banco de Dados

Utiliza MySQL com:

* Foreign Keys
* Constraints
* Controle de integridade
* Relacionamentos normalizados

---

# Segurança

* Senhas criptografadas
* Controle por roles
* Restrições de acesso
* Validação server-side
* Proteção contra ações indevidas

---


# Como Executar

## Requisitos

* .NET 8 SDK
* MySQL Server

---

## Configuração

### appsettings.json

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "server=localhost;database=agenda_estetica;user=root;password=senha"
  }
}
```

---

# Observações

Este projeto está em desenvolvimento contínuo e novas funcionalidades serão adicionadas conforme evolução do Projeto Integrador.

