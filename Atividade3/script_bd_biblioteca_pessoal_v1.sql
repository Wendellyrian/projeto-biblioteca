-- 1. Criação do Banco de Dados
CREATE DATABASE IF NOT EXISTS biblioteca_pessoal;
USE biblioteca_pessoal;

-- 2. Tabela Usuario
CREATE TABLE Usuario (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE, 
    senha VARCHAR(255) NOT NULL,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 3. Tabela Editora
CREATE TABLE Editora (
    id_editora INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE, 
    cidade VARCHAR(64),
    estado VARCHAR(64),
    pais VARCHAR(64),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 4. Tabela Categoria
CREATE TABLE Categoria (
    id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(128) NOT NULL UNIQUE, 
    descricao TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 5. Tabela Autor
CREATE TABLE Autor (
    id_autor INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(255) NOT NULL UNIQUE, -- Restrição: nome único e não nulo
    ano_nascimento YEAR,
    ano_morte YEAR,
    apresentacao TEXT,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- 6. Tabela Livro
CREATE TABLE Livro (
    id_livro INT AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT NOT NULL,
    id_autor INT NOT NULL,
    id_editora INT NOT NULL,
    id_categoria INT NOT NULL,
    titulo VARCHAR(255) NOT NULL,
    sinopse TEXT,
    ano_publicacao YEAR,
    lido BOOLEAN DEFAULT FALSE,
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_atualizacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    
    -- Quando apagar um usuário deleta também todos os registros de livros
    CONSTRAINT fk_livro_usuario FOREIGN KEY (id_usuario) 
		REFERENCES Usuario(id_usuario) ON DELETE CASCADE,

    CONSTRAINT fk_livro_autor FOREIGN KEY (id_autor) 
		REFERENCES Autor(id_autor) ON DELETE RESTRICT,
        
    CONSTRAINT fk_livro_editora FOREIGN KEY (id_editora) 
        REFERENCES Editora(id_editora) ON DELETE RESTRICT,
        
    CONSTRAINT fk_livro_categoria FOREIGN KEY (id_categoria) 
        REFERENCES Categoria(id_categoria) ON DELETE RESTRICT
);

-- Consultas para checar se está tudo ok

-- Listar todos os livros com seus respectivos autores e editoras (Inner Join)
SELECT 
    L.titulo AS 'Livro', 
    A.nome AS 'Autor', 
    E.nome AS 'Editora', 
    C.nome AS 'Categoria'
FROM Livro L
INNER JOIN Autor A ON L.id_autor = A.id_autor
INNER JOIN Editora E ON L.id_editora = E.id_editora
INNER JOIN Categoria C ON L.id_categoria = C.id_categoria;

-- Contar quantos livros cada usuário possui 
SELECT 
    U.nome AS 'Usuário', 
    COUNT(L.id_livro) AS 'Total de Livros'
FROM Usuario U
LEFT JOIN Livro L ON U.id_usuario = L.id_usuario
GROUP BY U.id_usuario;

-- Buscar livros de uma categoria específica
SELECT titulo, sinopse FROM Livro 
WHERE id_categoria = (SELECT id_categoria FROM Categoria WHERE nome = 'Ficção Científica');