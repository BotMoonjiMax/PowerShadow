package {
    import flash.display.Sprite; // Importa uma classe básica, mesmo que não a usemos visualmente
    import flash.utils.getTimer; // Para um ID simples baseado em tempo

    /**
     * Classe que representa um item individual no inventário.
     */
    public class ItemInventario {
        public var id:String;
        public var nome:String;
        public var quantidade:int;
        public var preco:Number; // Preço por unidade

        /**
         * Construtor da classe ItemInventario.
         * @param nome O nome do item.
         * @param quantidade A quantidade do item.
         * @param preco O preço unitário do item.
         */
        public function ItemInventario(nome:String, quantidade:int, preco:Number) {
            // Validações básicas
            if (nome == null || nome.length == 0) {
                throw new ArgumentError("O nome do item não pode ser vazio.");
            }
            if (quantidade <= 0) {
                throw new ArgumentError("A quantidade do item deve ser maior que zero.");
            }
            if (preco < 0) { // Preço pode ser zero, mas não negativo
                throw new ArgumentError("O preço do item não pode ser negativo.");
            }

            this.id = "item_" + getTimer().toString() + "_" + Math.floor(Math.random() * 1000).toString(); // ID simples
            this.nome = nome;
            this.quantidade = quantidade;
            this.preco = preco;

            trace("Item '" + this.nome + "' criado com ID: " + this.id);
        }

        /**
         * Calcula o valor total deste item (quantidade * preço).
         * @return O valor total do item.
         */
        public function getValorTotal():Number {
            return this.quantidade * this.preco;
        }

        /**
         * Retorna uma representação em string do item.
         * @return Uma string com os detalhes do item.
         */
        public function toString():String {
            return "ID: " + this.id.substring(0, 8) + "...\n" +
                   "  Nome: " + this.nome + "\n" +
                   "  Quantidade: " + this.quantidade + "\n" +
                   "  Preço Unitário: R$ " + this.preco.toFixed(2) + "\n" +
                   "  Valor Total: R$ " + this.getValorTotal().toFixed(2) + "\n" +
                   "---";
        }
    }

    /**
     * Classe que gerencia a coleção de itens do inventário.
     */
    public class GerenciadorInventario extends Sprite { // Herda de Sprite para ser executável como um .swf
        private var itens:Array; // Array para armazenar objetos ItemInventario

        public function GerenciadorInventario() {
            super(); // Chama o construtor da classe pai (Sprite)
            itens = new Array();
            trace("Gerenciador de Inventário iniciado!");

            // --- Exemplo de Uso ---
            executarExemplo();
        }

        /**
         * Adiciona um novo item ao inventário.
         * @param item Novo objeto ItemInventario a ser adicionado.
         * @return O item adicionado ou null se houver erro ou duplicidade.
         */
        public function adicionarItem(item:ItemInventario):ItemInventario {
            // Verifica se o ID já existe (improvável com getTimer, mas boa prática)
            var itemExistente:ItemInventario = encontrarItemPorId(item.id);
            if (itemExistente != null) {
                trace("Aviso: Item com ID " + item.id + " já existe e não será adicionado novamente.");
                return null;
            }

            itens.push(item);
            trace("Item '" + item.nome + "' adicionado ao inventário.");
            return item;
        }

        /**
         * Lista todos os itens no inventário.
         */
        public function listarItens():void {
            trace("\n--- Itens no Inventário ---");
            if (itens.length == 0) {
                trace("Seu inventário está vazio.");
                trace("--------------------------");
                return;
            }
            for (var i:int = 0; i < itens.length; i++) {
                trace(itens[i].toString());
            }
            trace("--------------------------");
        }

        /**
         * Encontra um item pelo seu ID.
         * @param idItem O ID do item a ser encontrado.
         * @return O objeto ItemInventario ou null se não encontrado.
         */
        public function encontrarItemPorId(idItem:String):ItemInventario {
            for each (var item:ItemInventario in itens) { // Loop for each
                if (item.id == idItem || item.id.indexOf(idItem) == 0) { // Compara ID ou prefixo
                    return item;
                }
            }
            return null;
        }

        /**
         * Busca itens pelo nome (parcial ou completo).
         * @param termoBusca Termo a ser procurado no nome do item.
         * @return Um Array de itens que correspondem ao termo.
         */
        public function buscarItens(termoBusca:String):Array {
            trace("\n--- Buscando itens por '" + termoBusca + "' ---");
            var resultados:Array = new Array();
            for each (var item:ItemInventario in itens) {
                if (item.nome.toLowerCase().indexOf(termoBusca.toLowerCase()) != -1) {
                    resultados.push(item);
                }
            }

            if (resultados.length == 0) {
                trace("Nenhum item encontrado com o termo: \"" + termoBusca + "\"");
            } else {
                for each (var resultadoItem:ItemInventario in resultados) {
                    trace(resultadoItem.toString());
                }
            }
            trace("---------------------------------------");
            return resultados;
        }

        /**
         * Remove um item do inventário pelo seu ID.
         * @param idItem O ID do item a ser removido.
         * @return O item removido ou null se não encontrado.
         */
        public function removerItem(idItem:String):ItemInventario {
            var itemRemovido:ItemInventario = null;
            for (var i:int = 0; i < itens.length; i++) {
                if (itens[i].id == idItem || itens[i].id.indexOf(idItem) == 0) {
                    itemRemovido = itens[i];
                    itens.splice(i, 1); // Remove 1 elemento a partir do índice i
                    trace("Item '" + itemRemovido.nome + "' (ID: " + idItem + ") removido do inventário.");
                    return itemRemovido;
                }
            }
            trace("Aviso: Item com ID " + idItem + " não encontrado para remoção.");
            return null;
        }

        /**
         * Função de exemplo para demonstrar o uso do gerenciador.
         */
        private function executarExemplo():void {
            trace("\n--- Iniciando o Exemplo do Gerenciador de Inventário ---");

            try {
                // 1. Adicionar itens
                var item1:ItemInventario = new ItemInventario("Maçãs", 10, 2.50);
                adicionarItem(item1);

                var item2:ItemInventario = new ItemInventario("Leite", 2, 4.00);
                adicionarItem(item2);

                adicionarItem(new ItemInventario("Pão Integral", 1, 6.75));
                adicionarItem(new ItemInventario("Queijo Minas", 1, 25.00));

                // 2. Listar todos os itens
                listarItens();

                // 3. Buscar itens
                buscarItens("Maçãs");
                buscarItens("Queijo");
                buscarItens("ovos"); // Não deve encontrar

                // 4. Remover um item
                if (item1 != null) { // Verifica se item1 foi adicionado
                    removerItem(item1.id);
                }

                // 5. Listar itens após remoção
                listarItens();

                // Exemplo de erro (quantidade inválida)
                // var itemInvalido:ItemInventario = new ItemInventario("Coca-cola", 0, 8.00);
                // adicionarItem(itemInvalido);

            } catch (e:Error) {
                trace("Erro inesperado durante o exemplo: " + e.message);
            }

            trace("\n--- Fim da demonstração do Gerenciador de Inventário ---");
        }
    }
}
