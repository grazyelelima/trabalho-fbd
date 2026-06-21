-- conferindo se as restrições do banco fazem sentido com os dados

-- email duplicado existe? (não devia)
SELECT email, COUNT(*) FROM Usuario GROUP BY email HAVING COUNT(*) > 1;

-- disciplina com nome repetido (não devia)
SELECT nome, COUNT(*) FROM Disciplina GROUP BY nome HAVING COUNT(*) > 1;

-- pergunta cujo criador não é estudante (não devia existir, é FK)
SELECT p.id_conteudo, p.titulo_resumido
FROM Pergunta p
LEFT JOIN Estudante e ON p.id_estudante_criador = e.id_usuario
WHERE e.id_usuario IS NULL;

-- usuario sem estar em Estudante nem Colaborador
SELECT u.id_usuario, u.p_nome
FROM Usuario u
LEFT JOIN Estudante e ON u.id_usuario = e.id_usuario
LEFT JOIN Colaborador c ON u.id_usuario = c.id_usuario
WHERE e.id_usuario IS NULL AND c.id_usuario IS NULL;

-- tag duplicada na mesma pergunta (chave composta deveria impedir)
SELECT id_conteudo, tag, COUNT(*) FROM Pergunta_Tags GROUP BY id_conteudo, tag HAVING COUNT(*) > 1;

-- mesma afinidade repetida pro mesmo colaborador
SELECT id_usuario, afinidade, COUNT(*) FROM Afinidade_Colaborador GROUP BY id_usuario, afinidade HAVING COUNT(*) > 1;

-- usuario avaliando a mesma resposta mais de uma vez (regra do RF04)
SELECT id_usuario, id_resposta, COUNT(*) FROM Avalia GROUP BY id_usuario, id_resposta HAVING COUNT(*) > 1;

-- resposta sem nenhuma pergunta vinculada (Pergunta_Resposta deveria garantir isso)
SELECT r.id_conteudo
FROM Resposta r
LEFT JOIN Pergunta_Resposta pr ON r.id_conteudo = pr.id_resposta
WHERE pr.id_pergunta IS NULL;

-- pontuação fora do esperado (1 a 5)
SELECT id_avaliacao, pontuacao FROM Avalia WHERE pontuacao NOT BETWEEN 1 AND 5;