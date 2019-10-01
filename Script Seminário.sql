-- -----------------------------------------------------------------------------
--                            INFORMAÇÕES:                                    --
--                                                                            --
-- Alunos: Marcelo Vieira, Vladir Orlando.                                    --
-- Período: 5º Período Licenciatura em Computação.                            --
-- Matéria: Banco de Dados Avançados.                                         --
-- Contato: dj.marcelo.2009@gmail.com                                         --
-- -----------------------------------------------------------------------------
-- -----------------------------------------------------------------------------
--                  SCRIPT DE CRIAÇÃO DA BAsE DE DADOS.                      --
-- -----------------------------------------------------------------------------
CREATE DATABASE "DB_Escola"
  WITH ENCODING='UTF8'
       OWNER=postgres
       LC_COLLATE='Portuguese_Brazil.1252'
       LC_CTYPE='Portuguese_Brazil.1252'
       CONNECTION LIMIT=-1;
    
--     Versão Simples     --
-- CREATE DATABASE "DB_Escola";
-- DROP DATABASE "DB_Escola";
----------------------------
-- -----------------------------------------------------------------------------
--                  SCRIPT DE CRIAÇÃO DA BAsE DE DADOS.                      --
-- -----------------------------------------------------------------------------
--         Criação de Tabelas e Restrição de Integridade no SGBB             --
-- -----------------------------------------------------------------------------
--                            CRIAÇÃO DAS TABELAS                            --
-- -----------------------------------------------------------------------------
CREATE TABLE curso
(
   cod_curso serial NOT NULL, 
   nome_curso character(100) UNIQUE, 
   sigla_curso character(10) UNIQUE, 
   CONSTRAINT cod_curso PRIMARY KEY (cod_curso)
) 
WITH (
  OIDS = FALSE
);
ALTER TABLE curso
  OWNER TO postgres;

