-- Criação e seleção do banco de dados
CREATE DATABASE eLogiWare;
USE eLogiWare;

-- Criação da tabela de funcionários
CREATE TABLE Funcionarios (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    cargo VARCHAR(50),
    departamento VARCHAR (25),
    turno VARCHAR (25),
    data_admissao DATE
);

-- Criação da tabela de clientes
CREATE TABLE Clientes (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    telefone VARCHAR(14),
    email VARCHAR(50),
    data_cadastro DATE
);

-- Criação da tabela de produtos
CREATE TABLE Produtos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL
);

-- Criação de tabela auxiliar para definir o status da produção
CREATE TABLE StatusMaquina (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome_status VARCHAR(25) UNIQUE
);

INSERT INTO StatusMaquina (nome_status) VALUES ('Pronta'), ('Em produção'), ('Em manutenção'), ('Desligada'), ('Instalando');

-- Criação da tabela de máquinas da produção
CREATE TABLE Maquinas (
	id INT AUTO_INCREMENT PRIMARY KEY,
    sigla CHAR(5) NOT NULL,
    setor VARCHAR(25),
    data_instalacao DATE,
    status_id INT NOT NULL,
    FOREIGN KEY (status_id) REFERENCES StatusMaquina(id)
);

-- Criação da tabela de produção
CREATE TABLE Producao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    funcionario_id INT NOT NULL,
    maquina_id INT NOT NULL,
    quantidade INT NOT NULL DEFAULT 0,
    inicio_data_producao TIMESTAMP,
    tempo_producao TIME NOT NULL DEFAULT '00:00:00', 
    FOREIGN KEY (produto_id) REFERENCES Produtos(id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(id),
    FOREIGN KEY (maquina_id) REFERENCES Maquinas(id) 
);

-- Criação da tabela do estoque
CREATE TABLE Estoque (
	id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL UNIQUE,
    quantidade INT NOT NULL,
	ultima_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

-- Criação de tabela auxiliar para definir o tipo de movimentação do estoque
CREATE TABLE TipoMovimentacao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome_tipo VARCHAR(25) UNIQUE
);

INSERT INTO TipoMovimentacao (nome_tipo) VALUES ('Entrada'), ('Saída');

-- Criação de tabela para registro de movimentações do estoque
CREATE TABLE MovimentacoesEstoque (
    id INT AUTO_INCREMENT PRIMARY KEY,
    produto_id INT NOT NULL,
    data_movimentacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    tipo_id INT NOT NULL,
    quantidade INT NOT NULL,
    descricao VARCHAR(255),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id),
    FOREIGN KEY (tipo_id) REFERENCES TipoMovimentacao(id)
);

-- Criação de tabela auxiliar para definir o tipo de manutenção
CREATE TABLE TipoManutencao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome_tipo VARCHAR(25) UNIQUE
);

INSERT INTO TipoManutencao (nome_tipo) VALUES ('Instalacao'), ('Manutencao'); 

-- Criação de tabela de manutenção
CREATE TABLE Manutencao (
	id INT AUTO_INCREMENT PRIMARY KEY,
    funcionario_id INT NOT NULL,
    maquina_id INT NOT NULL,
    inicio_manutencao TIMESTAMP,
    tipo_id INT NOT NULL,
    tempo_manutencao TIME NOT NULL DEFAULT '00:00:00',
    descricao VARCHAR(255),
    FOREIGN KEY (tipo_id) REFERENCES TipoManutencao(id) 
);

-- Criação de tabela auxiliar para definir o status do pedido
CREATE TABLE StatusPedido (
	id INT AUTO_INCREMENT PRIMARY KEY,
    nome_status VARCHAR(25) UNIQUE
);

INSERT INTO StatusPedido (nome_status) VALUES ('Ativo'), ('Cancelado');

-- Criação de tabela de pedidos
CREATE TABLE Pedidos (
	id INT AUTO_INCREMENT PRIMARY KEY,
    cliente_id INT NOT NULL,
    funcionario_id INT NOT NULL,
    valor_total DECIMAL(10, 2) NOT NULL,
    data_pedido DATE,
    status_id INT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES Clientes(id),
    FOREIGN KEY (funcionario_id) REFERENCES Funcionarios(id),
    FOREIGN KEY (status_id) REFERENCES StatusPedido(id)
);

-- Criação de tabela de itens totais do pedido
CREATE TABLE ItensPedido (
	id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    qtd INT NOT NULL,
    valor_unitario DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

-- Criação de tabela para devolução de produto
CREATE TABLE Devolucoes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    pedido_id INT NOT NULL,
    produto_id INT NOT NULL,
    qtd INT NOT NULL,
    data_devolucao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descricao VARCHAR (255),
    FOREIGN KEY (pedido_id) REFERENCES Pedidos(id),
    FOREIGN KEY (produto_id) REFERENCES Produtos(id)
);

