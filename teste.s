/*

Implementar em linguagem Gnu Assembly para plataforma 32bits, um programa de Controle de Cadastro de Imobiliário para locação, 
usando exclusivamente as instruções e recursos de programação passados durante as aulas. O programa deve executar as 
funcionalidades de cadastro de uma imobiliária. As seguintes funcionalidades devem ser implementadas: 
- inserção, 
- remoção,
- consulta, 
- gravar cadastro, 
- recuperar cadastro 
- relatório de registros. 

Deve-se usar uma lista encadeada dinâmica (com malloc) para armazenar os registros dos imóveis ordenados por número de cômodos.

Para cada registro de imóvel deve-se ter as seguintes informações: nome completo, CPF e celular do proprietário, tipo do imóvel 
(casa ou apartamento), endereço do imóvel (cidade, bairro, rua e número), número de quartos simples e de suites, se tem banheiro 
social, cozinha, sala e garagem, metragem total e valor do aluguel. As consultas de registros devem ser feitas por faixa de valor 
de aluguel. O relatório deve mostrar todos os registros cadastrados de forma ordenada. A remoção deve liberar o espaço de memória 
alocada (pode-se usar a função free(), empilhando o endereço antes de chamá-la com call).

Vamos supor um registro (record ou struct) com os seguintes campos:

Nome: 60 caracteres + final de string ('\0')        (= 64 bytes)
CPF: 11 caracteres + 3 caracteres especiais + '\0'  (16 bytes)
Telefone: 2 + 9 caracteres + '\0'                   (16 bytes)

Tipo do imovel: 1 caractere 'C' ou 'A'         		(= 4 bytes)
Endereco: 60 caracteres + final de string ('\0')    (= 64 bytes)
Num Quartos:                                        (1 inteiro = 4 bytes)
Num Suites:                                         (1 inteiro = 4 bytes)
Tem Banheiro Social:                                (1 inteiro = 4 bytes)
Tem Cozinha:                                        (1 inteiro = 4 bytes)
Tem Sala:                                           (1 inteiro = 4 bytes)
Tem Garagem:                                        (1 inteiro = 4 bytes)
Metragem:                                           (1 inteiro = 4 bytes)
Aluguel:                                            (1 inteiro = 4 bytes)
Num Comodos:                                        (1 inteiro = 4 bytes) # nao vai pedir, é a soma dos comodos
* Ponteiro: 										(space = 4 bytes)

Total = 64+64 + 16+16 + 11*4 = 204 bytes

*/

