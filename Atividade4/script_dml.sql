USE biblioteca_pessoal;

-- AJUSTE DE ESTRUTURA
ALTER TABLE Livro MODIFY COLUMN ano_publicacao INT;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE Livro;
TRUNCATE TABLE Autor;
TRUNCATE TABLE Categoria;
TRUNCATE TABLE Editora;
TRUNCATE TABLE Usuario;
SET FOREIGN_KEY_CHECKS = 1;

INSERT INTO Usuario (id_usuario, nome, email, senha) 
VALUES (1, 'Usuario Teste', 'teste@email.com', 'senha123');

INSERT INTO Autor (id_autor, nome) 
VALUES (1, 'J.K. Rowling'), (2, 'Friedrich Nietzsche');

INSERT INTO Editora (id_editora, nome) 
VALUES (1, 'Rocco'), (2, 'Companhia das Letras');

INSERT INTO Categoria (id_categoria, nome) 
VALUES (1, 'Fantasia'), (2, 'Filosofia');

-- Inserindo os livros vinculados aos IDs acima
INSERT INTO Livro (id_usuario, id_autor, id_editora, id_categoria, titulo, ano_publicacao) 
VALUES 
(1, 1, 1, 1, 'Harry Potter e a Pedra Filosofal', 1997),
(1, 1, 1, 1, 'Harry Potter e a Câmara Secreta', 1998),
(1, 2, 2, 2, 'Assim Falou Zaratustra', 1883),
(1, 2, 2, 2, 'O Anticristo', 1888);

SELECT L.titulo 
FROM Livro L
INNER JOIN Autor A ON L.id_autor = A.id_autor
WHERE A.nome = 'J.K. Rowling';

SELECT L.titulo 
FROM Livro L
INNER JOIN Categoria C ON L.id_categoria = C.id_categoria
WHERE C.nome = 'Filosofia';

UPDATE Categoria 
SET nome = 'Censurado' 
WHERE nome = 'Filosofia';

DELETE FROM Livro 
WHERE id_categoria = (SELECT id_categoria FROM Categoria WHERE nome = 'Censurado');

SELECT * FROM Categoria;
SELECT * FROM Livro;