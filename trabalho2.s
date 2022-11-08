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
	itemGravarArquivo:		.asciz "Gravar Registros em Arquivo          (5)\n"
	itemRecuperarArquivo:	.asciz "Recuperar Registros em Arquivo       (6)\n"
	itemSair:				.asciz "Sair                                 (7)\n"
	opcaoMenu:		    	.asciz "Opcao escolhida: "
	opcaoInvalida:		    .asciz "Opcao invalida!\n"
	
	txtRegistrarImovel: 	.asciz 	"# Registro de Imovel #\n"
	txtRemoverImovel:		.asciz 	"# Remocao de Imovel #\n"
	txtConsultarImovel:		.asciz  "# Consulta de Imoveis por Numero de Comodos #\n"
	txtGerarRelatorio:		.asciz	"# Relatorio de Imoveis #\n"
	txtGravarArquivo:		.asciz	"# Gravacao de Registros em Arquivo #\n"
	txtRecuperarArquivo:	.asciz	"# Recuperacao de Registros em Arquivo #\n"

	txtRegistroN: 			.asciz 	"\n- Registro %d -\n"
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
	txtPedeNomeArq: 	.asciz 	"Entre com o nome do arquivo de entrada/saida: "

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
	txtMostraMetragem:	    .asciz	"Metragem do imovel: %.2f m2\n"
	txtMostraAluguel:	    .asciz	"Valor do aluguel do imovel: R$%.2f\n"
	txtMostraNumComodos:	.asciz	"Numero de comodos: %d\n"
	txtListaVazia:			.asciz	"Lista vazia, insira algo antes \n"
	
	tipoNum: 	.asciz 	"%d"
	tipoFloat: 	.asciz 	"%f"
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
	nomeArq: 	.space 	50
	descritor: 	.int 	0 # descritor do arquivo de entrada/saida

	listaReg:	.space	4	# ponteiro para o primeiro registro
	reg:		.space	4 	# ponteiro auxiliar para registros
	regAntes: 	.space 	4

	NULL:		.int 0
	opcao:		.int 0
	
	
	# As constantes abaixo se referem aos servi�os disponibilizados pelas
	# chamadas ao sistema, devendo serem passadas no registrador %eax
	SYS_EXIT: 	.int 1
	SYS_FORK: 	.int 2
	SYS_READ: 	.int 3
	SYS_WRITE: 	.int 4
	SYS_OPEN: 	.int 5
	SYS_CLOSE: 	.int 6
	SYS_CREAT: 	.int 8

	# Descritores de arquivo para sa�da e entrada padr�o
	STD_OUT: 	.int 1 # descritor do video
	STD_IN:  	.int 2 # descritor do teclado

	# Constante usada na chamada exit() para t�rmino normal
	SAIDA_NORMAL: 	.int 0 # codigo de saida bem sucedida

	# Constantes de configura��o do parametro flag da chamada open(). Estes valores
	# s�o dependentes de implementa��o. Para se ter certeza dos valores corretos, compile o
	# programa no final deste arquivo usando "gcc valoresopen.c -o valoresopen" e execute-o
	# usando "./valoresopen". Caso seja diferente, corrija as definicoes abaixo.
	O_RDONLY: .int 0x0000 # somente leitura
	O_WRONLY: .int 0x0001 # somente escrita
	O_RDWR:   .int 0x0002 # leitura e escrita
	O_CREAT:  .int 0x0040 # cria o arquivo na abertura, caso ele n�o exista
	O_EXCL:   .int 0x0080 # for�a a cria��o
	O_APPEND: .int 0x0400 # posiciona o cursor do arquivo no final, para adi��o
	O_TRUNC:  .int 0x0200 # reseta o arquivo aberto, deixando com tamanho 0 (zero)

	# Constantes de configura��o do parametro mode da chamada open().
	S_IRWXU: .int 0x01C0# user (file owner) has read, write and execute permission
	S_IRUSR: .int 0x0100 # user has read permission
	S_IWUSR: .int 0x0080 # user has write permission
	S_IXUSR: .int 0x0040 # user has execute permission
	S_IRWXG: .int 0x0038 # group has read, write and execute permission
	S_IRGRP: .int 0x0020 # group has read permission
	S_IWGRP: .int 0x0010 # group has write permission
	S_IXGRP: .int 0x0008 # group has execute permission
	S_IRWXO: .int 0x0007 # others have read, write and execute permission
	S_IROTH: .int 0x0004 # others have read permission
	S_IWOTH: .int 0x0002 # others have write permission
	S_IXOTH: .int 0x0001 # others have execute permission
	S_NADA:  .int 0x0000 # n�o altera a situa��o

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
	finit
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
	pushl 	$itemGravarArquivo 
	call 	printf
	pushl 	$itemRecuperarArquivo 
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

	addl	$72, %esp

	movl	opcao, %eax
	cmpl	$0, %eax
	jle	_opcaoInvalida
	cmpl 	$8, %eax 
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

	cmpl	$5, %eax
	je _gravarArquivo

	cmpl	$6, %eax
	je _recuperarArquivo

	cmpl	$7, %eax
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