.section .data
	tituloMenu:				.asciz "Controle de cadastro imobiliario\n"
	itemAdicionarImovel:	.asciz "Adicionar imovel                     (1)\n"
	itemRemoverImovel:		.asciz "Remover imovel                       (2)\n"
	itemConsultarImovel:	.asciz "Consultar por numero de comodos      (3)\n"
	itemGerarRelatorio:		.asciz "Gerar relatorio                      (4)\n"
    itemSalvarRelatorio:    .asciz "Salvar registros                     (5)\n"
	itemSair:				.asciz "Sair                                 (6)\n"
	opcaoMenu:		    	.asciz "Opcao escolhida: "
	opcaoInvalida:		    .asciz "Opcao invalida!\n"
	
	txtRegistrarImovel: 	.asciz 	"# Registro de Imovel #\n"
	txtRemoverImovel:		.asciz 	"# Remocao de Imovel #\n"
	txtConsultarImovel:		.asciz  "# Consulta de Imoveis por Numero de Comodos #\n"
	txtGerarRelatorio:		.asciz	"# Relatorio de Imoveis #\n"
	txtRegistroN: 			.asciz 	"\n- Registro %d -\n"
    txtSalvarRelatorio:     .asciz  "# Salvando os dados no arquivo saida.txt #\n"
	txtSair: 				.asciz 	"Encerrando Programa\n"

	linha1:					.asciz "########################################\n"
	linha2:					.asciz "----------------------------------------\n"

	txtPedeNome:	    .asciz	"\nDigite o nome do proprietario: "
	txtPedeCPF:	        .asciz	"Digite o CPF: " 
	txtPedeTelefone:	.asciz	"Digite o Telefone: " 
	txtPedeTipoImovel:	.asciz	"Digite o tipo do imovel - Casa(C) ou Apartamento(A): "
	txtPedeEndereco:	.asciz	"Digite o Endereco do imovel: " 
	txtPedeNumQuartos:	.asciz	"Digite numero de quartos: "
	txtPedeNumSuites:	.asciz	"Digite numero de suites: "
	txtPedeTemBSocial:	.asciz	"O imovel possui Banheiro Social? (0-Nao 1-Sim): "
	txtPedeTemCozinha:	.asciz	"O imovel possui Cozinha? (0-Nao 1-Sim): "
	txtPedeTemSala:	    .asciz	"O imovel possui Sala? (0-Nao 1-Sim): "
	txtPedeTemGaragem:	.asciz	"O imovel possui Garagem? (0-Nao 1-Sim): "
	txtPedeMetragem:	.asciz	"Digite a metragem do imovel: "
	txtPedeAluguel:	    .asciz	"Digite o valor do aluguel do imovel: "
	txtPedeLimInf: 		.asciz 	"Digite o valor do limite inferior: "
	txtPedeLimSup: 		.asciz 	"Digite o valor do limite superior: "
	txtPedeIndiceRemocao: .asciz "Digite o índice do registro a ser removido: "

	txtMostraReg:	.asciz	"\nRegistro Lido\n"
	txtMostraNome:	.asciz	"Nome: %s"
	txtMostraCPF:	.asciz	"CPF: %s\n"
	txtMostraTelefone:		.asciz	"Telefone: %s"
    txtMostraTipoImovel:	.asciz	"Tipo do imovel - Casa(C) ou Apartamento(A): %c\n"
	txtMostraEndereco:	    .asciz	"Endereco do imovel: %s" 
	txtMostraNumQuartos:	.asciz	"Numero de quartos: %d\n"
	txtMostraNumSuites:	    .asciz	"Numero de suites: %d\n"
	txtMostraTemBSocial:	.asciz	"Imovel possui Banheiro Social? (0-Nao 1-Sim): %d\n"
	txtMostraTemCozinha:	.asciz	"Imovel possui Cozinha? (0-Nao 1-Sim): %d\n"
	txtMostraTemSala:	    .asciz	"Imovel possui Sala? (0-Nao 1-Sim): %d\n"
	txtMostraTemGaragem:	.asciz	"Imovel possui Garagem? (0-Nao 1-Sim): %d\n"
	txtMostraMetragem:	    .asciz	"Metragem do imovel: %d\n"
	txtMostraAluguel:	    .asciz	"Valor do aluguel do imovel: %d\n"
	txtMostraNumComodos:	.asciz	"Numero de comodos: %d\n"
	txtListaVazia:			.asciz	"Lista vazia, insira algo antes \n"
	
    nomeArquivoSaida:       .asciz "saida.txt"
    nomeArquivoEntrada:     .asciz "entrada.txt"
    tipoAberturaArq:        .asciz "wb"

	tipoNum: 	.asciz 	"%d"
	tipoChar:	.asciz	"%c"
	tipoStr:	.asciz	"%s"
	pulaLinha: 	.asciz 	"\n"

	tamReg:  	.int 	204
	n: 			.int 	0 	# num de registros cadastrados
	cont: 		.int 	0	# contador para print
	numComodos: .int 	0
	limInf:		.int	0	#limite inferior para a buscas 
	limSup:		.int	0	#limite superior para a buscas
	indiceRemocao: .int 0   # indice de remocao de registro

	listaReg:	.space	4	# ponteiro para o primeiro registro
	reg:		.space	4 	# ponteiro auxiliar para registros
	regAntes: 	.space 	4

    ponteiroArquivoSaida:   .space 4 #ponteiro para o arquivo de saida

	NULL:		.int 0
	opcao:		.int 0
	
