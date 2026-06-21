CREATE TABLE Usuario (
    id_usuario SERIAL PRIMARY KEY,
    email VARCHAR(150) UNIQUE NOT NULL,
    p_nome VARCHAR(50) NOT NULL,
    sobrenome VARCHAR(50) NOT NULL,
    senha VARCHAR(255) NOT NULL,
    modo_focado BOOLEAN DEFAULT FALSE,
    foto VARCHAR(255),      
    biografia TEXT           
);

CREATE TABLE Estudante (
    id_usuario INT PRIMARY KEY,
    curso VARCHAR(100), 
    CONSTRAINT fk_estudante_usuario 
        FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE
);

CREATE TABLE Colaborador (
    id_usuario INT PRIMARY KEY,
    CONSTRAINT fk_colaborador_usuario 
        FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE
);

-- Tabela para o atributo multivalorado "afinidade"

CREATE TABLE Afinidade_Colaborador (
    id_usuario INT,
    afinidade VARCHAR(100),
    PRIMARY KEY (id_usuario, afinidade), -- Chave primária composta
    CONSTRAINT fk_afinidade_colaborador 
        FOREIGN KEY (id_usuario) 
        REFERENCES Colaborador (id_usuario) 
        ON DELETE CASCADE
);

CREATE TABLE Segue (
    id_seguidor INT,
    id_seguido INT,
    PRIMARY KEY (id_seguidor, id_seguido),
    CONSTRAINT fk_usuario_seguidor 
        FOREIGN KEY (id_seguidor) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE,
    CONSTRAINT fk_usuario_seguido 
        FOREIGN KEY (id_seguido) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE
);