_gravarArquivo:
	call gravarArquivo
	jmp _voltaMenu

_recuperarArquivo:
	call recuperarArquivo
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
	movl 	%edi, reg		# reg = endereco do registro a ser removido
	addl	tamReg, %edi 	# busca o campo do ponteiro pro prox em edi
	subl	$4, %edi
	movl 	(%edi), %eax
	movl 	%eax, (%ebx)

	pushl 	reg
	call 	free
	addl 	$4, %esp

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

	call 	leReg				# le registro e salva o endereco na variavel reg
	call 	insereReg 			# insere o registro apontado por reg na lista em listaReg

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

	pushl	$tipoFloat
	call	scanf
	addl	$4, %esp

	popl	%edi
	addl	$4, %edi
	pushl	%edi

	# Aluguel
	pushl	$txtPedeAluguel 
	call	printf
	addl	$4, %esp

	pushl	$tipoFloat
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

	movl 	n, %eax				# atualiza numero de registros
	incl 	%eax
	movl 	%eax, n

	cmpl	$1, n				# caso lista vazia
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
	pushl 	%ecx				
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
	flds 	(%edi)		# carrega conteudo de edi no topo da
						# Pilha PFU, convertendo 4 bytes em 80 bits
	subl 	$8, %esp 	# abre espaco de 8 bytes no topo da Pilha do Sistema
	fstpl 	(%esp) 		# remove (pop) da Pilha PFU para a Pilha do Sistema.
	pushl	$txtMostraMetragem
	call	printf
	addl 	$8, %esp 	# remove o float empilhado
	addl	$4, %esp	# remove o push feito

	popl	%edi
	addl	$4, %edi

	# aluguel
	pushl	%edi 
	flds 	(%edi)		
	subl 	$8, %esp 
	fstpl 	(%esp) 	
	pushl	$txtMostraAluguel
	call	printf
	addl 	$12, %esp

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

#########################################################
# ESCREVE ARQUIVO 
#########################################################

gravarArquivo:
	push 	$txtGravarArquivo
	call 	printf
	pushl 	$txtPedeNomeArq
	call 	printf
	pushl 	$nomeArq
	call 	gets
	addl 	$12, %esp

	call 	abreArqSaida
	call 	gravaRegs
	call 	fechaArq
	RET

abreArqSaida:
	movl 	SYS_OPEN, %eax 	# system call OPEN: retorna o descritor em %eax
	movl 	$nomeArq, %ebx
	movl 	O_WRONLY, %ecx
	orl 	O_CREAT, %ecx
	orl 	O_APPEND, %ecx
	movl 	S_IRUSR, %edx
	orl 	S_IWUSR, %edx
	int 	$0x80
	movl 	%eax, descritor # guarda o descritor
	RET

gravaRegs:
	movl 	listaReg, %edi
	movl 	%edi, reg 			# reg possui o ponteiro pro registro atual
	movl 	n, %ecx				# contador loop

_voltaGravaRegs:
	pushl 	%ecx
	movl 	SYS_WRITE, %eax
	movl 	descritor, %ebx 	# recupera o descritor
	movl 	reg, %ecx
	movl 	tamReg, %edx
	int 	$0x80				# chamada pra gravar

	movl 	tamReg, %eax		# vai ate o campo prox e atualiza reg
	subl 	$4, %eax
	movl 	reg, %edi
	addl 	%eax, %edi
	movl 	(%edi), %ebx
	movl 	%ebx, reg

	popl 	%ecx
	loop 	_voltaGravaRegs
	RET

#########################################################
# RECUPERA ARQUIVO
#########################################################

recuperarArquivo:
	push 	$txtRecuperarArquivo
	call 	printf
	pushl 	$txtPedeNomeArq
	call 	printf
	pushl 	$nomeArq
	call 	gets
	addl 	$12, %esp

	call 	abreArqEntrada
	call 	recuperaRegs
	call 	fechaArq
	RET

abreArqEntrada:
	movl 	SYS_OPEN, %eax 		# system call OPEN: retorna o descritor em %eax
	movl 	$nomeArq, %ebx
	movl 	O_RDONLY, %ecx
	int 	$0x80
	movl 	%eax, descritor 	# guarda o descritor
	RET

recuperaRegs:
	pushl	tamReg			# aloca
	call	malloc
	addl	$4, %esp
	movl	%eax, reg 		# move ponteiro da primeira posicao pra reg

_voltaRecuperaRegs:
	movl 	SYS_READ, %eax # %eax retorna numero de bytes lidos
	movl 	descritor, %ebx # recupera o descritor
	movl 	reg, %ecx
	movl 	tamReg, %edx
	int 	$0x80 # le registro do arquivo

	cmpl 	$0, %eax
	je 	_fimRecuperaRegs
	call 	mostraReg

	# volta para mostrar mais registros
	jmp 	_voltaRecuperaRegs

_fimRecuperaRegs:
	pushl 	reg
	call 	free
	addl 	$4, %esp
	RET

fechaArq:
	movl 	SYS_CLOSE, %eax
	movl 	descritor, %ebx # recupera o descritor
	int 	$0x80
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
