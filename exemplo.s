/*
Esse programa realiza a gravacao e leitura de registros em um arquivo,usando chamadas ao
sistema nas funcoes que manipulam arquivo. Por meio de um menu de opções, o usuario pode
escolher gravar ou mostrar registros. Os registros contem apenas 3 campos, mas poderiam
ter mais.
*/

.section .data

	txtAbertura: 	.asciz 	"\nPrograma de Leitura e Gravacao de Registros\n"
	txtMenu: 	.asciz 	"\nMenu de Opcoes:\n<1> Gravar Registro\n<2> Mostrar Arquivo\n<3> Sair\n=> "
	txtPedeNomeArq: .asciz 	"\nEntre com o nome do arquivo de entrada/saida\n> "
	txtPedeNome: 	.asciz 	"\nDigite seu nome => "
	txtPedeProf: 	.asciz 	"\nDigite sua profissao => "
	txtPedeSal: 	.asciz 	"\nDigite seu salario => "
	txtMostraNome: 	.asciz 	"\nNome: %s\n"
	txtMostraProf: 	.asciz 	"\nProfissao: %s\n"
	txtMostraSal: 	.asciz 	"\nSalario: R$ %.2lf\n"
	txtFim: 	.asciz 	"\nFinalizando ...\n>>> Veja o Arquivo como Ficou!\n\n"
	nomeArq: 	.space 	50
	registro: 	.space 	128 # nome (70), profissao (50), salario (8 = double)
	tam: 		.int  	128
	lixo: 		.int 	0
	opcao: 		.int 	0
	iformato: 	.asciz 	"%d"
	fformato: 	.asciz 	"%lf"
	descritor: 	.int 	0 # descritor do arquivo de entrada/saida

# As constantes abaixo se referem aos serviços disponibilizados pelas
# chamadas ao sistema, devendo serem passadas no registrador %eax

	SYS_EXIT: 	.int 1
	SYS_FORK: 	.int 2
	SYS_READ: 	.int 3
	SYS_WRITE: 	.int 4
	SYS_OPEN: 	.int 5
	SYS_CLOSE: 	.int 6
	SYS_CREAT: 	.int 8

# Descritores de arquivo para saída e entrada padrão

	STD_OUT: 	.int 1 # descritor do video
	STD_IN:  	.int 2 # descritor do teclado

# Constante usada na chamada exit() para término normal

	SAIDA_NORMAL: 	.int 0 # codigo de saida bem sucedida

# Constantes de configuração do parametro flag da chamada open(). Estes valores
# são dependentes de implementação. Para se ter certeza dos valores corretos, compile o
# programa no final deste arquivo usando "gcc valoresopen.c -o valoresopen" e execute-o
# usando "./valoresopen". Caso seja diferente, corrija as definicoes abaixo.

	O_RDONLY: .int 0x0000 # somente leitura
	O_WRONLY: .int 0x0001 # somente escrita
	O_RDWR:   .int 0x0002 # leitura e escrita
	O_CREAT:  .int 0x0040 # cria o arquivo na abertura, caso ele não exista
	O_EXCL:   .int 0x0080 # força a criação
	O_APPEND: .int 0x0400 # posiciona o cursor do arquivo no final, para adição
	O_TRUNC:  .int 0x0200 # reseta o arquivo aberto, deixando com tamanho 0 (zero)

# Constantes de configuração do parametro mode da chamada open().

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
	S_NADA:  .int 0x0000 # não altera a situação

.section .text
.globl _start
_start:

	call abertura
	finit

inicio:
	call 	menuOp
	movl 	opcao, %eax
	cmpl 	$1, %eax
	je 	gravaArq
	cmpl 	$2, %eax
	je 	mostraArq
	jmp 	fim

abertura:
	pushl 	$txtAbertura
	call 	printf
	pushl 	$txtPedeNomeArq
	call 	printf
	pushl 	$nomeArq
	call 	gets
	addl 	$12, %esp
	ret

menuOp:
	pushl 	$txtMenu
	call 	printf
	pushl 	$opcao
	pushl 	$iformato
	call 	scanf
	pushl 	$lixo
	call 	gets 		# para ler e descartar o enter restante
	addl 	$16, %esp
	ret

gravaArq:
	call 	abreArqS
	call 	leReg
	call 	gravaReg
	call 	fechaArq
	jmp 	inicio

abreArqS:
	movl 	SYS_OPEN, %eax 	# system call OPEN: retorna o descritor em %eax
	movl 	$nomeArq, %ebx
	movl 	O_WRONLY, %ecx
	orl 	O_CREAT, %ecx
	orl 	O_APPEND, %ecx
	movl 	S_IRUSR, %edx
	orl 	S_IWUSR, %edx
	int 	$0x80
	movl 	%eax, descritor # guarda o descritor
	ret

leReg:
	pushl 	$txtPedeNome
	call 	printf
	movl 	$registro, %edi
	pushl 	%edi
	call 	gets
	pushl 	$txtPedeProf
	call 	printf
	movl 	$registro, %edi
	addl 	$70, %edi
	pushl 	%edi
	call 	gets
	pushl 	$txtPedeSal
	call 	printf
	movl 	$registro, %edi
	addl 	$120, %edi
	pushl 	%edi
	pushl 	$fformato
	call 	scanf
	pushl 	$lixo
	call 	gets 		# para ler e descartar o enter restante
	addl 	$32, %esp
	ret

gravaReg:
	movl 	SYS_WRITE, %eax
	movl 	descritor, %ebx # recupera o descritor
	movl 	$registro, %ecx
	movl 	tam, %edx
	int 	$0x80
	ret

mostraArq:
	call 	abreArqE
	call 	mostraRegs
	call 	fechaArq
	jmp 	inicio

abreArqE:
	movl 	SYS_OPEN, %eax 	# system call OPEN: retorna o descritor em %eax
	movl 	$nomeArq, %ebx
	movl 	O_RDONLY, %ecx
	int 	$0x80
	movl 	%eax, descritor # guarda o descritor
	ret

mostraRegs:
	movl 	SYS_READ, %eax # %eax retorna numero de bytes lidos
	movl 	descritor, %ebx # recupera o descritor
	movl 	$registro, %ecx
	movl 	tam, %edx
	int 	$0x80 # le registro do arquivo
	movl 	$registro, %edi
	cmpl 	$0, %eax
	je 	fimMostra
	pushl 	%edi
	pushl 	$txtMostraNome
	call 	printf
	movl 	$registro, %edi
	addl 	$70, %edi
	pushl 	%edi
	pushl 	$txtMostraProf
	call 	printf
	movl 	$registro, %edi
	addl 	$120, %edi
	fldl 	(%edi)
	subl 	$8, %esp
	fstpl 	(%esp)
	pushl 	$txtMostraSal
	call 	printf
	addl 	$28, %esp

	# volta para mostrar mais registros
	jmp 	mostraRegs

fimMostra:
	ret

fechaArq:
	movl 	SYS_CLOSE, %eax
	movl 	descritor, %ebx # recupera o descritor
	int 	$0x80
	ret

fim:
	pushl 	$txtFim
	call 	printf
	addl 	$4, %esp
	pushl 	$0
	call 	exit

/*
Desafio Opcional: Modifique o programa e acrescente os campos idade e CPF. Faça as alterações que forem necessárias para ele funcionar. Depois, ajuste o código para ele não ficar abrindo e fechando a cada escrita, de tal forma que para uma sequencia contigua de escritas, o arquivo serah aberto antes da primeira e serah fechado após a última escrita. 
*/