.section .text
.globl _start
_start:
	call 	inicializar
_voltaMenu:
	call	menuInicial
	call	tratarOpcoes
	jmp _voltaMenu

_fim:
	pushl 	$txtSair
	call 	printf
	addl 	$4, %esp	
	pushl 	$0
	call 	exit


inicializar:
	movl 	$NULL, %eax
	movl 	%eax, listaReg
	RET

#########################################################
# MENU
#########################################################

menuInicial:
	jmp _menuInicial
_opcaoInvalida:
	pushl $opcaoInvalida
	call printf
	addl $4, %esp	
_menuInicial:
	# Menu inicial com leitura de opcao e tratamento de opcoes invalidas 0 < opcao < 6
	pushl 	$pulaLinha
	call 	printf
	pushl 	$linha1
	call 	printf
	pushl 	$tituloMenu
	call 	printf
	pushl 	$linha2
	call 	printf
	pushl 	$itemAdicionarImovel
	call 	printf 
	pushl 	$itemRemoverImovel
	call 	printf 
	pushl 	$itemConsultarImovel
	call 	printf
	pushl 	$itemGerarRelatorio 
	call 	printf
    pushl 	$itemSalvarRelatorio 
	call 	printf
	pushl 	$itemSair
	call 	printf
	pushl 	$linha2
	call 	printf
	pushl 	$opcaoMenu
	call 	printf

	pushl 	$opcao 
	pushl 	$tipoNum 
	call 	scanf 

	pushl 	stdin 		# limpar o buffer para proxima leitura
	call 	fgetc

	pushl 	$linha1
	call 	printf
	pushl 	$pulaLinha
	call 	printf

	addl	$68, %esp

	movl	opcao, %eax
	cmpl	$0, %eax
	jle	_opcaoInvalida
	cmpl 	$7, %eax 
	jge _opcaoInvalida

	RET


tratarOpcoes:
	movl	opcao, %eax

	cmpl	$1, %eax
	je _leituraImovel

	cmpl	$2, %eax
	je _removerImovel

	cmpl	$3, %eax
	je _consultarImovel

	cmpl	$4, %eax
	je _gerarRelatorio

    cmpl    $5, %eax
    je _salvarRelatorio

	cmpl	$6, %eax
	je _fim

	RET


_leituraImovel:
	call registrarImovel
	jmp _voltaMenu

_removerImovel:
	call removerImovel
	jmp _voltaMenu

_consultarImovel:
	call consultarImovel 
	jmp _voltaMenu

_gerarRelatorio:
	call gerarRelatorio
	jmp _voltaMenu

_salvarRelatorio:
    call salvarRelatorio
    jmp _voltaMenu

#########################################################
# REMOVER
#########################################################

_remocaoListaVazia:
	pushl 	$txtListaVazia
	call	printf
	addl 	$4, %esp 

	RET
_remocaoInvalida:
	pushl 	$opcaoInvalida
	call	printf
	addl 	$4, %esp 
removerImovel:
	pushl 	$txtRemoverImovel
	call 	printf
	addl	$4, %esp

	cmpl	$0, n
	je		_remocaoListaVazia

	pushl 	$txtPedeIndiceRemocao
	call 	printf

	pushl	$indiceRemocao
	pushl	$tipoNum
	call 	scanf
	addl 	$12, %esp

	cmpl 	$1, indiceRemocao
	jl 		_remocaoInvalida
	movl 	n, %eax
	cmpl 	%eax, indiceRemocao
	jg 		_remocaoInvalida
	
	movl	listaReg, %esi # esi = aponta para o comeco do registro da lista sendo lido
	movl	n, %eax
	decl	%eax
	movl	%eax, n
	movl	indiceRemocao, %ecx
	decl 	%ecx
	cmpl 	$0, %ecx 		# caso remocao do primeiro
	je 		_removePrimeiro