-- Verificação das quantidades totais de produtos e preços no estoque
CREATE VIEW vw_verificar_estoque AS
SELECT 
	p.id AS produto_id,
	p.nome,
	SUM(e.quantidade) AS quantidade_total,
	p.preco,
	(p.preco * SUM(e.quantidade)) AS preco_total
FROM Produtos p
LEFT JOIN Estoque e ON p.id = e.produto_id
GROUP BY p.id, p.nome, p.preco;

-- Verificação de pedidos feitos
CREATE VIEW vw_visualizar_pedidos AS
SELECT
	p.id AS pedido_id,
    c.nome AS cliente,
    f.nome AS funcionario,
    p.data_pedido,
    pr.nome AS produto,
    i.qtd,
    i.valor_unitario,
    (i.qtd * i.valor_unitario) AS total_item,
    tot.valor_total
FROM Pedidos p
JOIN Clientes c ON p.cliente_id = c.id
JOIN Funcionarios f ON p.funcionario_id = f.id
JOIN ItensPedido i ON i.pedido_id = p.id
JOIN Produtos pr ON i.produto_id = pr.id
JOIN (
	SELECT
		pedido_id,
        SUM(qtd * valor_unitario) AS valor_total
	FROM ItensPedido
    GROUP BY pedido_id
) AS tot ON tot.pedido_id = p.id;

DELIMITER $$
-- Criação de PROCEDURE para busca de funcionários por departamento
CREATE PROCEDURE sp_buscar_funcionarios_departamento (IN depto_input VARCHAR(25))
BEGIN
	SELECT * FROM Funcionarios WHERE departamento = depto_input;
    SELECT COUNT(*) AS total_funcionarios FROM Funcionarios WHERE departamento = depto_input;
END $$

-- Criação de PROCEDURE para busca de funcionários por cargo
CREATE PROCEDURE sp_buscar_funcionarios_cargo (IN cargo_input VARCHAR(100))
BEGIN
	SELECT * FROM Funcionarios WHERE cargo = cargo_input;
    SELECT COUNT(*) AS total_funcionarios FROM Funcionarios WHERE cargo = cargo_input;
END $$

-- Criação de PROCEDURE para busca de funcionários por ano de admissão
CREATE PROCEDURE sp_buscar_funcionario_ano_admissao(IN ano INT)
BEGIN
	SELECT * FROM Funcionarios WHERE YEAR(data_admissao) = ano;
    SELECT COUNT(*) AS total_funcionarios FROM Funcionarios WHERE YEAR(data_admissao) = ano;
END $$

-- Criação de PROCEDURE para registro do início de produção
CREATE PROCEDURE sp_inicio_producao (
	IN id_prod INT,
    IN id_func INT,
    IN maq INT)
BEGIN
	DECLARE funcionario_id INT;
    DECLARE produto_id_local INT;
    DECLARE maquina_id INT;
    DECLARE status_id VARCHAR(25);
    DECLARE cont INT DEFAULT 0;
    
    SET produto_id_local = id_prod;
    SET maquina_id = maq;
    
    SELECT COUNT(*) INTO cont FROM Produtos WHERE id = id_prod;
	IF cont = 0 THEN 
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não cadastrado ou inexistente.';
	END IF;
    
    SELECT id INTO funcionario_id FROM Funcionarios WHERE id = id_func;
	IF funcionario_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário(a) não cadastrado(a) ou inexistente.';
	END IF;
    
    SELECT sm.nome_status INTO status_id FROM Maquinas m
    JOIN StatusMaquina sm ON m.status_id = sm.id
    WHERE m.id = maq;
    IF status_id != 'Pronta' THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'A máquina não pode iniciar a produção no momento.';
	END IF;
        
	INSERT INTO Producao (produto_id, funcionario_id, maquina_id, inicio_data_producao)
    VALUES (produto_id, funcionario_id, maquina_id, NOW());
END $$

-- Criação de PROCEDURE para registro do fim de produção
CREATE PROCEDURE sp_fim_producao (
	IN id_producao INT,
    IN qtd_produzida INT)
BEGIN
	DECLARE inicio TIMESTAMP;
    DECLARE tempo_total TIME;
    
    SELECT inicio_data_producao INTO inicio FROM Producao WHERE id = id_producao;
    SET tempo_total = TIMEDIFF(NOW(), inicio);
    
    UPDATE Producao
    SET quantidade = qtd_produzida, tempo_producao = tempo_total
	WHERE id = id_producao;
END $$

