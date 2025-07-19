-- Banco de Dados: vaxlogix
CREATE DATABASE IF NOT EXISTS vaxlogix;
USE vaxlogix;

-- Tabela de Login
CREATE TABLE IF NOT EXISTS auth_login (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(100) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Tabela de Funções Internas
CREATE TABLE IF NOT EXISTS plf_funcoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_funcao VARCHAR(50) NOT NULL UNIQUE
);

-- Tabela de Usuários da Plataforma
CREATE TABLE IF NOT EXISTS plf_usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_completo VARCHAR(150) NOT NULL,
    nascimento DATE NOT NULL,
    sexo ENUM('Masculino', 'Feminino') NOT NULL,
    telefone_principal VARCHAR(20),
    telefone_recado VARCHAR(20),
    telefone_whatsapp VARCHAR(20),
    login_id INT,
    funcao_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (login_id) REFERENCES auth_login(id),
    FOREIGN KEY (funcao_id) REFERENCES plf_funcoes(id)
);

-- Tabela de Categorias (Ramos de atividade das empresas)
CREATE TABLE IF NOT EXISTS camp_categorias (
    id INT AUTO_INCREMENT PRIMARY KEY,
    atividade ENUM('Indústria', 'Empresa', 'Banco', 'Comércio') NOT NULL UNIQUE
);

-- Tabela de Endereços das Empresas
CREATE TABLE IF NOT EXISTS camp_enderecos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    endereco VARCHAR(150) NOT NULL,
    numero VARCHAR(10) NOT NULL,
    complemento VARCHAR(100),
    bairro VARCHAR(100) NOT NULL,
    cidade VARCHAR(100) NOT NULL,
    estado VARCHAR(2) NOT NULL,
    cep VARCHAR(10) NOT NULL
);

-- Tabela de Empresas
CREATE TABLE IF NOT EXISTS camp_empresas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_empresa VARCHAR(150) NOT NULL,
    cnpj VARCHAR(18) NOT NULL UNIQUE,
    endereco_id INT,
    categoria_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (endereco_id) REFERENCES camp_enderecos(id),
    FOREIGN KEY (categoria_id) REFERENCES camp_categorias(id)
);

-- Tabela de Funcionários das Empresas
CREATE TABLE IF NOT EXISTS camp_funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    matricula VARCHAR(50) NOT NULL,
    nome_completo VARCHAR(150) NOT NULL,
    cpf VARCHAR(14) NOT NULL UNIQUE,
    nascimento DATE NOT NULL,
    telefone_contato VARCHAR(20),
    empresa_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES camp_empresas(id)
);

-- Tabela de Lotes das Vacinas
CREATE TABLE IF NOT EXISTS vac_lotes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    codigo_lote VARCHAR(100) NOT NULL UNIQUE,
    usuario_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES plf_usuarios(id)
);

-- Tabela de Vacinas
CREATE TABLE IF NOT EXISTS vac_vacinas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_vacina VARCHAR(100) NOT NULL,
    informacao TEXT,
    data_fabricacao DATE,
    quantidade INT,
    lote_id INT,
    usuario_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (lote_id) REFERENCES vac_lotes(id),
    FOREIGN KEY (usuario_id) REFERENCES plf_usuarios(id)
);

-- Tabela de Campanhas de Vacinação
CREATE TABLE IF NOT EXISTS vac_campanhas (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome_campanha VARCHAR(150) NOT NULL,
    data_aplicacao DATE NOT NULL,
    qtd_doses INT,
    qtd_doses_devolvidas INT,
    empresa_id INT,
    vacina_id INT,
    lote_id INT,
    usuario_id INT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (empresa_id) REFERENCES camp_empresas(id),
    FOREIGN KEY (vacina_id) REFERENCES vac_vacinas(id),
    FOREIGN KEY (lote_id) REFERENCES vac_lotes(id),
    FOREIGN KEY (usuario_id) REFERENCES plf_usuarios(id)
);

-- Tabela de vínculo: Funcionários que participaram de campanhas
CREATE TABLE IF NOT EXISTS vac_campanha_funcionarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    campanha_id INT,
    funcionario_id INT,
    FOREIGN KEY (campanha_id) REFERENCES vac_campanhas(id),
    FOREIGN KEY (funcionario_id) REFERENCES camp_funcionarios(id)
);

-- Tabela de Log de ações do sistema (opcional)
CREATE TABLE IF NOT EXISTS sys_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario_id INT,
    acao VARCHAR(255),
    tabela_afetada VARCHAR(50),
    data_evento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (usuario_id) REFERENCES plf_usuarios(id)
);