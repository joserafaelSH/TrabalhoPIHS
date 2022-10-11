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
Num Comodos:                                        (1 inteiro = 4 bytes) # nao vai pedir, é a soma dos comodos
Metragem:                                           (1 inteiro = 4 bytes)
Aluguel:                                            (1 inteiro = 4 bytes)

* Ponteiro: space (4 bytes)

Total = 64+64 + 16+16 + 11*4 = 204 bytes

*/

.section .data
	txtAbertura: 	.asciz 	"\n*** Leitura e Escrita de Registros ***\n"
	txtRegistroN: 	.asciz 	"\n- Registro %d -\n"
	txtLeitura: 	.asciz 	"\n##### Leitura de Registros #####\n"
	txtMostra: 		.asciz 	"\n##### Exibicao de Registros #####\n"
	txtPedeN:	    .asciz	"\nDigite o numero de registros: "

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


	txtMostraReg:	.asciz	"\nRegistro Lido"
	txtMostraNome:	.asciz	"\nNome: %s"
	txtMostraCPF:	.asciz	"\nCPF: %s"
	txtMostraTelefone:	    .asciz	"\nTelefone: %s"
    txtMostraTipoImovel:	.asciz	"\nTipo do imovel - Casa(C) ou Apartamento(A): %c"
	txtMostraEndereco:	    .asciz	"\nEndereco do imovel: %s" 
	txtMostraNumQuartos:	.asciz	"\nNumero de quartos: %d"
	txtMostraNumSuites:	    .asciz	"\nNumero de suites: %d"
	txtMostraTemBSocial:	.asciz	"\nImovel possui Banheiro Social? (0-Nao 1-Sim): %d"
	txtMostraTemCozinha:	.asciz	"\nImovel possui Cozinha? (0-Nao 1-Sim): %d"
	txtMostraTemSala:	    .asciz	"\nImovel possui Sala? (0-Nao 1-Sim): %d"
	txtMostraTemGaragem:	.asciz	"\nImovel possui Garagem? (0-Nao 1-Sim): %d"
	txtMostraMetragem:	    .asciz	"\nMetragem do imovel: %d"
	txtMostraAluguel:	    .asciz	"\nValor do aluguel do imovel: %d"

	tipoNum: 	.asciz 	"%d"
	tipoChar:	.asciz	"%c"
	tipoStr:	.asciz	"%s"
	pulaLinha: 	.asciz 	"\n"

	tamReg:  	.int 	204
	n: 			.int 	0 	# num de registros cadastrados
	cont: 		.int 	0

	listaReg:	.space	4	# ponteiro para o primeiro registro
	reg:		.space	4 	# ponteiro auxiliar para registro
	regAntes: 	.space 	4

	NULL:		.int 0
	
.section .text
.globl _start
_start:

	pushl	$txtAbertura
	call	printf
	addl	$4, %esp

	call 	pedeN
	call 	leListaReg
	call	mostraListaReg

fim:
	pushl $0
	call exit


pedeN:
	pushl	$txtPedeN
	call	printf
	addl	$4, %esp

	pushl 	$n
	pushl	$tipoNum
	call	scanf	

	pushl 	stdin 		# tirar buffer
	call 	fgetc
	addl 	$12, %esp

	RET


leListaReg:
	pushl	$txtLeitura
	call	printf
	addl	$4, %esp

	movl 	$1, cont 			# contador para print

	call	leReg				# le registro e salva na variavel reg
	movl 	reg, %edi
	movl 	%edi, listaReg		# define reg como o primeiro da lista
	movl 	%edi, regAntes		# regAntes tem o registro que não tem o campo prox preenchido

	movl 	n, %ecx 			# contador para loop
	decl 	%ecx

_voltaLeListaReg:
	movl 	cont, %eax 			# incrementa cont
	incl 	%eax
	movl 	%eax, cont

	pushl 	%ecx

	call 	leReg				# le registro e salva na variavel reg
	movl 	reg, %edi
	movl 	regAntes, %esi

	movl 	tamReg, %eax 		# busca o campo do ponteiro pro prox em regAntes e preenche
	subl 	$4, %eax
	addl 	%eax, %esi
	movl 	%edi, (%esi)

	movl 	%edi, regAntes
	popl 	%ecx
	loop 	_voltaLeListaReg

	addl 	%eax, %edi
	movl 	$NULL, (%edi)

	RET