-- Criação de PROCEDURE para início de uma manutenção
CREATE PROCEDURE sp_inicio_manut_inst (
	IN m_maquina_id INT,
    IN m_funcionario_id INT,
    IN m_processo VARCHAR(25))
BEGIN
	DECLARE existe_maquina INT;
    DECLARE existe_funcionario INT;
    DECLARE tipo_manut_id INT;
    DECLARE status_maq_id INT;

	SELECT COUNT(*) INTO existe_maquina FROM Maquinas WHERE id = m_maquina_id;
    IF existe_maquina = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Máquina não cadastrada ou inexistente.';
	END IF;
    
    SELECT COUNT(*) INTO existe_funcionario FROM Funcionarios WHERE id = m_funcionario_id;
    IF existe_funcionario = 0 THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Funcionário(a) não cadastrado(a) ou inexistente.';
	END IF;
    
    SELECT id INTO tipo_manut_id FROM TipoManutencao WHERE nome_tipo = m_processo;
    
    IF tipo_manut_id IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este processo não existe';
	END IF;
    
	IF m_status_maq = 'Manutenção' THEN
		SELECT id INTO status_maq_id FROM StatusMaquina WHERE nome_status = 'Em manutenção';
	ELSEIF m_status_maq = 'Instalação' THEN
		SELECT id INTO status_maq_id FROM StatusMaquina WHERE nome_status = 'Instalando';
	ELSE
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Status inexistente';
	END IF;
    
    UPDATE Maquinas 
    SET status_id = status_maqu_id
    WHERE id = m_maquina_id;
    
    INSERT INTO Manutencao (funcionario_id, maquina_id, inicio_manutencao, tipo_id)
    VALUES (m_funcionario_id, m_maquina_id, NOW(), tipo_manut_id);
END $$

-- Criação de PROCEDURE para fim de uma manutenção
CREATE PROCEDURE sp_fim_manut_inst (
	IN m_manutencao_id INT,
    IN m_descricao TEXT,
    IN m_status_maq VARCHAR(25))
BEGIN
	DECLARE d_inicio TIMESTAMP;
    DECLARE d_tempo_total TIME;
    DECLARE d_maquina_id INT;
    
    SELECT inicio_manutencao, maquina_id INTO d_inicio, d_maquina_id FROM Manutencao WHERE id = m_manutencao_id;
	IF d_inicio IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Manutenção inexistente.';
	END IF;
    
    SET d_tempo_total = TIMEDIFF(NOW(), d_inicio);
    
    UPDATE Manutencao
    SET tempo_manutencao = d_tempo_total, descricao = m_descricao WHERE id = m_manutencao_id;
    
    UPDATE Maquinas
    SET STATUS = m_status_maq
    WHERE id = d_maquina_id;
END $$

-- Criação de TRIGGER para atualização do estoque após término de produção
CREATE TRIGGER trg_atualiza_estoque
AFTER UPDATE ON Producao
FOR EACH ROW
BEGIN
	IF NEW.quantidade > 0 AND NEW.quantidade != OLD.quantidade THEN
		IF EXISTS (
			SELECT 1 FROM Estoque WHERE produto_id = NEW.produto_id
		) THEN
			UPDATE Estoque
            SET quantidade = quantidade + NEW.quantidade
            WHERE produto_id = NEW.produto_id;
		ELSE
			INSERT INTO Estoque (produto_id, quantidade)
            VALUES (NEW.produto_id, NEW.quantidade);
		END IF;
	END IF;
END $$

-- Criação de TRIGGER para verificar produto no estoque antes do pedido ser feito
CREATE TRIGGER trg_verifica_estoque
BEFORE INSERT ON ItensPedido
FOR EACH ROW
BEGIN
    DECLARE estoque_atual INT;
    DECLARE pedido_status VARCHAR(25);

    SELECT sp.nome_status INTO pedido_status FROM Pedidos p 
    JOIN StatusPedido sp ON p.status_id = sp.id
    WHERE id = NEW.pedido_id;
    IF pedido_status = 'Ativo' THEN
        SELECT quantidade INTO estoque_atual
        FROM Estoque
        WHERE produto_id = NEW.produto_id;
        IF estoque_atual IS NULL OR estoque_atual < NEW.qtd THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Estoque insuficiente para o produto.';
		END IF;
	ELSE
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este pedido foi cancelado';
    END IF;
END $$