CREATE TABLE Disciplina (
    id_disciplina SERIAL PRIMARY KEY,
    nome VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Conteudo (
    id_conteudo SERIAL PRIMARY KEY,
    corpo_do_texto TEXT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_autor INT NOT NULL,
    CONSTRAINT fk_conteudo_autor 
        FOREIGN KEY (id_autor) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE
);

CREATE TABLE Pergunta (
    id_conteudo INT PRIMARY KEY,
    titulo_resumido VARCHAR(150) NOT NULL,
    status_resolvido BOOLEAN DEFAULT FALSE,
    anexo_imagem VARCHAR(255),
    id_disciplina INT NOT NULL,
    id_estudante_criador INT NOT NULL,
    CONSTRAINT fk_pergunta_conteudo
        FOREIGN KEY (id_conteudo) 
        REFERENCES Conteudo (id_conteudo) 
        ON DELETE CASCADE,
    CONSTRAINT fk_pergunta_disciplina
        FOREIGN KEY (id_disciplina) 
        REFERENCES Disciplina (id_disciplina),
    CONSTRAINT fk_pergunta_estudante
        FOREIGN KEY (id_estudante_criador) 
        REFERENCES Estudante (id_usuario)
);

CREATE TABLE Resposta (
    id_conteudo INT PRIMARY KEY,
    melhor_resposta BOOLEAN DEFAULT FALSE,
    CONSTRAINT fk_resposta_conteudo
        FOREIGN KEY (id_conteudo) 
        REFERENCES Conteudo (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE Pergunta_Tags (
    id_conteudo INT,
    tag VARCHAR(50),
    PRIMARY KEY (id_conteudo, tag),
    CONSTRAINT fk_tags_pergunta
        FOREIGN KEY (id_conteudo) 
        REFERENCES Pergunta (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE Etapa (
    id_conteudo_resposta INT,
    num_etapa INT,
    descricao TEXT NOT NULL,
    anexo_imagem VARCHAR(255),
    PRIMARY KEY (id_conteudo_resposta, num_etapa),
    CONSTRAINT fk_etapa_resposta
        FOREIGN KEY (id_conteudo_resposta) 
        REFERENCES Resposta (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE Tentativa (
    id_tentativa SERIAL PRIMARY KEY,
    texto_resolucao TEXT NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_correto BOOLEAN NOT NULL,
    id_estudante INT NOT NULL,
    id_pergunta INT NOT NULL,
    CONSTRAINT fk_tentativa_estudante
        FOREIGN KEY (id_estudante) 
        REFERENCES Estudante (id_usuario) 
        ON DELETE CASCADE,
    CONSTRAINT fk_tentativa_pergunta
        FOREIGN KEY (id_pergunta) 
        REFERENCES Pergunta (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE Pergunta_Resposta (
    id_pergunta INT,
    id_resposta INT,
    PRIMARY KEY (id_pergunta, id_resposta),
    CONSTRAINT fk_pergunta_resposta_pergunta
        FOREIGN KEY (id_pergunta) 
        REFERENCES Pergunta (id_conteudo) 
        ON DELETE CASCADE,
    CONSTRAINT fk_pergunta_resposta_resposta
        FOREIGN KEY (id_resposta) 
        REFERENCES Resposta (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE Avalia (
    id_avaliacao SERIAL PRIMARY KEY,
    pontuacao INT NOT NULL,
    id_usuario INT NOT NULL,
    id_resposta INT NOT NULL,
    CONSTRAINT fk_avalia_usuario
        FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE,
    CONSTRAINT fk_avalia_resposta
        FOREIGN KEY (id_resposta) 
        REFERENCES Resposta (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE Notificacao (
    id_notificacao SERIAL PRIMARY KEY,
    status_leitura BOOLEAN DEFAULT FALSE,
    mensagem_texto VARCHAR(255) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    id_usuario INT NOT NULL,
    CONSTRAINT fk_notificacao_usuario
        FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE
);

CREATE TABLE Denuncia (
    id_usuario INT,
    id_conteudo INT,
    motivo VARCHAR(255) NOT NULL,
    data_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_usuario, id_conteudo),
    CONSTRAINT fk_denuncia_usuario
        FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE,
    CONSTRAINT fk_denuncia_conteudo
        FOREIGN KEY (id_conteudo) 
        REFERENCES Conteudo (id_conteudo) 
        ON DELETE CASCADE
);

CREATE TABLE usuario_realiza_tentativa (
    id_usuario INT,
    id_tentativa INT,
    PRIMARY KEY (id_usuario, id_tentativa), -- Chave Primária Composta
    CONSTRAINT fk_realiza_usuario
        FOREIGN KEY (id_usuario) 
        REFERENCES Usuario (id_usuario) 
        ON DELETE CASCADE,
    CONSTRAINT fk_realiza_tentativa
        FOREIGN KEY (id_tentativa) 
        REFERENCES Tentativa (id_tentativa) 
        ON DELETE CASCADE
);


-- ============================================================
-- SCRIPT DE INSERÇÃO DE DADOS
-- Plataforma de Resolução Colaborativa de Exercícios
-- ============================================================
-- ==================== USUARIO ====================
INSERT INTO Usuario (email, p_nome, sobrenome, senha, modo_focado, foto, biografia) VALUES
('grazyele@alu.ufc.br',   'Maria',    'Grazyele',  'senha123', FALSE, NULL, 'Estudante de SI apaixonada por banco de dados.'),
('ivna@alu.ufc.br',        'Ivna',     'Leite',     'senha123', FALSE, NULL, 'Gosto de resolver problemas complexos.'),
('joaopedro@alu.ufc.br',   'João',     'Pedro',     'senha123', TRUE,  NULL, 'Curioso por tecnologia e inovação.'),
('carlos@email.com',       'Carlos',   'Mendes',    'senha456', FALSE, NULL, 'Professor de Matemática há 10 anos.'),
('fernanda@email.com',     'Fernanda', 'Souza',     'senha456', FALSE, NULL, 'Especialista em Física Quântica.'),
('lucas@email.com',        'Lucas',    'Almeida',   'senha789', TRUE,  NULL, 'Estudante de Engenharia.'),
('amanda@email.com',       'Amanda',   'Costa',     'senha789', FALSE, NULL, 'Amo Cálculo e Álgebra Linear.'),
('rafael@email.com',       'Rafael',   'Nunes',     'senha321', FALSE, NULL, 'Colaborador voluntário da plataforma.'),
('beatriz@email.com',      'Beatriz',  'Lima',      'senha321', TRUE,  NULL, 'Estudante de Computação.'),
('thiago@email.com',       'Thiago',   'Ferreira',  'senha654', FALSE, NULL, 'Colaborador especialista em Química.');

-- ==================== ESTUDANTE ====================
INSERT INTO Estudante (id_usuario, curso) VALUES
(1, 'Sistemas de Informação'),
(2, 'Sistemas de Informação'),
(3, 'Sistemas de Informação'),
(6, 'Engenharia Civil'),
(7, 'Ciência da Computação'),
(9, 'Ciência da Computação'),
(8, NULL),
(10, NULL);

-- ==================== COLABORADOR ====================
INSERT INTO Colaborador (id_usuario) VALUES
(4),
(5),
(8),
(10);

-- ==================== AFINIDADE_COLABORADOR ====================
INSERT INTO Afinidade_Colaborador (id_usuario, afinidade) VALUES
(4, 'Matemática'),
(4, 'Álgebra Linear'),
(5, 'Física'),
(5, 'Termodinâmica'),
(8, 'Programação'),
(8, 'Banco de Dados'),
(10, 'Química'),
(10, 'Química Orgânica'),
(4, 'Cálculo'),
(5, 'Mecânica Clássica');

-- ==================== SEGUE ====================
INSERT INTO Segue (id_seguidor, id_seguido) VALUES
(1, 4),
(1, 5),
(2, 4),
(3, 8),
(6, 4),
(7, 5),
(9, 10),
(1, 3),
(2, 3),
(6, 10);

-- ==================== DISCIPLINA ====================
INSERT INTO Disciplina (nome) VALUES
('Matemática'),
('Física'),
('Química'),
('Programação'),
('Banco de Dados'),
('Álgebra Linear'),
('Cálculo'),
('Estatística'),
('Redes de Computadores'),
('Engenharia de Software');

-- ==================== CONTEUDO (Perguntas) ====================
INSERT INTO Conteudo (corpo_do_texto, id_autor) VALUES
('Como resolver uma integral por partes?', 1),
('Qual é a diferença entre vetor e escalar?', 2),
('Como balancear equações químicas?', 3),
('O que é recursão em programação?', 6),
('Como funciona uma chave estrangeira no SQL?', 7),
('Qual a derivada de sen(x)?', 1),
('Como calcular o determinante de uma matriz 3x3?', 9),
('O que é desvio padrão?', 2),
('Como funciona o modelo OSI?', 3),
('O que é um diagrama ER?', 6);

-- ==================== PERGUNTA ====================
INSERT INTO Pergunta (id_conteudo, titulo_resumido, status_resolvido, anexo_imagem, id_disciplina, id_estudante_criador) VALUES
(1,  'Integral por partes',         FALSE, NULL, 7, 1),
(2,  'Vetor vs Escalar',            TRUE,  NULL, 2, 2),
(3,  'Balancear equações',          FALSE, NULL, 3, 3),
(4,  'O que é recursão?',           TRUE,  NULL, 4, 6),
(5,  'Chave estrangeira no SQL',    FALSE, NULL, 5, 7),
(6,  'Derivada de sen(x)',          TRUE,  NULL, 7, 1),
(7,  'Determinante 3x3',            FALSE, NULL, 6, 9),
(8,  'Desvio padrão',               FALSE, NULL, 8, 2),
(9,  'Modelo OSI',                  TRUE,  NULL, 9, 3),
(10, 'O que é diagrama ER?',        FALSE, NULL, 5, 6);

-- ==================== PERGUNTA_TAGS ====================
INSERT INTO Pergunta_Tags (id_conteudo, tag) VALUES
(1,  'cálculo'),
(1,  'integral'),
(2,  'física'),
(3,  'química'),
(4,  'recursão'),
(4,  'algoritmo'),
(5,  'sql'),
(6,  'derivada'),
(7,  'matriz'),
(10, 'banco de dados');

-- ==================== CONTEUDO (Respostas) ====================
INSERT INTO Conteudo (corpo_do_texto, id_autor) VALUES
('Para resolver integral por partes, use a fórmula ∫u dv = uv - ∫v du.', 4),
('Escalar é uma grandeza com apenas módulo. Vetor possui módulo, direção e sentido.', 5),
('Para balancear, ajuste os coeficientes de cada elemento dos dois lados.', 10),
('Recursão é quando uma função chama a si mesma com um caso base para parar.', 8),
('FK é uma coluna que referencia a PK de outra tabela, garantindo integridade referencial.', 4),
('A derivada de sen(x) é cos(x), pela regra das derivadas trigonométricas.', 5),
('Calcule o determinante expandindo pela primeira linha usando cofatores.', 4),
('Desvio padrão mede a dispersão dos dados em relação à média.', 8),
('O modelo OSI possui 7 camadas: física, enlace, rede, transporte, sessão, apresentação e aplicação.', 10),
('Diagrama ER representa entidades, atributos e relacionamentos de um banco de dados.', 4);

-- ==================== RESPOSTA ====================
INSERT INTO Resposta (id_conteudo, melhor_resposta) VALUES
(11, FALSE),
(12, TRUE),
(13, FALSE),
(14, TRUE),
(15, FALSE),
(16, TRUE),
(17, FALSE),
(18, FALSE),
(19, TRUE),
(20, FALSE);

-- ==================== PERGUNTA_RESPOSTA ====================
INSERT INTO Pergunta_Resposta (id_pergunta, id_resposta) VALUES
(1,  11),
(2,  12),
(3,  13),
(4,  14),
(5,  15),
(6,  16),
(7,  17),
(8,  18),
(9,  19),
(10, 20);

-- ==================== ETAPA ====================
INSERT INTO Etapa (id_conteudo_resposta, num_etapa, descricao, anexo_imagem) VALUES
(11, 1, 'Identifique as funções u e dv na integral.', NULL),
(11, 2, 'Calcule du (derivada de u) e v (integral de dv).', NULL),
(11, 3, 'Aplique a fórmula: uv - ∫v du.', NULL),
(14, 1, 'Defina o caso base da recursão.', NULL),
(14, 2, 'Defina a chamada recursiva reduzindo o problema.', NULL),
(16, 1, 'Relembre que sen(x) é função trigonométrica básica.', NULL),
(16, 2, 'Aplique a regra: d/dx[sen(x)] = cos(x).', NULL),
(19, 1, 'Camada 1 (Física): transmissão de bits.', NULL),
(19, 2, 'Camada 3 (Rede): endereçamento IP.', NULL),
(19, 3, 'Camada 7 (Aplicação): protocolos como HTTP e FTP.', NULL);

-- ==================== TENTATIVA ====================
INSERT INTO Tentativa (texto_resolucao, status_correto, id_estudante, id_pergunta) VALUES
('Tentei usar substituição simples mas não funcionou.', FALSE, 1, 1),
('Vetor tem direção e escalar não.', TRUE,  2, 2),
('Adicionei H2O para balancear mas errei os coeficientes.', FALSE, 3, 3),
('Fiz a função chamar ela mesma sem caso base e entrou em loop.', FALSE, 6, 4),
('Coloquei a FK na tabela errada.', FALSE, 7, 5),
('Achei que era -sen(x).', FALSE, 1, 6),
('Calculei só o determinante 2x2.', FALSE, 9, 7),
('Somei todos e dividi pela quantidade.', FALSE, 2, 8),
('Lembrei só de 5 camadas do OSI.', FALSE, 3, 9),
('Desenhei o diagrama sem chaves primárias.', FALSE, 6, 10);

-- ==================== USUARIO_REALIZA_TENTATIVA ====================
INSERT INTO usuario_realiza_tentativa (id_usuario, id_tentativa) VALUES
(1, 1),
(2, 2),
(3, 3),
(6, 4),
(7, 5),
(1, 6),
(9, 7),
(2, 8),
(3, 9),
(6, 10);

-- ==================== AVALIA ====================
INSERT INTO Avalia (pontuacao, id_usuario, id_resposta) VALUES
(5, 1, 11),
(4, 2, 12),
(3, 3, 13),
(5, 6, 14),
(4, 7, 15),
(5, 1, 16),
(3, 9, 17),
(4, 2, 18),
(5, 3, 19),
(4, 6, 20);

-- ==================== NOTIFICACAO ====================
INSERT INTO Notificacao (status_leitura, mensagem_texto, id_usuario) VALUES
(FALSE, 'Sua pergunta sobre integral recebeu uma resposta!', 1),
(TRUE,  'Sua resposta foi marcada como a melhor!', 5),
(FALSE, 'Você recebeu uma nova avaliação na sua resposta.', 4),
(FALSE, 'Nova pergunta na disciplina de Física.', 2),
(TRUE,  'Sua pergunta foi marcada como resolvida.', 2),
(FALSE, 'Um colaborador respondeu sua dúvida de SQL.', 7),
(FALSE, 'Você tem uma nova notificação de seguidor.', 3),
(TRUE,  'Sua resposta sobre recursão foi avaliada com 5 estrelas!', 8),
(FALSE, 'Nova pergunta em Banco de Dados.', 9),
(FALSE, 'Seu perfil foi visualizado por um colaborador.', 6);

-- ==================== DENUNCIA ====================
INSERT INTO Denuncia (id_usuario, id_conteudo, motivo) VALUES
(1,  3,  'Conteúdo duplicado com outra pergunta já existente.'),
(2,  4,  'Texto sem contexto suficiente para ser respondido.'),
(3,  5,  'Pergunta fora da disciplina selecionada.'),
(6,  7,  'Resposta com informações incorretas.'),
(7,  8,  'Linguagem inadequada no texto.'),
(9,  9,  'Conteúdo copiado de outra fonte sem referência.'),
(1,  10, 'Pergunta repetida já respondida anteriormente.'),
(2,  11, 'Resposta incompleta e enganosa.'),
(3,  13, 'Imagem anexada com conteúdo inapropriado.'),
(6,  15, 'Resposta não responde à pergunta feita.');