CREATE TABLE turma
(
  cod_turma character(25) UNIQUE,
  sala numeric,
  horario_inicio time with time zone,
  horario_termino time with time zone,
  CONSTRAINT cod_turma PRIMARY KEY (cod_turma)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE turma
  OWNER TO postgres;
  
CREATE TABLE aluno
(
   matr_aluno character(14) UNIQUE, 
   nome_aluno character(100) NOT NULL,
   endereco text DEFAULT 'Uberlândia',    
   sexo char NOT NULL,     
   dt_nasc date NOT NULL, 
   cod_curso integer NOT NULL REFERENCES curso (cod_curso) ON UPDATE SET NULL ON DELETE SET NULL
) 
WITH (
  OIDS = FALSE
)
;

CREATE TABLE matricula
(
   matr_aluno character(10) REFERENCES aluno (matr_aluno), 
   cod_turma character(25) REFERENCES turma (cod_turma),
   dt_matricula date, 
   valor_matricula numeric(10,2) CHECK (valor_matricula > 0), 
   CONSTRAINT pk_matricula PRIMARY KEY (matr_aluno, cod_turma) -- Chave composta
) 
WITH (
  OIDS = FALSE
)
;

-- -----------------------------------------------------------------------------
--                     INSERÇÃO DE DADOS NAS TABELAS                         --
-- -----------------------------------------------------------------------------

-- ---------------------------------------------------
--                     CURSO                       --
-- ---------------------------------------------------
INSERT  INTO curso
        ( cod_curso, nome_curso, sigla_curso )
VALUES  ( 1, 'Tecnologia em Sistemas para Internet', 'TSPI' ),
        ( 2, 'Licenciatura em Computação', 'LCO' ),
        ( 3, 'Tecnologia em Marketing', 'TMKT' ),
        ( 4, 'Tecnologia em Logistica', 'TLOG' ),
        ( 5, 'Técnico em Redes de Computadores', 'TRC' );
-- ---------------------------------------------------
--                     ALUNO                       --
-- ---------------------------------------------------

INSERT  INTO aluno
VALUES  ( 12345, 'Ricardo Mauricio de Souza', 'R. Das Alfazemas', 'M',
          '1975-02-10', 3 ),
        ( 12346, 'Maria Madalena Rocha', 'R. Das Margaridas', 'F',
          '1980-04-21', 3 ),
        ( 12347, 'Carlos Roberto Silva', 'R. Das Orquideas', 'M', '1990-08-17',
          3 ),
        ( 12348, 'Marcos Paulo Pereira', 'R. Das Hortênsias', 'M',
          '1992-10-02', 1 ),
        ( 12349, 'Carla Ribeiro', 'R. Das Rosas', 'F', '1993-11-15', 1 ),
        ( 12335, 'Adriana Marques', 'R. Das Acacias', 'F', '1980-12-13', 2 ),
        ( 12336, 'Bruno Siqueira', 'R. Das Azaleias', 'M', '1993-03-19', 2 ),
        ( 12337, 'Daniel de Oliveira', 'R. Das Camélias', 'M', '1994-11-09', 4 ),
        ( 12338, 'Ana Carolina Ferreira', 'R. Das Calendulas', 'F',
          '1979-01-15', 4 ),
        ( 12339, 'Arnaldo de Souza', 'R. Das Lavandas', 'M', '1989-07-29', 4 ),
        ( 13331, 'Maria de Souza', 'R. Dos Hibiscos', 'F', '1990-07-22', 1 );
-- ---------------------------------------------------
--                     TURMA                       --
-- ---------------------------------------------------

INSERT  INTO turma
        ( cod_turma, sala, horario_inicio, horario_termino )
VALUES  ( 'TSPI –I – 12017', 113, '18:45', '22:45' ),
        ( 'LCO –I – 12017', 114, '18:45', '22:45' ),
        ( 'TMKT –I – 12017', 112, '07:45', '11:45' ),
        ( 'TLOG –I – 12017', 115, '18:45', '22:45' ),
        ( 'TRC –I – 12017', 115, '13:30', '17:30' );
  
-- ---------------------------------------------------
--                     MATRÍCULA                   --
-- ---------------------------------------------------
INSERT  INTO matricula
VALUES  ( 12348, 'TSPI –I – 12017', '2017-01-15', 290 ),
        ( 12349, 'TSPI –I – 12017', '2017-01-13', 300 ),
        ( 12335, 'LCO –I – 12017', '2017-01-18', 320 ),
        ( 12336, 'LCO –I – 12017', '2017-01-21', 350 ),
        ( 12345, 'TMKT –I – 12017', '2017-01-03', 240 ),
        ( 12346, 'TMKT –I – 12017', '2017-01-05', 250 ),
        ( 12347, 'TMKT –I – 12017', '2017-01-06', 245 ),
        ( 12337, 'TLOG –I – 12017', '2017-01-23', 270 ),
        ( 12338, 'TRC –I – 12017', '2017-01-25', 280 ),
        ( 12339, 'TRC –I – 12017', '2017-01-24', 275 );
  
-- -----------------------------------------------------------------------------
--                FIM DA INSERÇÃO DE DADOS NAS TABELAS                       --
-- -----------------------------------------------------------------------------

-- -----------------------------------------------------------------------------
--                            CONSULTAS                                      --
-- -----------------------------------------------------------------------------
--                   Criação de Procedimentos no SGBD                        --
-- -----------------------------------------------------------------------------
/*A) Crie uma função que retorne os dias já sobrevividos esse semestre,
 e quanto ainda falta para acabar.*/
-- Exemplo concatenar campos. 
CREATE or REPLACE FUNCTION sobrevivi() RETURNS text AS $$
BEGIN
   RETURN 'Já sobrevivi ' || date(CURRENT_DATE) - date('2017-02-06') ||
   ' dias, mas ainda falta: ' || date('2017-07-06') - date(CURRENT_DATE)
   || ' dias, para as férias começar, aguentem firme.';
END;

$$ LANGUAGE plpgsql;
SELECT sobrevivi();

/*B) Crie uma função que tenha como parametro de entrada o nome do curso
 e retorne o valor total $$ já obtivo em matrículas.*/
CREATE or REPLACE FUNCTION mais_valia(var_nome_curso character(100)) RETURNS numeric(10,2) AS $$
BEGIN 
 var_nome_curso := '%'||var_nome_curso||'%';
 SELECT nome_curso INTO var_nome_curso FROM curso WHERE nome_curso like var_nome_curso;
 RETURN SUM(valor_matricula) FROM matricula WHERE matr_aluno in
 (SELECT matr_aluno FROM aluno where cod_curso in
 (SELECT cod_curso  FROM curso WHERE nome_curso = var_nome_curso));
END;

$$ LANGUAGE plpgsql;
SELECT mais_valia('arketin') as lucro;

/*C) Crie uma Trigger que antes de um UPDATE na tabela Matrículas verifique se novo valor de matrícula não pode ser zero.*/
	
CREATE OR REPLACE FUNCTION processa_update_matri() RETURNS TRIGGER AS $update_matri$
    BEGIN
        --
        -- Valor tem que ser maior que 0
        --
        IF (NEW.valor_matricula < 100) THEN
            RAISE EXCEPTION 'Não é permitido valor da matrícula inferior a cem [100]';
        END IF;
        RETURN NULL; -- o resultado é ignorado uma vez que este é um gatilho AFTER
    END;
$update_matri$ language plpgsql;
-- create trigger update_matri after update of valor_matricula on matricula for each row execute procedure processa_update_matri();
 CREATE TRIGGER update_matri
 AFTER UPDATE ON matricula
 FOR EACH ROW EXECUTE PROCEDURE processa_update_matri();

UPDATE matricula SET valor_matricula = 100 where matr_aluno = '12348';
SELECT * FROM matricula where matr_aluno = '12348';

select * from matricula;
				   
/*D) Crie uma Visão que mostre qual valor total de matrículas.*/
CREATE OR REPLACE VIEW lucrototal (LUCRO_TOTAL) AS
	SELECT SUM(valor_matricula) FROM matricula WHERE matr_aluno like '%%';

SELECT * FROM lucrototal;

-- -----------------------------------------------------------------------------
--                            BONUS                                          --
-- -----------------------------------------------------------------------------
CREATE OR REPLACE VIEW Semestre_2017_1 AS
SELECT date(CURRENT_DATE) - date('2017-02-06') AS Quandos_Dias_Sobrevivi_Em_2017,
date('2017-07-07') - date(CURRENT_DATE) AS Ferias_ainda_Falta;

SELECT * FROM Semestre_2017_1;

-- -----------------------------------------------------------------------------
--                              Notas                                        --
-- -----------------------------------------------------------------------------
SELECT round(random() * 10); -- Preencher notas aleatórios 0 - 10.

ALTER TABLE Aluno ADD COLUMN nota numeric(4,2);
ALTER TABLE Aluno
  ADD CONSTRAINT Aluno_valor_nota_check CHECK (nota >= 0::numeric);


CREATE OR REPLACE FUNCTION preencher_Notas(cod INTEGER) RETURNS void AS $$
    DECLARE
        notas integer DEFAULT 0;
    BEGIN
        UPDATE aluno SET nota = round(random() * 10)
          WHERE cod_curso = cod;
    END;
$$ LANGUAGE plpgsql;

SELECT preencher_Notas(1);

SELECT max(nota) from aluno;
SELECT * FROM Aluno order by cod_curso asc, nota DESC;


CREATE OR REPLACE FUNCTION preecher_Todas_Notas() RETURNS void AS $$
DECLARE
 i INTEGER DEFAULT 1;
 max INTEGER DEFAULT 0;
BEGIN
 SELECT max(cod_curso) into max FROM aluno;
  WHILE i <= max LOOP
  execute preencher_Notas(i);
    i := i + 1;
  END LOOP;
END; $$ LANGUAGE plpgsql;


SELECT preecher_Todas_Notas();
-- -----------------------------------------------------------------------------
--                   Criação de de cursor no SGBD                            --
-- -----------------------------------------------------------------------------
SELECT * FROM Aluno order by nota asc;
ALTER TABLE Aluno ADD COLUMN situacao character(14) DEFAULT 'NULL';
-- ---------------------------------------------------
--                   REPROVA                       --
-- ---------------------------------------------------
CREATE OR REPLACE FUNCTION cursor_Update_reprova() RETURNS integer AS $$
DECLARE
  --parametros
  v_matr_aluno character(14);
  A_NUMERO integer := 0;
  --cursor
  cursor_Alunos CURSOR FOR SELECT matr_aluno
    FROM Aluno
    WHERE nota < 6;
BEGIN
      --
      OPEN cursor_Alunos;
      --
      LOOP
        FETCH cursor_Alunos INTO v_matr_aluno;
        EXIT WHEN NOT FOUND;
        --UPDATE
      UPDATE Aluno
         SET situacao = 'REPROVADO'
       WHERE matr_aluno = v_matr_aluno;
      --Contador
      A_NUMERO := A_NUMERO + 1;
      END LOOP;
      --
      CLOSE cursor_Alunos;
	return A_NUMERO;
END; $$ LANGUAGE 'plpgsql';


SELECT cursor_Update_reprova();
-- ---------------------------------------------------
--                    APROVA                       --
-- ---------------------------------------------------
SELECT *
FROM Aluno
ORDER BY nota DESC;

CREATE OR REPLACE FUNCTION cursor_Update_aprova() RETURNS integer AS $$
DECLARE
  --parametros
  v_matr_aluno character(14);
  A_NUMERO integer := 0;
  --cursor
  cursor_Alunos CURSOR FOR SELECT matr_aluno
    FROM Aluno
    WHERE nota >= 6;
BEGIN
      --
      OPEN cursor_Alunos;
      --
      LOOP
        FETCH cursor_Alunos INTO v_matr_aluno;
        EXIT WHEN NOT FOUND;
      --UPDATE
      UPDATE Aluno
         SET situacao = 'APROVADO'
       WHERE matr_aluno = v_matr_aluno;
      --Contador
      A_NUMERO := A_NUMERO + 1;
      END LOOP;
      --
      CLOSE cursor_Alunos;
	return A_NUMERO;
END; $$ LANGUAGE 'plpgsql';


SELECT cursor_Update_aprova();


-- ---------------------------------------------------
--  TRIGGER APÓS      INSERT OU UPDATE ON          --
-- ---------------------------------------------------

ALTER TABLE Aluno ADD COLUMN last_date timestamp;
ALTER TABLE Aluno ADD COLUMN last_user text;

CREATE FUNCTION log_InsertAluno() RETURNS trigger AS $corpo$
    BEGIN
        -- Remember who changed the payroll when
        NEW.last_date := current_timestamp;
        NEW.last_user := current_user;
        RETURN NEW;
    END;
$corpo$ LANGUAGE plpgsql;

CREATE TRIGGER log_InsertAluno BEFORE INSERT OR UPDATE ON Aluno
    FOR EACH ROW EXECUTE PROCEDURE log_InsertAluno();
-----------------------------------------------------
			SELECT * FROM Aluno;
-----------------------------------------------------
INSERT  INTO aluno
VALUES  ( 15634, 'Marcelo', 'R. Judas Perdeu as Botas', 'M',
          '1975-02-10', 3 );

UPDATE Aluno set nome_aluno = 'Marcelo José Vieira' WHERE nome_aluno like 'Marcel%';
-- ----------------------------------------------------------------------------
--                            FIM DO CÓDIGO                                 --
-- ----------------------------------------------------------------------------