_voltaRemocao:
	movl	%esi, %edi
	addl	tamReg, %edi 	# busca o campo do ponteiro pro prox em edi
	subl	$4, %edi
	movl 	(%edi), %esi
	loop	_voltaRemocao

	movl 	%edi, %ebx 		# ebx = endereco do campo prox do elemento anterior ao que vai ser removido
	movl 	(%edi), %esi
	movl 	%esi, %edi
	addl	tamReg, %edi 	# busca o campo do ponteiro pro prox em edi
	subl	$4, %edi
	movl 	(%edi), %eax
	movl 	%eax, (%ebx)

	#remove aqui

	RET

_removePrimeiro:
	movl	%esi, %edi
	addl	tamReg, %edi # busca o campo do ponteiro pro prox em edi
	subl	$4, %edi
	movl	(%edi), %eax
	movl	%eax, listaReg
	
	RET

#########################################################
# CONSULTAR
#########################################################

consultarImovel:
	push $txtConsultarImovel
	call printf
	addl $4, %esp

	push $txtPedeLimInf
	call printf 
	addl $4, %esp 

	push $limInf
	push $tipoNum
	call scanf
	addl $8, %esp 

	push $txtPedeLimSup
	call printf 
	addl $4, %esp 

	push $limSup
	push $tipoNum
	call scanf
	addl $8, %esp 

	#############
	movl	$0, cont
	movl 	listaReg, %edi
	movl 	%edi, reg 			# reg possui o ponteiro pro registro atual
	movl 	n, %ecx

_voltaConsulta:
	pushl 	%ecx				# print "Registro X"
	pushl 	%edi

	movl 	cont, %eax			# incr contador
	incl 	%eax
	movl 	%eax, cont
	
	movl 	reg, %edi
	addl 	tamReg, %edi		# busca o campo do numero de comodos em edi
	subl 	$8, %edi
	movl 	(%edi), %ebx		# ebx = numero de comodos
	cmpl	limSup, %ebx 
	jg		_fimConsulta

	cmpl	limInf, %ebx 
	jl		_continuarConsulta
	call 	mostraReg 			# mostra conteudos do reg

_continuarConsulta:

	movl 	tamReg, %eax		# vai ate o campo prox e atualiza reg
	subl 	$4, %eax
	movl 	reg, %edi
	addl 	%eax, %edi
	movl 	(%edi), %ebx
	movl 	%ebx, reg

	popl 	%edi
	popl 	%ecx
	loop 	_voltaConsulta

	RET

_fimConsulta:
	popl 	%edi
	popl 	%ecx
	RET


#########################################################
# REGISTRAR 
#########################################################

registrarImovel:
	pushl	$txtRegistrarImovel
	call	printf
	addl	$4, %esp

	call 	leReg				# le registro e salva na variavel reg
	call 	insereReg 			# insere o registro na lista

	movl 	n, %eax
	incl 	%eax
	movl 	%eax, n

	RET

leReg:
	pushl	tamReg			# aloca
	call	malloc
	addl	$4, %esp
	movl	%eax, reg 		# move ponteiro da primeira posicao pra reg
	movl 	$0, %ebx		# ebx = contador de num comodos do imovel
	push 	%ebx			# backup

# nome
	pushl	$txtPedeNome 	
	call	printf
	addl	$4, %esp

	pushl	stdin
	pushl	$64
	movl	reg, %edi
	pushl	%edi
	call	fgets

	popl	%edi			# avanca edi para o proximo campo
	addl	$8, %esp
	addl	$64, %edi

# cpf
	pushl	%edi

	pushl	$txtPedeCPF 	
	call	printf
	addl	$4, %esp

	pushl	$tipoStr
	call	scanf
	addl	$4, %esp

	popl	%edi
	addl	$16, %edi