leReg:

	pushl	tamReg			# aloca
	call	malloc
	movl	%eax, reg 		# move ponteiro da primeira posicao pra reg
	
	pushl 	cont
	pushl	$txtRegistroN
	call	printf
	addl	$12, %esp

	pushl	$txtPedeNome 	# nome
	call	printf
	addl	$4, %esp

	pushl	stdin
	pushl	$64
	movl	reg, %edi
	pushl	%edi
	call	fgets

	popl	%edi
	addl	$8, %esp

	addl	$64, %edi
	pushl	%edi

	pushl	$txtPedeCPF 	# cpf
	call	printf
	addl	$4, %esp

	pushl	$tipoStr
	call	scanf

	addl	$4, %esp
	popl	%edi
	addl	$16, %edi
	pushl	%edi

	pushl 	stdin 			# telefone tirar buffer
	call 	fgetc
	addl 	$4, %esp
	
	pushl	$txtPedeTelefone 	# telefone
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
	pushl 	%edi

	pushl	$txtPedeTipoImovel 	# TipoImovel
	call	printf
	addl	$4, %esp

	pushl	$tipoChar
	call	scanf		

	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi
	
	pushl 	stdin 			# endereco tirar buffer
	call 	fgetc
	addl 	$4, %esp
	
	pushl	$txtPedeEndereco 	# endereco
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
	pushl 	%edi
	
	pushl	$txtPedeNumQuartos 	# NumQuartos
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi
	
	pushl	$txtPedeNumSuites 	# NumSuites
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$txtPedeTemBSocial 	# TemBanheiroSocial
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$txtPedeTemCozinha 	# TemCozinha
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi
	
	pushl	$txtPedeTemSala 	# TemSala
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$txtPedeTemGaragem 	# TemGaragem
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi
	
	pushl	$txtPedeMetragem 	# Metragem
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$txtPedeAluguel 	# Aluguel
	call	printf
	addl	$4, %esp

	pushl	$tipoNum
	call	scanf
	
	addl	$4, %esp
	popl	%edi
	addl	$4, %edi

	pushl 	stdin 			# tirar buffer fim
	call 	fgetc
	addl 	$4, %esp
	
	RET


mostraListaReg:
	pushl	$txtMostra
	call	printf
	addl	$4, %esp

	movl 	$1, cont			# contador p/ print
	movl 	listaReg, %edi
	movl 	%edi, reg 			# reg possui o primeiro registro
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
	/*
	pushl 	cont
	pushl	$txtRegistroN
	call	printf
	addl	$8, %esp

	movl	reg, %edi
	pushl	%edi
	pushl	$txtMostraNome
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$64, %edi
	pushl	%edi

	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraGenero
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi
	pushl	%edi

	movl	(%edi), %eax
	pushl	%eax
	pushl	$txtMostraRG
	call	printf
	addl	$8, %esp

	popl	%edi
	addl	$4, %edi
	pushl	%edi

	pushl	$txtMostraCPF
	call	printf
	addl	$4, %esp

	popl	%edi
	addl	$16, %edi

	movl	(%edi), %eax
	addl	$4, %edi
	movl	(%edi), %ebx
	addl	$4, %edi
	movl	(%edi), %ecx

	pushl	%edi
	pushl	%ecx
	pushl	%ebx
	pushl	%eax
	pushl	$txtMostraDN
	call	printf
	addl	$16, %esp

	popl	%edi
	addl	$4, %edi
	movl	(%edi), %eax
	pushl 	%edi
	pushl	%eax
	pushl	$txtMostraIdade
	call	printf

	addl	$8, %esp

	popl	%edi
	addl	$4, %edi

	pushl	%edi
	pushl	$txtMostraTelefone
	call	printf
	addl	$8, %esp
	*/

	RET