// --- Objeto para representar um Item da Lista de Compras ---
/**
 * Representa um item individual na lista de compras.
 * @param {string} nome - O nome do item.
 * @param {number} quantidade - A quantidade do item.
 */
class ItemCompra {
    constructor(nome, quantidade) {
        if (!nome || quantidade <= 0) {
            throw new Error("Nome e quantidade válida são obrigatórios para um item.");
        }
        this.id = Date.now().toString() + Math.floor(Math.random() * 1000).toString(); // ID simples
        this.nome = nome;
        this.quantidade = quantidade;
        this.comprado = false; // Flag para indicar se o item já foi comprado
    }

    /**
     * Exibe os detalhes do item no console.
     */
    exibirDetalhes() {
        const status = this.comprado ? "(COMPRADO)" : "(PENDENTE)";
        console.log(`ID: ${this.id}`);
        console.log(`- ${this.nome} (${this.quantidade} unidades) ${status}`);
        console.log("---");
    }
}

// --- Gerenciador da Lista de Compras ---
/**
 * Gerencia as operações da lista de compras.
 */
class GerenciadorDeListaDeCompras {
    constructor() {
        this.listaDeCompras = []; // Array para armazenar os itens
        console.log("Gerenciador de Lista de Compras iniciado!");
    }

    /**
     * Adiciona um novo item à lista.
     * @param {string} nome - Nome do item a ser adicionado.
     * @param {number} quantidade - Quantidade do item.
     * @returns {ItemCompra|null} O item adicionado ou null em caso de erro.
     */
    adicionarItem(nome, quantidade) {
        try {
            const novoItem = new ItemCompra(nome, quantidade);
            this.listaDeCompras.push(novoItem);
            console.log(`Item "${nome}" (${quantidade} unidades) adicionado com sucesso!`);
            return novoItem;
        } catch (error) {
            console.error(`Erro ao adicionar item: ${error.message}`);
            return null;
        }
    }

    /**
     * Lista todos os itens na lista de compras.
     */
    listarItens() {
        console.log("\n--- Sua Lista de Compras ---");
        if (this.listaDeCompras.length === 0) {
            console.log("Sua lista de compras está vazia.");
            return;
        }
        this.listaDeCompras.forEach(item => item.exibirDetalhes());
        console.log("----------------------------");
    }

    /**
     * Marca um item como comprado usando seu ID.
     * @param {string} idItem - O ID do item a ser marcado.
     * @returns {boolean} True se o item foi marcado, false caso contrário.
     */
    marcarComoComprado(idItem) {
        const item = this.listaDeCompras.find(i => i.id === idItem);
        if (item) {
            if (!item.comprado) {
                item.comprado = true;
                console.log(`Item "${item.nome}" marcado como COMPRADO.`);
                return true;
            } else {
                console.log(`Item "${item.nome}" já estava marcado como COMPRADO.`);
                return false;
            }
        } else {
            console.warn(`Item com ID "${idItem}" não encontrado na lista.`);
            return false;
        }
    }

    /**
     * Remove um item da lista usando seu ID.
     * @param {string} idItem - O ID do item a ser removido.
     * @returns {boolean} True se o item foi removido, false caso contrário.
     */
    removerItem(idItem) {
        const indice = this.listaDeCompras.findIndex(item => item.id === idItem);
        if (indice > -1) {
            const [itemRemovido] = this.listaDeCompras.splice(indice, 1); // Remove e captura o item
            console.log(`Item "${itemRemovido.nome}" removido da lista.`);
            return true;
        } else {
            console.warn(`Item com ID "${idItem}" não encontrado para remoção.`);
            return false;
        }
    }

    /**
     * Busca itens pelo nome (parcial ou completo).
     * @param {string} termoBusca - Termo a ser procurado no nome do item.
     * @returns {Array<ItemCompra>} Um array de itens que correspondem ao termo.
     */
    buscarItens(termoBusca) {
        console.log(`\n--- Buscando itens por "${termoBusca}" ---`);
        const resultados = this.listaDeCompras.filter(item =>
            item.nome.toLowerCase().includes(termoBusca.toLowerCase())
        );

        if (resultados.length === 0) {
            console.log(`Nenhum item encontrado com o termo: "${termoBusca}"`);
        } else {
            resultados.forEach(item => item.exibirDetalhes());
        }
        console.log("---------------------------------------");
        return resultados;
    }
}

// --- Exemplo de Uso (Código para executar o gerenciador) ---

console.log("\n--- Iniciando o Gerenciador de Lista de Compras em JavaScript ---");

const minhaLista = new GerenciadorDeListaDeCompras();

// 1. Adicionar itens
const itemArroz = minhaLista.adicionarItem("Arroz", 2);
const itemFeijao = minhaLista.adicionarItem("Feijão", 1);
minhaLista.adicionarItem("Leite", 3);
minhaLista.adicionarItem("Pão", 1);
minhaLista.adicionarItem("Café", 1);

// 2. Listar todos os itens
minhaLista.listarItens();

// 3. Marcar um item como comprado (usando o ID retornado na adição)
if (itemArroz) { // Verifica se o itemArroz foi adicionado com sucesso
    minhaLista.marcarComoComprado(itemArroz.id);
}

// 4. Listar novamente para ver o item marcado
minhaLista.listarItens();

// 5. Remover um item
if (itemFeijao) {
    minhaLista.removerItem(itemFeijao.id);
}

// 6. Listar após remoção
minhaLista.listarItens();

// 7. Buscar itens
minhaLista.buscarItens("ão"); // Vai encontrar Pão e Café
minhaLista.buscarItens("cenoura"); // Não vai encontrar nada

// Exemplo de adição inválida
minhaLista.adicionarItem("Açúcar", 0);
minhaLista.adicionarItem("", 1);


console.log("\n--- Fim da demonstração do Gerenciador de Lista de Compras ---");