# telefone
	pushl	%edi

	pushl 	stdin 			# tirar buffer
	call 	fgetc
	addl 	$4, %esp
	
	pushl	$txtPedeTelefone 
	call	printf
	addl	$4, %esp
	
	popl	%edi
	pushl	stdin
	pushl	$16
	pushl	%edi
	call	fgets
	
	popl	%edi
	addl	$8, %esp
	addl	$16, %edi

# TipoImovel
	pushl 	%edi

	pushl	$txtPedeTipoImovel 
	call	printf
	addl	$4, %esp

	pushl	$tipoChar
	call	scanf		
	addl	$4, %esp

	popl	%edi
	addl	$4, %edi

# endereco
	pushl	%edi

	pushl 	stdin 			# tirar buffer
	call 	fgetc
	addl 	$4, %esp
	
	pushl	$txtPedeEndereco 
	call	printf
	addl	$4, %esp
	
	popl	%edi
	pushl	stdin
	pushl	$64
	pushl	%edi
	call	fgets
	
	popl	%edi
	addl	$8, %esp
	addl	$64, %edi

# NumQuartos
	pushl 	%edi

	pushl	$txtPedeNumQuartos 	
	call	printf
	addl	$4, %esp

	pushl 	$numComodos
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	popl	%edi			# adicionando numQuartos ao total de comodos
	popl 	%ebx
	movl 	numComodos, %eax
	cmpl 	$0, %eax		# se < 0, nao adiciona
	jg 		_fimRegQuartos
	movl 	$0, %eax
_fimRegQuartos:
	addl 	%eax, %ebx
	movl 	%eax, (%edi)
	addl	$4, %edi
	
# NumSuites
	pushl 	%ebx 
	pushl	%edi

	pushl	$txtPedeNumSuites 	
	call	printf
	addl	$4, %esp

	pushl 	$numComodos
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	popl	%edi
	popl 	%ebx
	movl 	numComodos, %eax
	cmpl 	$0, %eax		# se < 0, nao adiciona
	jg 		_fimRegSuites
	movl 	$0, %eax
_fimRegSuites:
	addl 	%eax, %ebx
	movl 	%eax, (%edi)
	addl	$4, %edi

# TemBanheiroSocial
	pushl 	%ebx 
	pushl	%edi

	pushl	$txtPedeTemBSocial 	
	call	printf
	addl	$4, %esp

	pushl 	$numComodos
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	popl	%edi
	popl 	%ebx
	movl 	numComodos, %eax
	call 	trataQtdComodos
	movl 	%eax, (%edi)
	addl 	%eax, %ebx
	addl	$4, %edi

# TemCozinha
	pushl 	%ebx 
	pushl	%edi

	pushl	$txtPedeTemCozinha 	
	call	printf
	addl	$4, %esp

	pushl 	$numComodos
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	popl	%edi
	popl 	%ebx
	movl 	numComodos, %eax
	call 	trataQtdComodos
	movl 	%eax, (%edi)
	addl 	%eax, %ebx
	addl	$4, %edi
	
# TemSala
	pushl 	%ebx 
	pushl	%edi

	pushl	$txtPedeTemSala 
	call	printf
	addl	$4, %esp

	pushl 	$numComodos
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	popl	%edi
	popl 	%ebx
	movl 	numComodos, %eax
	call 	trataQtdComodos
	movl 	%eax, (%edi)
	addl 	%eax, %ebx
	addl	$4, %edi

# TemGaragem
	pushl 	%ebx 
	pushl	%edi

	pushl	$txtPedeTemGaragem 
	call	printf
	addl	$4, %esp

	pushl 	$numComodos
	pushl	$tipoNum
	call	scanf
	addl	$8, %esp

	popl	%edi
	popl 	%ebx
	movl 	numComodos, %eax
	call 	trataQtdComodos
	movl 	%eax, (%edi)
	addl 	%eax, %ebx
	addl	$4, %edi
	
