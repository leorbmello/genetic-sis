/*
 Navicat Premium Data Transfer

 Source Server         : local
 Source Server Type    : MySQL
 Source Server Version : 80017
 Source Host           : localhost:3306
 Source Schema         : agenda_estetica

 Target Server Type    : MySQL
 Target Server Version : 80017
 File Encoding         : 65001

 Date: 17/05/2026 18:03:39
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for agendamentos
-- ----------------------------
DROP TABLE IF EXISTS `agendamentos`;
CREATE TABLE `agendamentos`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `cliente_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `profissional_id` bigint(20) UNSIGNED NOT NULL,
  `servico_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `data_atendimento` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fim` time NULL DEFAULT NULL,
  `duracao_minutos` int(10) UNSIGNED NULL DEFAULT NULL,
  `valor_cobrado` decimal(10, 2) NULL DEFAULT NULL,
  `status` enum('AGENDADO','CONFIRMADO','CONCLUIDO','CANCELADO','FALTOU') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'AGENDADO',
  `origem_agendamento` enum('INTERNO','EXTERNO') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'INTERNO',
  `canal_agendamento` enum('BALCAO','TELEFONE','WHATSAPP','SITE','OUTRO') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'BALCAO',
  `observacoes` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `motivo_cancelamento` varchar(250) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `criado_por_usuario_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `confirmado_em` datetime NULL DEFAULT NULL,
  `concluido_em` datetime NULL DEFAULT NULL,
  `cancelado_em` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `fk_agendamento_criado_por`(`criado_por_usuario_id` ASC) USING BTREE,
  INDEX `idx_agendamento_prof_data_status`(`profissional_id` ASC, `data_atendimento` ASC, `status` ASC) USING BTREE,
  INDEX `idx_agendamento_data_status`(`data_atendimento` ASC, `status` ASC) USING BTREE,
  INDEX `idx_agendamento_cliente_data`(`cliente_id` ASC, `data_atendimento` ASC) USING BTREE,
  INDEX `idx_agendamento_servico_data`(`servico_id` ASC, `data_atendimento` ASC) USING BTREE,
  INDEX `idx_agendamento_prof_intervalo`(`profissional_id` ASC, `data_atendimento` ASC, `hora_inicio` ASC, `hora_fim` ASC) USING BTREE,
  CONSTRAINT `fk_agendamento_cliente` FOREIGN KEY (`cliente_id`) REFERENCES `clientes` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_agendamento_criado_por` FOREIGN KEY (`criado_por_usuario_id`) REFERENCES `usuarios` (`id`) ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_agendamento_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `fk_agendamento_servico` FOREIGN KEY (`servico_id`) REFERENCES `servicos` (`id`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `chk_agendamento_duracao` CHECK ((`duracao_minutos` is null) or (`duracao_minutos` between 5 and 480)),
  CONSTRAINT `chk_agendamento_valor` CHECK ((`valor_cobrado` is null) or (`valor_cobrado` >= 0))
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of agendamentos
-- ----------------------------
INSERT INTO `agendamentos` VALUES (1, 1, 1, 1, '2026-05-12', '09:00:00', '10:00:00', 60, 180.00, 'AGENDADO', 'INTERNO', 'BALCAO', 'Primeira sessão', NULL, 2, NULL, NULL, NULL, '2026-05-12 22:17:55', '2026-05-12 22:54:35');
INSERT INTO `agendamentos` VALUES (2, 2, 1, 4, '2026-05-12', '10:30:00', '11:15:00', 45, 650.00, 'CONFIRMADO', 'INTERNO', 'WHATSAPP', 'Confirmado no dia anterior', NULL, 2, '2026-04-19 18:00:00', NULL, NULL, '2026-05-12 22:17:55', '2026-05-12 22:54:36');
INSERT INTO `agendamentos` VALUES (3, 3, 2, 3, '2026-05-12', '10:00:00', '10:50:00', 50, 150.00, 'CONCLUIDO', 'INTERNO', 'TELEFONE', 'Sessão concluída normalmente', NULL, 2, '2026-04-19 16:00:00', '2026-04-20 11:00:00', NULL, '2026-05-12 22:17:55', '2026-05-12 22:54:36');
INSERT INTO `agendamentos` VALUES (4, 4, 3, 2, '2026-05-12', '14:00:00', '14:30:00', 30, 55.00, 'AGENDADO', 'EXTERNO', 'SITE', 'Agendado online', NULL, 1, NULL, NULL, NULL, '2026-05-12 22:17:55', '2026-05-12 22:54:37');
INSERT INTO `agendamentos` VALUES (5, 5, 1, 1, '2026-05-12', '15:00:00', '16:00:00', 60, 180.00, 'CANCELADO', 'INTERNO', 'WHATSAPP', 'Cliente remarcou', 'Remarcado para outra data', 2, NULL, NULL, '2026-04-20 19:30:00', '2026-05-12 22:17:55', '2026-05-12 22:54:38');
INSERT INTO `agendamentos` VALUES (6, 5, 1, 5, '2026-05-18', '09:00:00', '09:20:00', 20, 40.00, 'CANCELADO', '', '', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:07:02', '2026-05-17 17:22:23');
INSERT INTO `agendamentos` VALUES (7, 5, 1, 4, '2026-05-18', '09:00:00', '09:45:00', 45, 650.00, 'CANCELADO', '', '', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:22:30', '2026-05-17 18:00:10');
INSERT INTO `agendamentos` VALUES (8, 4, 2, 4, '2026-05-18', '10:00:00', '10:45:00', 45, 650.00, 'CANCELADO', '', '', NULL, NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:27:47', '2026-05-17 17:33:33');
INSERT INTO `agendamentos` VALUES (14, NULL, 2, NULL, '2026-05-18', '10:00:00', '10:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:42:26', '2026-05-17 17:42:29');
INSERT INTO `agendamentos` VALUES (15, NULL, 2, NULL, '2026-05-18', '10:00:00', '10:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:42:31', '2026-05-17 17:42:42');
INSERT INTO `agendamentos` VALUES (16, NULL, 2, NULL, '2026-05-18', '10:30:00', '11:00:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:42:38', '2026-05-17 17:42:43');
INSERT INTO `agendamentos` VALUES (17, NULL, 1, NULL, '2026-05-18', '10:00:00', '10:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:58:24', '2026-05-17 17:58:27');
INSERT INTO `agendamentos` VALUES (18, NULL, 1, NULL, '2026-05-18', '10:00:00', '10:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:59:51', '2026-05-17 17:59:53');
INSERT INTO `agendamentos` VALUES (19, NULL, 1, NULL, '2026-05-18', '11:00:00', '11:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:59:54', '2026-05-17 18:00:11');
INSERT INTO `agendamentos` VALUES (20, NULL, 1, NULL, '2026-05-18', '10:00:00', '10:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 17:59:55', '2026-05-17 18:00:09');
INSERT INTO `agendamentos` VALUES (21, NULL, 1, NULL, '2026-05-18', '13:00:00', '13:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 18:00:03', '2026-05-17 18:00:09');
INSERT INTO `agendamentos` VALUES (22, NULL, 1, NULL, '2026-05-18', '14:00:00', '14:30:00', 30, NULL, 'CANCELADO', '', '', 'Horário bloqueado', NULL, NULL, NULL, NULL, NULL, '2026-05-17 18:00:05', '2026-05-17 18:00:13');

-- ----------------------------
-- Table structure for bloqueios_agenda
-- ----------------------------
DROP TABLE IF EXISTS `bloqueios_agenda`;
CREATE TABLE `bloqueios_agenda`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `profissional_id` bigint(20) UNSIGNED NOT NULL,
  `data_bloqueio` date NOT NULL,
  `hora_inicio` time NOT NULL,
  `hora_fim` time NOT NULL,
  `motivo` varchar(200) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `tipo_bloqueio` enum('AUSENCIA','ALMOCO_EXTRA','FERIAS','REUNIAO','MANUTENCAO','OUTRO') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT 'OUTRO',
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_bloqueio_prof_data`(`profissional_id` ASC, `data_bloqueio` ASC, `hora_inicio` ASC, `hora_fim` ASC) USING BTREE,
  INDEX `idx_bloqueio_data`(`data_bloqueio` ASC) USING BTREE,
  CONSTRAINT `fk_bloqueio_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_bloqueio_inicio_fim` CHECK (`hora_inicio` < `hora_fim`)
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of bloqueios_agenda
-- ----------------------------
INSERT INTO `bloqueios_agenda` VALUES (1, 1, '2026-04-21', '16:00:00', '18:00:00', 'Treinamento interno', 'REUNIAO', '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `bloqueios_agenda` VALUES (2, 2, '2026-04-20', '15:00:00', '16:30:00', 'Manutenção de sala', 'MANUTENCAO', '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `bloqueios_agenda` VALUES (3, 3, '2026-04-22', '08:00:00', '12:00:00', 'Ausência médica', 'AUSENCIA', '2026-05-12 22:17:55', '2026-05-12 22:17:55');

-- ----------------------------
-- Table structure for clientes
-- ----------------------------
DROP TABLE IF EXISTS `clientes`;
CREATE TABLE `clientes`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `celular` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `data_nascimento` date NULL DEFAULT NULL,
  `observacoes` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  INDEX `idx_clientes_nome`(`nome` ASC) USING BTREE,
  INDEX `idx_clientes_celular`(`celular` ASC) USING BTREE,
  INDEX `idx_clientes_ativo_nome`(`ativo` ASC, `nome` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of clientes
-- ----------------------------
INSERT INTO `clientes` VALUES (1, 'Mariana Alves', '(11) 97777-1001', 'mariana@gmail.com', '1992-04-12', 'Prefere atendimento pela manhã', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `clientes` VALUES (2, 'Fernanda Rocha', '(11) 97777-1002', 'fernanda@gmail.com', '1988-11-03', NULL, 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `clientes` VALUES (3, 'Patricia Gomes', '(11) 97777-1003', 'patricia@gmail.com', '1995-09-25', 'Cliente recorrente', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `clientes` VALUES (4, 'Juliana Costa', '(11) 97777-1004', 'juliana@gmail.com', '1990-01-18', 'Tem sensibilidade a determinados produtos', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `clientes` VALUES (5, 'Camila Nunes', '(11) 97777-1005', 'camila@gmail.com', '1998-07-07', NULL, 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `clientes` VALUES (7, 'Leonardo Ribeiro', '13996181901', 'leorbmello@gmail.com', NULL, '1234', 1, '2026-05-17 18:00:31', '2026-05-17 18:00:37');

-- ----------------------------
-- Table structure for horarios_trabalho_profissional
-- ----------------------------
DROP TABLE IF EXISTS `horarios_trabalho_profissional`;
CREATE TABLE `horarios_trabalho_profissional`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `profissional_id` bigint(20) UNSIGNED NOT NULL,
  `dia_semana` tinyint(3) UNSIGNED NOT NULL COMMENT '0=segunda ... 6=domingo',
  `hora_inicio` time NOT NULL,
  `hora_fim` time NOT NULL,
  `intervalo_inicio` time NULL DEFAULT NULL,
  `intervalo_fim` time NULL DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_horario_profissional_dia`(`profissional_id` ASC, `dia_semana` ASC) USING BTREE,
  INDEX `idx_horario_profissional_dia`(`profissional_id` ASC, `dia_semana` ASC, `ativo` ASC) USING BTREE,
  CONSTRAINT `fk_horario_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `chk_horario_dia_semana` CHECK (`dia_semana` between 0 and 6),
  CONSTRAINT `chk_horario_inicio_fim` CHECK (`hora_inicio` < `hora_fim`),
  CONSTRAINT `chk_horario_intervalo` CHECK (((`intervalo_inicio` is null) and (`intervalo_fim` is null)) or ((`intervalo_inicio` is not null) and (`intervalo_fim` is not null) and (`intervalo_inicio` < `intervalo_fim`) and (`intervalo_inicio` > `hora_inicio`) and (`intervalo_fim` < `hora_fim`)))
) ENGINE = InnoDB AUTO_INCREMENT = 16 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of horarios_trabalho_profissional
-- ----------------------------
INSERT INTO `horarios_trabalho_profissional` VALUES (1, 1, 0, '09:00:00', '18:00:00', '12:00:00', '13:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (2, 1, 1, '09:00:00', '18:00:00', '12:00:00', '13:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (3, 1, 2, '09:00:00', '18:00:00', '12:00:00', '13:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (4, 1, 3, '09:00:00', '18:00:00', '12:00:00', '13:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (5, 1, 4, '09:00:00', '18:00:00', '12:00:00', '13:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (6, 1, 5, '09:00:00', '13:00:00', NULL, NULL, 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (7, 2, 0, '10:00:00', '19:00:00', '13:00:00', '14:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (8, 2, 1, '10:00:00', '19:00:00', '13:00:00', '14:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (9, 2, 2, '10:00:00', '19:00:00', '13:00:00', '14:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (10, 2, 3, '10:00:00', '19:00:00', '13:00:00', '14:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (11, 2, 4, '10:00:00', '19:00:00', '13:00:00', '14:00:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (12, 3, 1, '08:00:00', '17:00:00', '12:30:00', '13:30:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (13, 3, 2, '08:00:00', '17:00:00', '12:30:00', '13:30:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (14, 3, 3, '08:00:00', '17:00:00', '12:30:00', '13:30:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (15, 3, 4, '08:00:00', '17:00:00', '12:30:00', '13:30:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `horarios_trabalho_profissional` VALUES (16, 3, 5, '08:00:00', '17:00:00', '12:30:00', '13:30:00', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');

-- ----------------------------
-- Table structure for profissionais
-- ----------------------------
DROP TABLE IF EXISTS `profissionais`;
CREATE TABLE `profissionais`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `telefone` varchar(20) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `email` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `cor_agenda` char(7) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '#6f42c1',
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `observacoes` varchar(500) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_profissionais_email`(`email` ASC) USING BTREE,
  INDEX `idx_profissionais_ativo_nome`(`ativo` ASC, `nome` ASC) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 3 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of profissionais
-- ----------------------------
INSERT INTO `profissionais` VALUES (1, 'Ana Souza', '(11) 99888-1001', 'ana@clinica.local', '#d63384', 1, 'Especialista em limpeza de pele e botox', '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `profissionais` VALUES (2, 'Carla Lima', '(11) 99888-1002', 'carla@clinica.local', '#198754', 1, 'Atende drenagem e massagens', '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `profissionais` VALUES (3, 'Julia Martins', '(11) 99888-1003', 'julia@clinica.local', '#0d6efd', 1, 'Design de sobrancelhas e depilação', '2026-05-12 22:17:55', '2026-05-12 22:17:55');

-- ----------------------------
-- Table structure for servicos
-- ----------------------------
DROP TABLE IF EXISTS `servicos`;
CREATE TABLE `servicos`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `descricao` varchar(300) CHARACTER SET utf8 COLLATE utf8_general_ci NULL DEFAULT NULL,
  `duracao_minutos` int(10) UNSIGNED NOT NULL,
  `valor_base` decimal(10, 2) NULL DEFAULT NULL,
  `cor_agenda` char(7) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL DEFAULT '#0d6efd',
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_servicos_nome`(`nome` ASC) USING BTREE,
  INDEX `idx_servicos_ativo_nome`(`ativo` ASC, `nome` ASC) USING BTREE,
  CONSTRAINT `chk_servicos_duracao` CHECK (`duracao_minutos` between 5 and 480),
  CONSTRAINT `chk_servicos_valor` CHECK ((`valor_base` is null) or (`valor_base` >= 0))
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of servicos
-- ----------------------------
INSERT INTO `servicos` VALUES (1, 'Limpeza de Pele', 'Limpeza facial completa', 60, 180.00, '#20c997', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `servicos` VALUES (2, 'Design de Sobrancelha', 'Modelagem e correção de sobrancelhas', 30, 55.00, '#fd7e14', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `servicos` VALUES (3, 'Drenagem Linfática', 'Sessão corporal', 50, 150.00, '#6f42c1', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `servicos` VALUES (4, 'Aplicação de Botox', 'Procedimento estético facial', 45, 650.00, '#dc3545', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');
INSERT INTO `servicos` VALUES (5, 'Depilação Facial', 'Depilação de buço e regiões faciais', 20, 40.00, '#0dcaf0', 1, '2026-05-12 22:17:55', '2026-05-12 22:17:55');

-- ----------------------------
-- Table structure for usuarios
-- ----------------------------
DROP TABLE IF EXISTS `usuarios`;
CREATE TABLE `usuarios`  (
  `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT,
  `nome` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `email` varchar(150) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `senha_hash` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `perfil` enum('ADMIN','RECEPCAO','PROFISSIONAL') CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `profissional_id` bigint(20) UNSIGNED NULL DEFAULT NULL,
  `ativo` tinyint(1) NOT NULL DEFAULT 1,
  `ultimo_login_em` datetime NULL DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE INDEX `uq_usuarios_email`(`email` ASC) USING BTREE,
  UNIQUE INDEX `uq_usuarios_profissional`(`profissional_id` ASC) USING BTREE,
  INDEX `idx_usuarios_perfil_ativo`(`perfil` ASC, `ativo` ASC) USING BTREE,
  INDEX `idx_usuarios_nome`(`nome` ASC) USING BTREE,
  CONSTRAINT `fk_usuario_profissional` FOREIGN KEY (`profissional_id`) REFERENCES `profissionais` (`id`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE = InnoDB AUTO_INCREMENT = 5 CHARACTER SET = utf8 COLLATE = utf8_general_ci ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of usuarios
-- ----------------------------
INSERT INTO `usuarios` VALUES (1, 'Administrador', 'admin@clinica.local', '$2a$11$eemP0kaJV4.LW6k4a7kcxeprvaLCjfQEgeioJyuy.IeVGlqeeBeee', 'ADMIN', NULL, 1, '2026-05-12 22:41:29', '2026-05-12 22:17:55', '2026-05-12 22:41:28');
INSERT INTO `usuarios` VALUES (2, 'Recepção', 'recepcao@clinica.local', '$2a$11$eemP0kaJV4.LW6k4a7kcxeprvaLCjfQEgeioJyuy.IeVGlqeeBeee', 'RECEPCAO', NULL, 1, NULL, '2026-05-12 22:17:55', '2026-05-12 22:20:59');
INSERT INTO `usuarios` VALUES (3, 'Ana Souza', 'usuario.ana@clinica.local', '$2a$11$eemP0kaJV4.LW6k4a7kcxeprvaLCjfQEgeioJyuy.IeVGlqeeBeee', 'PROFISSIONAL', 1, 1, '2026-05-17 17:55:56', '2026-05-12 22:17:55', '2026-05-17 17:55:56');
INSERT INTO `usuarios` VALUES (4, 'Carla Lima', 'usuario.carla@clinica.local', '$2a$11$eemP0kaJV4.LW6k4a7kcxeprvaLCjfQEgeioJyuy.IeVGlqeeBeee', 'PROFISSIONAL', 2, 1, '2026-05-17 17:31:15', '2026-05-12 22:17:55', '2026-05-17 17:31:15');
INSERT INTO `usuarios` VALUES (5, 'Julia Martins', 'usuario.julia@clinica.local', '$2a$11$eemP0kaJV4.LW6k4a7kcxeprvaLCjfQEgeioJyuy.IeVGlqeeBeee', 'PROFISSIONAL', 3, 1, '2026-05-12 22:51:25', '2026-05-12 22:17:55', '2026-05-12 22:51:24');

-- ----------------------------
-- View structure for vw_agendamentos_detalhados
-- ----------------------------
DROP VIEW IF EXISTS `vw_agendamentos_detalhados`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_agendamentos_detalhados` AS select `a`.`id` AS `id`,`a`.`data_atendimento` AS `data_atendimento`,`a`.`hora_inicio` AS `hora_inicio`,`a`.`hora_fim` AS `hora_fim`,`a`.`duracao_minutos` AS `duracao_minutos`,`a`.`valor_cobrado` AS `valor_cobrado`,`a`.`status` AS `status`,`a`.`origem_agendamento` AS `origem_agendamento`,`a`.`canal_agendamento` AS `canal_agendamento`,`a`.`observacoes` AS `observacoes`,`a`.`motivo_cancelamento` AS `motivo_cancelamento`,`c`.`id` AS `cliente_id`,`c`.`nome` AS `cliente_nome`,`c`.`celular` AS `cliente_celular`,`p`.`id` AS `profissional_id`,`p`.`nome` AS `profissional_nome`,`s`.`id` AS `servico_id`,`s`.`nome` AS `servico_nome`,`u`.`id` AS `criado_por_usuario_id`,`u`.`nome` AS `criado_por_nome`,`a`.`created_at` AS `created_at`,`a`.`updated_at` AS `updated_at` from ((((`agendamentos` `a` join `clientes` `c` on((`c`.`id` = `a`.`cliente_id`))) join `profissionais` `p` on((`p`.`id` = `a`.`profissional_id`))) join `servicos` `s` on((`s`.`id` = `a`.`servico_id`))) left join `usuarios` `u` on((`u`.`id` = `a`.`criado_por_usuario_id`)));

-- ----------------------------
-- View structure for vw_relatorio_profissional_resumo
-- ----------------------------
DROP VIEW IF EXISTS `vw_relatorio_profissional_resumo`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `vw_relatorio_profissional_resumo` AS select `a`.`data_atendimento` AS `data_atendimento`,`p`.`id` AS `profissional_id`,`p`.`nome` AS `profissional_nome`,count(0) AS `total_registros`,sum((case when (`a`.`status` = 'CONCLUIDO') then 1 else 0 end)) AS `atendimentos_concluidos`,sum((case when (`a`.`status` in ('AGENDADO','CONFIRMADO')) then 1 else 0 end)) AS `atendimentos_futuros`,sum((case when (`a`.`status` = 'CANCELADO') then 1 else 0 end)) AS `cancelamentos`,sum((case when (`a`.`status` = 'FALTOU') then 1 else 0 end)) AS `faltas`,sum((case when (`a`.`status` = 'CONCLUIDO') then `a`.`duracao_minutos` else 0 end)) AS `minutos_concluidos`,sum((case when (`a`.`status` = 'CONCLUIDO') then coalesce(`a`.`valor_cobrado`,0) else 0 end)) AS `valor_total_concluido` from (`agendamentos` `a` join `profissionais` `p` on((`p`.`id` = `a`.`profissional_id`))) group by `a`.`data_atendimento`,`p`.`id`,`p`.`nome`;

-- ----------------------------
-- Triggers structure for table agendamentos
-- ----------------------------
DROP TRIGGER IF EXISTS `bi_agendamentos_validacao`;
delimiter ;;
CREATE TRIGGER `bi_agendamentos_validacao` BEFORE INSERT ON `agendamentos` FOR EACH ROW BEGIN
    DECLARE v_duracao INT UNSIGNED;
    DECLARE v_valor DECIMAL(10,2);

    DECLARE v_expediente_count INT DEFAULT 0;
    DECLARE v_hora_inicio TIME;
    DECLARE v_hora_fim TIME;
    DECLARE v_intervalo_inicio TIME;
    DECLARE v_intervalo_fim TIME;

    DECLARE v_bloqueios INT DEFAULT 0;
    DECLARE v_conflitos INT DEFAULT 0;

    -- Preencher snapshot do serviço, se necessário
    IF NEW.duracao_minutos IS NULL OR NEW.duracao_minutos = 0 OR NEW.valor_cobrado IS NULL THEN
        SELECT s.duracao_minutos, s.valor_base
          INTO v_duracao, v_valor
          FROM servicos s
         WHERE s.id = NEW.servico_id
         LIMIT 1;

        IF NEW.duracao_minutos IS NULL OR NEW.duracao_minutos = 0 THEN
            SET NEW.duracao_minutos = v_duracao;
        END IF;

        IF NEW.valor_cobrado IS NULL THEN
            SET NEW.valor_cobrado = v_valor;
        END IF;
    END IF;

    IF NEW.duracao_minutos IS NULL OR NEW.duracao_minutos = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não foi possível determinar a duração do serviço.';
    END IF;

    -- Calcular hora final
    SET NEW.hora_fim = ADDTIME(NEW.hora_inicio, SEC_TO_TIME(NEW.duracao_minutos * 60));

    -- Cancelado não ocupa agenda; demais ocupam
    IF NEW.status <> 'CANCELADO' THEN

        -- Buscar expediente do dia
        SELECT COUNT(*), MIN(hora_inicio), MIN(hora_fim), MIN(intervalo_inicio), MIN(intervalo_fim)
          INTO v_expediente_count, v_hora_inicio, v_hora_fim, v_intervalo_inicio, v_intervalo_fim
          FROM horarios_trabalho_profissional
         WHERE profissional_id = NEW.profissional_id
           AND dia_semana = WEEKDAY(NEW.data_atendimento)
           AND ativo = 1;

        IF v_expediente_count = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A profissional não possui expediente configurado para esse dia.';
        END IF;

        -- Fora do expediente
        IF NEW.hora_inicio < v_hora_inicio OR NEW.hora_fim > v_hora_fim THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Horário fora do expediente da profissional.';
        END IF;

        -- Conflito com intervalo
        IF v_intervalo_inicio IS NOT NULL
           AND NEW.hora_inicio < v_intervalo_fim
           AND NEW.hora_fim > v_intervalo_inicio THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Horário conflita com o intervalo da profissional.';
        END IF;

        -- Conflito com bloqueio
        SELECT COUNT(*)
          INTO v_bloqueios
          FROM bloqueios_agenda b
         WHERE b.profissional_id = NEW.profissional_id
           AND b.data_bloqueio = NEW.data_atendimento
           AND NEW.hora_inicio < b.hora_fim
           AND NEW.hora_fim > b.hora_inicio;

        IF v_bloqueios > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Horário indisponível por bloqueio de agenda.';
        END IF;

        -- Conflito com outro agendamento não cancelado
        SELECT COUNT(*)
          INTO v_conflitos
          FROM agendamentos a
         WHERE a.profissional_id = NEW.profissional_id
           AND a.data_atendimento = NEW.data_atendimento
           AND a.status <> 'CANCELADO'
           AND NEW.hora_inicio < a.hora_fim
           AND NEW.hora_fim > a.hora_inicio;

        IF v_conflitos > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Já existe agendamento conflitante para essa profissional.';
        END IF;

    END IF;
END
;;
delimiter ;

-- ----------------------------
-- Triggers structure for table agendamentos
-- ----------------------------
DROP TRIGGER IF EXISTS `bu_agendamentos_validacao`;
delimiter ;;
CREATE TRIGGER `bu_agendamentos_validacao` BEFORE UPDATE ON `agendamentos` FOR EACH ROW BEGIN
    DECLARE v_duracao INT UNSIGNED;
    DECLARE v_valor DECIMAL(10,2);

    DECLARE v_expediente_count INT DEFAULT 0;
    DECLARE v_hora_inicio TIME;
    DECLARE v_hora_fim TIME;
    DECLARE v_intervalo_inicio TIME;
    DECLARE v_intervalo_fim TIME;

    DECLARE v_bloqueios INT DEFAULT 0;
    DECLARE v_conflitos INT DEFAULT 0;

    IF NEW.duracao_minutos IS NULL OR NEW.duracao_minutos = 0 OR NEW.valor_cobrado IS NULL THEN
        SELECT s.duracao_minutos, s.valor_base
          INTO v_duracao, v_valor
          FROM servicos s
         WHERE s.id = NEW.servico_id
         LIMIT 1;

        IF NEW.duracao_minutos IS NULL OR NEW.duracao_minutos = 0 THEN
            SET NEW.duracao_minutos = v_duracao;
        END IF;

        IF NEW.valor_cobrado IS NULL THEN
            SET NEW.valor_cobrado = v_valor;
        END IF;
    END IF;

    IF NEW.duracao_minutos IS NULL OR NEW.duracao_minutos = 0 THEN
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Não foi possível determinar a duração do serviço.';
    END IF;

    SET NEW.hora_fim = ADDTIME(NEW.hora_inicio, SEC_TO_TIME(NEW.duracao_minutos * 60));

    IF NEW.status <> 'CANCELADO' THEN

        SELECT COUNT(*), MIN(hora_inicio), MIN(hora_fim), MIN(intervalo_inicio), MIN(intervalo_fim)
          INTO v_expediente_count, v_hora_inicio, v_hora_fim, v_intervalo_inicio, v_intervalo_fim
          FROM horarios_trabalho_profissional
         WHERE profissional_id = NEW.profissional_id
           AND dia_semana = WEEKDAY(NEW.data_atendimento)
           AND ativo = 1;

        IF v_expediente_count = 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'A profissional não possui expediente configurado para esse dia.';
        END IF;

        IF NEW.hora_inicio < v_hora_inicio OR NEW.hora_fim > v_hora_fim THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Horário fora do expediente da profissional.';
        END IF;

        IF v_intervalo_inicio IS NOT NULL
           AND NEW.hora_inicio < v_intervalo_fim
           AND NEW.hora_fim > v_intervalo_inicio THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Horário conflita com o intervalo da profissional.';
        END IF;

        SELECT COUNT(*)
          INTO v_bloqueios
          FROM bloqueios_agenda b
         WHERE b.profissional_id = NEW.profissional_id
           AND b.data_bloqueio = NEW.data_atendimento
           AND NEW.hora_inicio < b.hora_fim
           AND NEW.hora_fim > b.hora_inicio;

        IF v_bloqueios > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Horário indisponível por bloqueio de agenda.';
        END IF;

        SELECT COUNT(*)
          INTO v_conflitos
          FROM agendamentos a
         WHERE a.profissional_id = NEW.profissional_id
           AND a.data_atendimento = NEW.data_atendimento
           AND a.status <> 'CANCELADO'
           AND a.id <> NEW.id
           AND NEW.hora_inicio < a.hora_fim
           AND NEW.hora_fim > a.hora_inicio;

        IF v_conflitos > 0 THEN
            SIGNAL SQLSTATE '45000'
                SET MESSAGE_TEXT = 'Já existe agendamento conflitante para essa profissional.';
        END IF;

    END IF;
END
;;
delimiter ;

SET FOREIGN_KEY_CHECKS = 1;
