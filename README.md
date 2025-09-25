# testeSAG
repositório criado para teste de seleção na SAG Software

#Guia de instalção
- Configurar database Oracle :
HostName := 'localhost'
Port := 1521
Database := 'XE'
Um usuário na DB como abaixo:
User := 'system'
Password := 'oracle'


Requisitos da Avaliação
1. Estrutura do Banco de Dados (Oracle): O candidato deve criar a seguinte estrutura
de tabelas em um esquema Oracle:
o
TAB_LOTE_AVES:
▪
ID_LOTE (NUMBER, PK)
▪
DESCRICAO (VARCHAR2(100))
▪
DATA_ENTRADA (DATE)
▪
QUANTIDADE_INICIAL (NUMBER)
o
TAB_PESAGEM:
▪
ID_PESAGEM (NUMBER, PK)
▪
ID_LOTE_FK (NUMBER, FK para TAB_LOTE_AVES)
▪
DATA_PESAGEM (DATE)
▪
PESO_MEDIO (NUMBER(10, 2))
▪
QUANTIDADE_PESADA (NUMBER)
o
TAB_MORTALIDADE:
▪
ID_MORTALIDADE (NUMBER, PK)
▪
ID_LOTE_FK (NUMBER, FK para TAB_LOTE_AVES)
▪
DATA_MORTALIDADE (DATE)
▪
QUANTIDADE_MORTA (NUMBER)
▪
OBSERVACAO (VARCHAR2(255))
2. Interface Gráfica (Delphi): O candidato deve criar uma aplicação Delphi com as
seguintes telas/funcionalidades:
o
Uma tela principal que exiba uma lista de lotes de aves (TAB_LOTE_AVES)
em um DBGrid.
Flip Cursos e Engenharia
Rua Assis Brasil, n° 448, Vila Isabel. Pato Branco-PR
o
Ao selecionar um lote, o usuário deve poder acessar duas sub-telas (ou
abas): uma para lançar pesagens e outra para lançar mortalidades.
o
A tela de lançamento de pesagens deve permitir ao usuário inserir a data,
peso médio e a quantidade de aves pesadas. O sistema deve validar se a
QUANTIDADE_PESADA não ultrapassa a QUANTIDADE_INICIAL do lote.
o
A tela de lançamento de mortalidades deve permitir ao usuário inserir a
data, a quantidade de aves mortas e uma observação. O sistema deve
validar se a QUANTIDADE_MORTA somada a outras mortalidades já
registradas não ultrapassa a QUANTIDADE_INICIAL do lote.
3. Lógica de Programação e POO: O candidato deve:
o
Utilizar programação orientada a objetos para organizar o código. Crie
classes para representar as entidades de negócios, como Lote, Pesagem e
Mortalidade. Utilize conceitos como encapsulamento e herança (se
aplicável).
o
Implementar a lógica de validação mencionada no item 2.
o
Criar um componente visual simples para exibir um indicador de saúde do
lote (por exemplo, um painel com cor verde se a mortalidade acumulada for
menor que 5%, amarelo entre 5% e 10% e vermelho acima de 10%).
4. SQL e PL/SQL: O candidato deve:
o
Criar Stored Procedures ou Functions (PL/SQL) para as operações de
inserção de dados nas tabelas TAB_PESAGEM e TAB_MORTALIDADE.
o
A procedure de inserção de pesagem deve, ao ser executada, verificar a
quantidade total pesada e atualizar um campo de peso médio geral do lote,
se julgar necessário.
o
A procedure de inserção de mortalidade deve, ao ser executada, calcular a
mortalidade acumulada e retornar o valor para a aplicação Delphi, para
que o indicador de saúde do lote possa ser atualizado.
o
O acesso ao banco de dados pelo Delphi deve ser feito através dessas
procedures, demonstrando conhecimento em manipulação de dados com
PL/SQL.