# Metragem
	pushl 	%ebx 
	pushl	%edi

	pushl	$txtPedeMetragem 
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	addl	$4, %esp

	popl	%edi
	addl	$4, %edi
	pushl	%edi

# Aluguel
	pushl	$txtPedeAluguel 
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	addl	$4, %esp

	popl	%edi
	addl	$4, %edi
	
# num comodos
	popl 	%ebx			
	movl 	%ebx, (%edi)

	pushl 	stdin 				# tirar buffer fim
	call 	fgetc
	addl 	$4, %esp
	
	RET


# A quantidade de comodos está em %eax, e só pode ser 0 ou 1
# Se for menor ou igual a 0, é transformado em 0, caso contrário, 1 
trataQtdComodos:
	cmpl 	$0, %eax
	jle 	_menorIgual0
	movl 	$1, %eax
	RET
_menorIgual0:
	movl 	$0, %eax
	RET


insereReg:
	# registro a ser inserido esta na variavel reg
	movl 	reg, %edi 			# reg = ponteiro do registro a ser inserido
	movl 	listaReg, %esi 		# esi = aponta para o comeco do registro da lista sendo lido

	cmpl	$0, n				# caso lista vazia
	je 		_inserePrimeiro
	

	addl 	tamReg, %edi 		# busca o campo do numero de comodos em edi
	subl 	$8, %edi
	movl 	(%edi), %ebx
	movl 	%ebx, numComodos

	movl 	%esi, %edi			# edi = ponteiro que passa pelos campos do registro
	movl 	%esi, regAntes
	addl 	tamReg, %edi		# busca o campo do numero de comodos em edi
	subl 	$8, %edi
	movl 	(%edi), %ebx		# ebx = numero de comodos
	addl 	$4, %edi
	movl 	(%edi), %ecx		# ecx = ponteiro pro prox
	movl 	%ecx, %esi			# avanca para o prox registro
	

	cmpl 	numComodos, %ebx 	# caso insercao no inicio
	jge 	_inserePrimeiro

_voltaInsercao:
	cmpl 	$NULL, %esi 		# caso insercao no fim
	je 		_insere

	movl 	%esi, %edi
	addl 	tamReg, %edi		# busca o campo do numero de comodos em edi
	subl 	$8, %edi
	movl 	(%edi), %ebx		# ebx = numero de comodos

	cmpl 	numComodos, %ebx
	jge		_insere

	movl 	%esi, regAntes
	addl 	$4, %edi
	movl 	(%edi), %ecx		# ecx = ponteiro pro prox
	movl 	%ecx, %esi			# esi avanca para o prox registro

	jmp 	_voltaInsercao


_insere:	
	# endereco do primeiro registro com num comodos maior que reg esta em %esi
	# o elemento anterior a esi na lista esta em regAntes

	movl 	reg, %edi
	addl 	tamReg, %edi		# busca o campo do ponteiro pro prox em edi
	subl 	$4, %edi
	movl 	%esi, (%edi)

	movl 	regAntes, %esi		# busca o campo do ponteiro pro prox em regAntes
	addl 	tamReg, %esi
	subl 	$4, %esi
	movl 	reg, %edi
	movl 	%edi, (%esi)

	RET

_inserePrimeiro:
	movl 	reg, %edi
	addl 	tamReg, %edi		# busca o campo do ponteiro pro prox em edi
	subl 	$4, %edi
	movl 	listaReg, %esi
	movl 	%esi, (%edi)		# coloca o primeiro da lista como o proximo de edi

	movl 	reg, %edi			# coloca edi como primeiro da lista
	movl 	%edi, listaReg

	RET

#########################################################
# RELATORIO 
#########################################################

gerarRelatorio:
	push 	$txtGerarRelatorio
	call 	printf
	addl 	$4, %esp
	
	movl 	$1, cont			# contador p/ print
	movl 	listaReg, %edi
	movl 	%edi, reg 			# reg possui o ponteiro pro registro atual
	movl 	n, %ecx				# contador loop	

