
# Trabalho PIHS - CRUD Assembly 32bits

Implementar em linguagem Gnu Assembly para plataforma 32bits, 
um programa de Controle de Cadastro de Imobiliário para locação, 
usando exclusivamente as instruções e recursos de programação 
passados durante as aulas. O programa deve executar as funcionalidades
de cadastro de uma imobiliária. 

As seguintes funcionalidades devem ser implementadas: 
- Inserção: 
- Remoção: 
- Consulta 
- Gravar cadastro 
- Recuperar cadastro 
- Relatório de registros: 
- O relatório deve mostrar todos os registros cadastrados de forma ordenada por número de cômodos.
- As consultas de registros devem ser feitas por número de cômodos. 

Deve-se usar uma lista encadeada dinâmica (com malloc) para armazenar
os registros dos imóveis ordenados por número de cômodos.

Campos do registro:

- Nome completo
- CPF e celular do proprietário
- Tipo do imóvel (casa ou apartamento)
- Endereço do imóvel (cidade, bairro, rua e número)
- Número de quartos simples e de suites
- Se tem banheiro social, cozinha, sala e garagem
- Metragem total
- Valor do aluguel