-- Criação de TRIGGER para dedução de produto após verificação do estoque
CREATE TRIGGER trg_deduz_estoque_pedido
AFTER INSERT ON ItensPedido
FOR EACH ROW
BEGIN
    DECLARE pedido_status VARCHAR(25);
    DECLARE tipo_saida_id INT;

    SELECT sp.nome_status INTO pedido_status FROM Pedidos p
    JOIN StatusPedido sp ON p.status_id = sp.id
    WHERE p.id = NEW.pedido_id;
    
	SELECT id INTO tipo_saida_id FROM TipoMovimentacao WHERE nome_tipo = 'Saída';
    
    IF pedido_status = 'Ativo' THEN
        UPDATE Estoque
        SET quantidade = quantidade - NEW.qtd, ultima_movimentacao = NOW()
        WHERE produto_id = NEW.produto_id;
        
		INSERT INTO MovimentacoesEstoque (produto_id, tipo_id, quantidade, descricao)
        VALUES (NEW.produto_id, tipo_saida_id, NEW.qtd, CONCAT('Pedido #', NEW.pedido_id));
	ELSE
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Este pedido foi cancelado';
    END IF;
END $$

-- Criação de TRIGGER para cancelamento do pedido
CREATE TRIGGER trg_cancelamento_pedido
AFTER UPDATE ON Pedidos
FOR EACH ROW
BEGIN
    IF NEW.status_id = (SELECT id FROM StatusPedido WHERE nome_status = 'Cancelado') 
    AND OLD.status_id <> NEW.status_id THEN
    UPDATE Estoque e
    JOIN ItensPedido ip ON ip.produto_id = e.produto_id
    SET e.quantidade = e.quantidade + ip.qtd, e.ultima_movimentacao = NOW()
    WHERE ip.pedido_id = NEW.id;
    
    INSERT INTO MovimentacoesEstoque(
		produto_id,
        tipo_id,
        quantidade,
        data_movimentacao,
        descricao
    )
    SELECT 
		ip.produto_id, 
		(SELECT id FROM TipoMovimentacao WHERE nome_tipo = 'Entrada'), 
		ip.qtd,
		NOW(),
        CONCAT('Reentrada por cancelamento do Pedido ID ', NEW.id)
        FROM ItensPedido ip
        WHERE ip.pedido_id = NEW.id;
	END IF;
END $$

-- Criação de TRIGGER para entrada de estoque após devolução
CREATE PROCEDURE sp_devolver_produto (
    IN p_pedido_id INT,
    IN p_produto_id INT,
    IN p_qtd_devolvida INT,
    IN p_descricao TEXT
)
BEGIN
    DECLARE qtd_pedida INT;
    DECLARE pedido_status VARCHAR(25);
    
	SELECT sp.nome_status INTO pedido_status FROM Pedidos p
    JOIN StatusPedido sp ON p.status_id = sp.id
    WHERE p.id = p_pedido_id;
    IF pedido_status IS NULL THEN
		SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Pedido não encontrado.';
	END IF;
    
    IF pedido_status != 'Ativo' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Não é possível devolver produto de pedido cancelado.';
    END IF;

    SELECT qtd INTO qtd_pedida
    FROM ItensPedido
    WHERE pedido_id = p_pedido_id AND produto_id = p_produto_id;

    IF qtd_pedida IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Produto não faz parte do pedido.';
    END IF;

    IF p_qtd_devolvida > qtd_pedida THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Quantidade devolvida excede a quantidade pedida.';
    END IF;

    UPDATE Estoque
    SET 
        quantidade = quantidade + p_qtd_devolvida,
        ultima_movimentacao = NOW()
    WHERE produto_id = p_produto_id;

    INSERT INTO MovimentacoesEstoque (produto_id, tipo, quantidade, descricao)
    VALUES (p_produto_id, 'Entrada', p_qtd_devolvida, CONCAT('Devolução Pedido #', p_pedido_id));

    INSERT INTO Devolucoes (pedido_id, produto_id, qtd, data_devolucao, descricao)
    VALUES (p_pedido_id, p_produto_id, p_qtd_devolvida, NOW(), p_descricao);
END $$

-- Criação de TRIGGER para atualizar o status da máquina após iniciar uma produção
CREATE TRIGGER trg_maquina_status_producao
AFTER INSERT ON Producao
FOR EACH ROW
BEGIN
	UPDATE Maquinas
	SET STATUS = status_id = (
		SELECT id FROM StatusMaquina WHERE nome = 'Em produção' LIMIT 1
    )
    WHERE id = NEW.maquina_id;
END $$

-- Criação de TRIGGER para atualizar o status da máquina após finalizar uma produção
CREATE TRIGGER trg_maquina_status_fim_producao
AFTER UPDATE ON Producao
FOR EACH ROW
BEGIN
	IF OLD.status_producao_id <> NEW.status_producao_id AND NEW.status_producao_id = 2 THEN
		UPDATE Maquinas
		SET status_id = (SELECT id FROM StatusMaquina WHERE nome = 'Pronta')
		WHERE id = NEW.maquina_id;
	END IF;
END $$

DELIMITER ;       