DELIMITER ;

USE sistema_bancario;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_cadastrar (
    IN p_nome            VARCHAR(100),
    IN p_email           VARCHAR(100),
    IN p_telefone        VARCHAR(15),
    IN p_endereco        VARCHAR(255),
    IN p_username        VARCHAR(50),
    IN p_password        VARCHAR(255),
    IN p_cpf             VARCHAR(14),
    IN p_data_nascimento DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (p_nome, p_email, p_telefone, p_endereco, p_username, p_password);

    SET @last_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PF (cliente_id, cpf, data_nascimento)
    VALUES (@last_id, p_cpf, p_data_nascimento);

    COMMIT;
END $$

DELIMITER ;

CREATE PROCEDURE IF NOT EXISTS clientePF_alterar(
    IN p_nome            VARCHAR(100),
    IN p_email           VARCHAR(100),
    IN p_telefone        VARCHAR(15),
    IN p_endereco        VARCHAR(255),
    IN p_username        VARCHAR(50),
    IN p_password        VARCHAR(255),
    IN p_cpf             VARCHAR(14),
    IN p_data_nascimento DATE,
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Clientes 
    SET (nome = p_nome, email = p_email, telefone = p_telefone, endereco = p_endereco, username = p_username, password = p_password);

    SET @last_id = LAST_INSERT_ID();

    UPDATE Clientes_PF
    SET (cliente_id = @last_id, cpf = p_cpf, data_nascimento = p_data_nascimento);

    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_deletar(
    IN p_cpf VARCHAR(14) NOT NULL UNIQUE,
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM Clientes_PF
    WHERE (cpf = p_cpf);

    COMMIT;
END $$
DELIMITER ;

DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePF_consultarTodosFiltroNome(
    IN p_nome            VARCHAR(100),
    IN p_email           VARCHAR(100),
    IN p_telefone        VARCHAR(15),
    IN p_endereco        VARCHAR(255),
    IN p_username        VARCHAR(50),
    IN p_password        VARCHAR(255),
    IN p_cpf             VARCHAR(14),
    IN p_data_nascimento DATE,
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT 
        Clientes.nome,
        Clientes.email,
        Clientes.telefone,
        Clientes.endereco,
        Clientes.username,
        Clientes.password,
        Clientes_PF.cpf,
        Clientes_PF.data_nascimento
    FROM
        Clientes_PF,
        Clientes
    INNER JOIN 
        Clientes ON Clientes_PF.cliente_id = Clientes.id
    WHERE
        nome LIKE CONCAT('%', p_nome ,'%');

    COMMIT;
END $$
DELIMITER;


DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePJ_cadastrar (
    IN p_nome          VARCHAR(100),
    IN p_email         VARCHAR(100),
    IN p_telefone      VARCHAR(15),
    IN p_endereco      VARCHAR(255),
    IN p_username      VARCHAR(50),
    IN p_password      VARCHAR(255),
    IN p_cnpj          VARCHAR(18) NOT NULL UNIQUE,
    IN p_razao_social  VARCHAR(100),
    IN p_data_fundacao DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (p_nome, p_email, p_telefone, p_endereco, p_username, p_password);

    SET @last_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PJ (cliente_id, cnpj, razao_social, data_fundacao)
    VALUES (@last_id, p_cnpj, p_razao_social, p_data_fundacao);

    COMMIT;
END $$

DELIMITER ;



DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePJ_alterar(
    IN p_nome          VARCHAR(100),
    IN p_email         VARCHAR(100),
    IN p_telefone      VARCHAR(15),
    IN p_endereco      VARCHAR(255),
    IN p_username      VARCHAR(50),
    IN p_password      VARCHAR(255),
    IN p_cnpj          VARCHAR(18) NOT NULL UNIQUE,
    IN p_razao_social  VARCHAR(100),
    IN p_data_fundacao DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Clientes 
    SET (nome = p_nome, email = p_email, telefone = p_telefone, endereco = p_endereco, username = p_username, password = p_password);

    SET @last_id = LAST_INSERT_ID();

    UPDATE Clientes_PJ
    SET (cliente_id = @last_id, cnpj = p_cnpj, razao_social = p_razao_social, data_fundacao = p_data_fundacao);

    COMMIT;
END $$
DELIMITER ;



DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS clientePJ_deletar(
    IN p_cnpj VARCHAR(18) NOT NULL UNIQUE,
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM Clientes_PJ
    WHERE (cnpj = p_cnpj);

    COMMIT;
END $$
DELIMITER ;


DELIMITER $$
CREATE PROCEDURE IF NOT EXISTS contas_cadastrar(
    IN p_cnpj VARCHAR(18) NOT NULL UNIQUE,
    IN p_tipo_conta ENUM('corrente', 'poupanca'),
    IN p_saldo DECIMAL(15, 2) DEFAULT 0.00,
    IN p_limite DECIMAL(15, 2) DEFAULT 0.00,
    IN p_status ENUM('ativa', 'inativa') DEFAULT 'ativa'
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    SELECT cnpj FROM Clientes_PJ

    INSERT INTO Contas (cliente, tipo_conta, saldo, limite, status)
    VALUES (cliente, p_tipo_conta, p_saldo, p_limite, p_status);
    
    COMMIT;
END $$
DELIMITER ;



CREATE PROCEDURE if not EXISTS consultar+_transacoes()
begin
    SELECT * FROM Transacoes;
END$$

CREATE PROCEDURE if not EXISTS consultar_transacoesByID (IN TransacoesID INT )
begin
    SELECT * FROM Transacoes WHERE id = TransacoesID;
END$$

CREATE PROCEDURE if not EXISTS sacar(
    IN _conta_Id Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo - _valor
    WHERE id = _conta_Id
    INSERT into Transacoes(conta_Id, tipo, valor, descricao)
    VALUES(_conta_Id, 'saque', _valor, _descricao);
END$$

CREATE PROCEDURE if not EXISTS depositar(
    IN _conta_Id Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo + _valor
    WHERE id = _conta_Id
    INSERT into Transacoes(conta_Id, tipo, valor, descricao)
    VALUES(_conta_Id, 'Deposito', _valor, _descricao);
END$$

CREATE PROCEDURE if not EXISTS transferir(
    IN _contaOrigemId Int,
    IN _contaDestinoId Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    CALL sacar(_contaOrigemId, _valor, 'Transferencia', _descricao),
    CALL depositar(_contaDestinoId, _valor, 'Transferencia', _descricao)








USE sistema_bancario; 

DELIMITER $$ 

CREATE PROCEDURE if not EXISTS p_consultarPFisica()
Begin
    SELECT * FROM Clientes_PF;
End$$

CREATE PROCEDURE if not EXISTS p_consultarPFisicaByCPF (IN cpf varchar(14))
begin
    SELECT * FROM Clientes_PF WHERE cpf = cpf;
END$$

CREATE procedure if not EXISTS  p_cadastrarClientePF (
    IN _nome varchar(255),
    IN _email varchar(255),
    IN _telefone varchar(15),
    IN _endereco varchar(255),
    IN _username varchar(50),
    IN _password varchar(255),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (_nome, _email, _telefone, _endereco, _username, _password);

    SET @last_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PF (cliente_id, cpf, data_nascimento)
    VALUES (@last_id, _cpf, _data_nascimento);

    COMMIT;
END $$

DROP PROCEDURE if EXISTS Cliente_Alterar;

CREATE PROCEDURE if not EXISTS ClintePf_Alterar(
    IN _conta_Id INT UNSIGNED,
    IN  _nome varchar(255),
    IN  _email varchar(255),
    IN  _telefone varchar(15),
    IN  _endereco varchar(255),
    IN  _username varchar(50),
    IN _password varchar(255),
    IN _cpf VARCHAR(14),
    IN _data_nascimento DATE
);
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE Cliente
    SET
    nome = _nome,
    email = _email,
    telefone = _telefone,
    endereco = _endereco,
    username = _username,
    passeord = _password
    WHERE Conta.'Id' = _conta_Id

    COMMIT;
END$$


CREATE PROCEDURE if not EXISTS p_consultarPJuridica()
Begin
    SELECT * FROM Clientes_PJ;
END$$

CREATE PROCEDURE if not EXISTS p_consultarPJuridicaByCNPJ(IN Cnpj varchar(18))
begin
    SELECT * FROM Clientes_PJ where cnpj = Cnpj;
END$$

CREATE procedure if not EXISTS  p_cadastrarClientePJ (
    IN  _nome varchar(255),
    IN  _email varchar(255),
    IN  _telefone varchar(15),
    IN  _endereco varchar(255),
    IN  _username varchar(50),
    IN _password varchar(255),
    IN _cnpj VARCHAR(18),
    IN _data_nascimento DATE,
    IN _razao_social varchar(100)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO Clientes (nome, email, telefone, endereco, username, password)
    VALUES (_nome, _email, _telefone, _endereco, _username, _password);

    SET @last_id = LAST_INSERT_ID();

    INSERT INTO Clientes_PJ (cliente_id, cnpj, data_nascimento, razao_social)
    VALUES (@last_id, _cnpj, _data_nascimento, _razao_social);

    COMMIT;
END $$



CREATE PROCEDURE if not EXISTS p_consultarTransacoes()
begin
    SELECT * FROM Transacoes;
END$$

CREATE PROCEDURE if not EXISTS p_consultarTransacoesByID (IN TransacoesID INT )
begin
    SELECT * FROM Transacoes WHERE id = TransacoesID;
END$$

CREATE PROCEDURE if not EXISTS p_sacar(
    IN _conta_Id Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo - _valor
    WHERE id = _conta_Id
    INSERT into Transacoes(conta_Id, tipo, valor, descricao)
    VALUES(_conta_Id, 'saque', _valor, _descricao);
END$$

CREATE PROCEDURE if not EXISTS p_depositar(
    IN _conta_Id Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    UPDATE Contas
    SET saldo = saldo + _valor
    WHERE id = _conta_Id
    INSERT into Transacoes(conta_Id, tipo, valor, descricao)
    VALUES(_conta_Id, 'Deposito', _valor, _descricao);
END$$

CREATE PROCEDURE if not EXISTS p_Transferir(
    IN _contaOrigemId Int,
    IN _contaDestinoId Int,
    IN _valor Decimal(15, 2) DEFAULT 0.00,
    IN _descricao varchar(255)
)
BEGIN
    CALL p_sacar(_contaOrigemId, _valor, 'Transferencia', _descricao),
    CALL p_depositar(_contaDestinoId, _valor, 'Transferencia', _descricao)


CREATE PROCEDURE if not EXISTS p_consultaCliente ()
Begin
    SELECT * FROM Clientes;
END$$

CREATE PROCEDURE if not EXISTS p_consultarClienteByID (IN clienteID int)
Begin
    SELECT * FROM Clientes WHERE id = clienteID;
END$$

CREATE PROCEDURE if not EXISTS p_consultarConta ()
Begin
    SELECT * FROM Contas;
END$$

CREATE PROCEDURE if not EXISTS p_consultarContaByID(IN ContaID INT)
Begin
    SELECT * FROM Contas where Id = ContaId;
END$$

CREATE PROCEDURE if not EXISTS p_criarcontaPoupanca(
    IN _cliente_Id INT
)
BEGIN
    INSERT INTO Contas(cliente_Id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id, 'Conta Poupança', 0.00, 0.00);
END$$

CREATE PROCEDURE if not EXISTS p_criarcontaCorrente(
    IN _cliente_Id INT,
    IN _limite DECIMAL (15, 2) DEFAULT 0.00
)
BEGIN
    INSERT INTO Contas(cliente_Id, tipo_conta, saldo, limite)
    VALUES (_cliente_Id, 'Conta Corrente', 0.00, _limite);
END$$


DELIMITER;