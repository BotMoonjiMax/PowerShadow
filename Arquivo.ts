// --- Interfaces e Tipos ---

/**
 * Define a estrutura de um Contato.
 */
interface Contato {
    id: string;
    nome: string;
    telefone: string;
    email?: string; // O '?' indica que o email é opcional
}

/**
 * Tipo para representar a ação de uma operação.
 */
type Acao = "Adicionar" | "Listar" | "Buscar" | "Remover";

// --- Classe Contato ---

/**
 * Representa um contato individual com suas propriedades e métodos.
 */
class ContatoIndividual implements Contato {
    public id: string;
    public nome: string;
    public telefone: string;
    public email?: string;

    constructor(nome: string, telefone: string, email?: string) {
        if (!nome || !telefone) {
            throw new Error("Nome e Telefone são obrigatórios para um contato.");
        }
        this.id = this.gerarIdUnico(); // Gera um ID único para cada contato
        this.nome = nome;
        this.telefone = telefone;
        this.email = email;
    }

    /**
     * Gera um ID único simples baseado no timestamp e um número aleatório.
     * Ideal para exemplos, em produção usaria UUIDs ou IDs de banco de dados.
     */
    private gerarIdUnico(): string {
        return `contato-${Date.now()}-${Math.floor(Math.random() * 1000)}`;
    }

    /**
     * Exibe os detalhes do contato no console.
     */
    public exibirDetalhes(): void {
        console.log(`ID: ${this.id}`);
        console.log(`Nome: ${this.nome}`);
        console.log(`Telefone: ${this.telefone}`);
        if (this.email) {
            console.log(`Email: ${this.email}`);
        }
        console.log("---");
    }
}

// --- Classe GerenciadorDeContatos ---

/**
 * Gerencia uma coleção de contatos.
 */
class GerenciadorDeContatos {
    private contatos: Contato[]; // Um array de objetos Contato

    constructor() {
        this.contatos = [];
        console.log("Gerenciador de Contatos iniciado.");
    }

    /**
     * Adiciona um novo contato à lista.
     * @param contato Novo objeto ContatoIndividual a ser adicionado.
     * @returns O contato adicionado.
     */
    public adicionarContato(contato: ContatoIndividual): Contato {
        // Verifica se o ID já existe (improvável com gerarIdUnico, mas boa prática)
        const contatoExistente = this.contatos.find(c => c.id === contato.id);
        if (contatoExistente) {
            console.warn(`Aviso: Contato com ID ${contato.id} já existe e não será adicionado novamente.`);
            return contatoExistente;
        }

        this.contatos.push(contato);
        this.logAcao("Adicionar", `Contato '${contato.nome}' adicionado.`);
        return contato;
    }

    /**
     * Lista todos os contatos ou exibe uma mensagem se não houver nenhum.
     */
    public listarContatos(): void {
        this.logAcao("Listar", "Listando todos os contatos.");
        if (this.contatos.length === 0) {
            console.log("Nenhum contato cadastrado ainda.");
            return;
        }
        this.contatos.forEach(contato => {
            // Usa type casting para tratar como ContatoIndividual e acessar exibirDetalhes
            (contato as ContatoIndividual).exibirDetalhes();
        });
    }

    /**
     * Busca contatos pelo nome (parcial ou completo).
     * @param termoBusca Termo a ser procurado no nome do contato.
     * @returns Um array de contatos que correspondem ao termo.
     */
    public buscarContatos(termoBusca: string): Contato[] {
        this.logAcao("Buscar", `Buscando contatos por '${termoBusca}'.`);
        const resultados = this.contatos.filter(contato =>
            contato.nome.toLowerCase().includes(termoBusca.toLowerCase())
        );

        if (resultados.length === 0) {
            console.log(`Nenhum contato encontrado com o termo: "${termoBusca}"`);
        } else {
            console.log(`--- Resultados da Busca para "${termoBusca}" ---`);
            resultados.forEach(contato => (contato as ContatoIndividual).exibirDetalhes());
        }
        return resultados;
    }

    /**
     * Remove um contato pelo seu ID.
     * @param id O ID do contato a ser removido.
     * @returns true se o contato foi removido, false caso contrário.
     */
    public removerContato(id: string): boolean {
        const indice = this.contatos.findIndex(contato => contato.id === id);
        if (indice > -1) {
            const nomeRemovido = this.contatos[indice].nome;
            this.contatos.splice(indice, 1); // Remove 1 elemento a partir do índice encontrado
            this.logAcao("Remover", `Contato '${nomeRemovido}' (ID: ${id}) removido com sucesso.`);
            return true;
        } else {
            console.warn(`Aviso: Contato com ID ${id} não encontrado para remoção.`);
            return false;
        }
    }

    /**
     * Registra ações no console com timestamp e tipo.
     * @param acao O tipo de ação realizada.
     * @param mensagem A mensagem descritiva da ação.
     */
    private logAcao(acao: Acao, mensagem: string): void {
        const timestamp = new Date().toLocaleString('pt-BR');
        console.log(`[${timestamp}] [${acao}] ${mensagem}`);
    }
}

// --- Exemplo de Uso (Código para executar o gerenciador) ---

console.log("\n--- Iniciando o Gerenciador de Contatos em TypeScript ---");

const meuGerenciador = new GerenciadorDeContatos();

try {
    const contato1 = new ContatoIndividual("João Silva", "(83) 98765-4321", "joao.silva@email.com");
    meuGerenciador.adicionarContato(contato1);

    const contato2 = new ContatoIndividual("Maria Oliveira", "(83) 99123-4567"); // Sem email
    meuGerenciador.adicionarContato(contato2);

    meuGerenciador.adicionarContato(new ContatoIndividual("Pedro Souza", "(83) 98888-1111", "pedro.souza@email.com"));

    console.log("\n--- Listando todos os contatos ---");
    meuGerenciador.listarContatos();

    console.log("\n--- Buscando contatos com 'Silva' ---");
    meuGerenciador.buscarContatos("Silva");

    console.log("\n--- Buscando contatos com 'Pedro' ---");
    meuGerenciador.buscarContatos("Pedro");

    console.log("\n--- Tentando buscar algo que não existe ---");
    meuGerenciador.buscarContatos("Carlos");

    console.log("\n--- Removendo o contato do João ---");
    meuGerenciador.removerContato(contato1.id);

    console.log("\n--- Listando contatos após remoção ---");
    meuGerenciador.listarContatos();

    // Exemplo de erro (nome faltando)
    // const contatoInvalido = new ContatoIndividual("", "(83) 1234-5678"); // Isso causaria um erro
    // meuGerenciador.adicionarContato(contatoInvalido);

} catch (error: any) {
    console.error(`Erro inesperado: ${error.message}`);
}

console.log("\n--- Fim da demonstração do Gerenciador de Contatos ---");