_voltaMostraListaReg:
	pushl 	%ecx				# print "Registro X"
	pushl 	%edi
	call 	mostraReg 			# mostra conteudos do reg

	movl 	cont, %eax			# incr contador
	incl 	%eax
	movl 	%eax, cont

	movl 	tamReg, %eax		# vai ate o campo prox e atualiza reg
	subl 	$4, %eax
	movl 	reg, %edi
	addl 	%eax, %edi
	movl 	(%edi), %ebx
	movl 	%ebx, reg

	popl 	%edi
	popl 	%ecx
	loop 	_voltaMostraListaReg

	RET

mostraReg:

	pushl 	cont
	pushl	$txtRegistroN
	call	printf
	addl	$8, %esp

# nome
	movl	reg, %edi			
	pushl	%edi
	pushl	$txtMostraNome
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$64, %edi

# CPF
	pushl	%edi				
	pushl	$txtMostraCPF		
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$16, %edi

# Telefone
	pushl	%edi				
	pushl	$txtMostraTelefone	
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$16, %edi

# tipo imovel
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraTipoImovel
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# endereco
	pushl	%edi				
	pushl	$txtMostraEndereco		
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$64, %edi

# num quartos
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraNumQuartos
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# num suites
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraNumSuites
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# tem banheiro social
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraTemBSocial
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# tem cozinha
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraTemCozinha
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# tem sala
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraTemSala
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# tem garagem
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraTemGaragem
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# metragem
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraMetragem
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# aluguel
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraAluguel
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

# num comodos
	pushl	%edi 				
	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraNumComodos
	call	printf
	addl	$12, %esp

	RET


_REMOVERDPS:
	pushl 	%eax
	pushl 	%ebx
	pushl 	%edx
	pushl 	%edi
	pushl 	%esi
	pushl 	%ecx
	pushl 	$tipoNum
	call 	printf
	addl 	$4, %esp	
	popl 	%ecx
	popl 	%esi
	popl 	%edi
	popl 	%edx
	popl 	%ebx
	popl 	%eax


#########################################################
# SALVARE RELATORIO 
#########################################################

salvarRelatorio:
    #FILE *fopen(const char *filename, const char *mode)
    pushl $tipoAberturaArq
    pushl $nomeArquivoSaida
    call fopen 
    movl %eax, ponteiroArquivoSaida
    addl $8, %esp 


    push 	$txtSalvarRelatorio
	call 	printf
	addl 	$4, %esp
	
	movl 	$1, cont			# contador p/ print
	movl 	listaReg, %edi
	movl 	%edi, reg 			# reg possui o ponteiro pro registro atual
	movl 	n, %ecx				# contador loop	


_voltaSalvarRelatorio:
	pushl 	%ecx				# print "Registro X"
	pushl 	%edi
	call 	salvaReg 			# mostra conteudos do reg

	movl 	cont, %eax			# incr contador
	incl 	%eax
	movl 	%eax, cont

	movl 	tamReg, %eax		# vai ate o campo prox e atualiza reg
	subl 	$4, %eax
	movl 	reg, %edi
	addl 	%eax, %edi
	movl 	(%edi), %ebx
	movl 	%ebx, reg

	popl 	%edi
	popl 	%ecx
	loop 	_voltaSalvarRelatorio



    pushl ponteiroArquivoSaida 
    call fclose 
    addl $4, %esp
    jmp _menuInicial
	RET


salvaReg:
    movl	reg, %edi
    #fwrite(buffer, 1, sizeof(buffer), fp);
    pushl ponteiroArquivoSaida
    pushl $200 
    pushl $1
    movl (%edi), %eax
    pushl %eax
    call fwrite
    addl $204, %edi
    addl $16, %esp
    #addl $8, %esp
    RET
