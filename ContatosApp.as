package {
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.utils.getTimer; // Para um ID simples baseado em tempo

    /**
     * Classe para representar um Contato.
     */
    public class Contato {
        public var id:String;
        public var nome:String;
        public var telefone:String;
        public var email:String;

        /**
         * Construtor da classe Contato.
         * @param nome O nome do contato.
         * @param telefone O telefone do contato.
         * @param email O email do contato (opcional, pode ser vazio).
         */
        public function Contato(nome:String, telefone:String, email:String = "") {
            if (nome == null || nome.length == 0) {
                throw new ArgumentError("O nome do contato é obrigatório.");
            }
            if (telefone == null || telefone.length == 0) {
                throw new ArgumentError("O telefone do contato é obrigatório.");
            }

            this.id = "contato_" + getTimer().toString() + "_" + Math.floor(Math.random() * 1000).toString();
            this.nome = nome;
            this.telefone = telefone;
            this.email = email;
            trace("DEBUG: Contato '" + this.nome + "' criado com ID: " + this.id);
        }

        /**
         * Retorna uma representação em string do contato.
         * @return Uma string com os detalhes do contato.
         */
        public function toString():String {
            return "ID: " + this.id.substring(0, 8) + "...\n" +
                   "  Nome: " + this.nome + "\n" +
                   "  Telefone: " + this.telefone + "\n" +
                   "  Email: " + (this.email.length > 0 ? this.email : "N/A") + "\n" +
                   "---";
        }
    }

    /**
     * Classe principal do aplicativo Gerenciador de Contatos.
     * Estende Sprite para ser uma classe de documento em projetos Flash.
     */
    public class GerenciadorContatosApp extends Sprite {
        private var contatos:Array; // Array para armazenar objetos Contato
        private var _currentAction:String = ""; // Armazena a ação atual do "usuário"
        private var _simulatedInputIndex:int = 0; // Índice para simular entrada do usuário

        // Dados simulados para entrada do usuário, como se estivesse digitando no console.
        // Cada array representa uma sequência de entradas para uma operação.
        private var _simulatedInputs:Array = [
            // Sequência 1: Adicionar Contatos
            ["1"], // Escolhe '1. Adicionar Contato'
            ["João Silva", "(83) 98765-4321", "joao.silva@email.com"], // Dados para João
            ["Maria Oliveira", "(83) 99123-4567", ""], // Dados para Maria (sem email)
            ["Pedro Souza", "(83) 98888-1111", "pedro.souza@email.com"], // Dados para Pedro

            // Sequência 2: Listar Contatos
            ["2"], // Escolhe '2. Listar Contatos'

            // Sequência 3: Buscar Contatos
            ["3"], // Escolhe '3. Buscar Contato'
            ["Silva"], // Termo de busca

            // Sequência 4: Buscar Contatos (sem resultados)
            ["3"], // Escolhe '3. Buscar Contato'
            ["Carlos"], // Termo de busca sem resultado

            // Sequência 5: Remover Contato (ID será preenchido dinamicamente)
            ["4"], // Escolhe '4. Remover Contato'
            ["<ID_JOAO>"], // Placeholder para o ID do João

            // Sequência 6: Listar após remoção
            ["2"], // Escolhe '2. Listar Contatos'

            // Sequência 7: Sair
            ["5"] // Escolhe '5. Sair'
        ];

        public function GerenciadorContatosApp() {
            super();
            contatos = new Array();
            trace("=== Gerenciador de Contatos (ActionScript) ===");
            trace("Simulando interação do usuário...");

            // Inicia o processo do menu após um pequeno atraso para melhor visualização.
            // Em uma app real, isso seria disparado por eventos de input (teclado/botão).
            addEventListener(Event.ENTER_FRAME, onEnterFrameHandler);
        }

        /**
         * Handler para o evento ENTER_FRAME, simula um loop de aplicação.
         */
        private function onEnterFrameHandler(event:Event):void {
            removeEventListener(Event.ENTER_FRAME, onEnterFrameHandler); // Roda uma vez por "frame"
            showMenu();
        }

        /**
         * Exibe o menu principal e processa a "entrada" do usuário.
         */
        private function showMenu():void {
            trace("\n--- MENU ---");
            trace("1. Adicionar Contato");
            trace("2. Listar Contatos");
            trace("3. Buscar Contato");
            trace("4. Remover Contato");
            trace("5. Sair");
            trace("------------");

            // Simula a escolha do usuário
            var choice:String = getNextSimulatedInput();
            trace("Simulando escolha: " + choice);

            switch (choice) {
                case "1":
                    _currentAction = "adicionar";
                    processarAdicionarContato();
                    break;
                case "2":
                    _currentAction = "listar";
                    listarContatos();
                    break;
                case "3":
                    _currentAction = "buscar";
                    processarBuscarContato();
                    break;
                case "4":
                    _currentAction = "remover";
                    processarRemoverContato();
                    break;
                case "5":
                    trace("\nSaindo do gerenciador de contatos. Até mais, Mikael_Programador!");
                    break;
                default:
                    trace("Opção inválida. Por favor, tente novamente.");
                    showMenu(); // Mostra o menu novamente
            }
        }

        /**
         * Obtém a próxima entrada simulada da fila.
         */
        private function getNextSimulatedInput():String {
            if (_simulatedInputIndex < _simulatedInputs.length) {
                var input:Object = _simulatedInputs[_simulatedInputIndex];
                _simulatedInputIndex++;
                if (input is Array) {
                    // Se for um array, é uma sequência de campos para uma única operação
                    return input[0]; // Retorna a primeira parte (que é a escolha do menu)
                }
                return input.toString();
            }
            return ""; // Fim das entradas simuladas
        }

        /**
         * Processa a adição de um novo contato, usando entradas simuladas.
         */
        private function processarAdicionarContato():void {
            // Pega os dados simulados para a adição
            var dadosContato:Array = _simulatedInputs[_simulatedInputIndex - 1] as Array; // O array que contem os dados
            var nome:String = dadosContato[0];
            var telefone:String = dadosContato[1];
            var email:String = dadosContato[2];

            try {
                var novoContato:Contato = new Contato(nome, telefone, email);
                adicionarContato(novoContato);
            } catch (e:ArgumentError) {
                trace("Erro ao adicionar contato: " + e.message);
            } finally {
                // Continua para a próxima ação ou exibe o menu
                delayAndShowMenu();
            }
        }

        /**
         * Adiciona um novo contato à lista.
         * @param contato O objeto Contato a ser adicionado.
         * @return O contato adicionado ou null se já existir.
         */
        private function adicionarContato(contato:Contato):Contato {
            var contatoExistente:Contato = encontrarContatoPorId(contato.id);
            if (contatoExistente != null) {
                trace("Aviso: Contato com ID " + contato.id + " já existe e não será adicionado novamente.");
                return null;
            }
            contatos.push(contato);
            trace("SUCESSO: Contato '" + contato.nome + "' adicionado ao gerenciador.");
            return contato;
        }

        /**
         * Lista todos os contatos.
         */
        private function listarContatos():void {
            trace("\n--- Seus Contatos ---");
            if (contatos.length == 0) {
                trace("Nenhum contato cadastrado ainda.");
            } else {
                for (var i:int = 0; i < contatos.length; i++) {
                    trace(contatos[i].toString());
                }
            }
            trace("--------------------");
            delayAndShowMenu();
        }

        /**
         * Processa a busca de um contato, usando entrada simulada.
         */
        private function processarBuscarContato():void {
            var termoBusca:String = getNextSimulatedInput();
            trace("Simulando busca por: " + termoBusca);

            var resultados:Array = buscarContatos(termoBusca);
            if (resultados.length == 0) {
                trace("Nenhum contato encontrado com o termo: \"" + termoBusca + "\"");
            } else {
                trace("--- Resultados da Busca para \"" + termoBusca + "\" ---");
                for each (var contato:Contato in resultados) {
                    trace(contato.toString());
                }
            }
            trace("---------------------------------------");
            delayAndShowMenu();
        }

        /**
         * Busca contatos pelo nome ou telefone.
         * @param termoBusca Termo a ser procurado.
         * @return Um Array de contatos correspondentes.
         */
        private function buscarContatos(termoBusca:String):Array {
            var resultados:Array = new Array();
            var termoLower:String = termoBusca.toLowerCase();
            for each (var contato:Contato in contatos) {
                if (contato.nome.toLowerCase().indexOf(termoLower) != -1 ||
                    contato.telefone.indexOf(termoBusca) != -1) {
                    resultados.push(contato);
                }
            }
            return resultados;
        }

        /**
         * Processa a remoção de um contato, usando entrada simulada.
         */
        private function processarRemoverContato():void {
            var idOuPrefixo:String = getNextSimulatedInput();

            // Substitui o placeholder pelo ID real do João, se for o caso
            if (idOuPrefixo == "<ID_JOAO>") {
                var joao:Contato = null;
                for each (var c:Contato in contatos) {
                    if (c.nome == "João Silva") {
                        joao = c;
                        break;
                    }
                }
                if (joao != null) {
                    idOuPrefixo = joao.id;
                    trace("DEBUG: Substituindo <ID_JOAO> por ID real: " + joao.id);
                } else {
                    trace("ERRO: Contato 'João Silva' não encontrado para obter ID.");
                    idOuPrefixo = ""; // Torna inválido para não remover nada
                }
            }

            trace("Simulando remoção do contato com ID/prefixo: " + idOuPrefixo);
            var contatoRemovido:Contato = removerContato(idOuPrefixo);
            if (contatoRemovido == null) {
                trace("FALHA: Contato com ID/prefixo '" + idOuPrefixo + "' não foi removido.");
            }
            delayAndShowMenu();
        }

        /**
         * Remove um contato pelo ID ou prefixo do ID.
         * @param idOuPrefixo O ID completo ou prefixo do ID do contato.
         * @return O contato removido ou null se não encontrado.
         */
        private function removerContato(idOuPrefixo:String):Contato {
            var contatoRemovido:Contato = null;
            for (var i:int = 0; i < contatos.length; i++) {
                if (contatos[i].id == idOuPrefixo || contatos[i].id.indexOf(idOuPrefixo) == 0) {
                    contatoRemovido = contatos[i];
                    contatos.splice(i, 1);
                    trace("SUCESSO: Contato '" + contatoRemovido.nome + "' removido.");
                    return contatoRemovido;
                }
            }
            return null;
        }

        /**
         * Encontra um contato pelo ID.
         * @param idContato O ID do contato.
         * @return O objeto Contato ou null.
         */
        private function encontrarContatoPorId(idContato:String):Contato {
            for each (var contato:Contato in contatos) {
                if (contato.id == idContato) {
                    return contato;
                }
            }
            return null;
        }

        /**
         * Adiciona um pequeno atraso antes de exibir o próximo menu.
         * Útil para simular tempo de processamento ou UX em apps reais.
         */
        private function delayAndShowMenu():void {
            // Este é um truque para simular a assincronicidade ou espera por input.
            // Em apps reais, você usaria botões, campos de texto e ouvintes de eventos.
            // Para este exemplo de console, simplesmente chama o próximo passo.
            if (_simulatedInputIndex < _simulatedInputs.length) {
                addEventListener(Event.ENTER_FRAME, onNextStep);
            }
        }

        private function onNextStep(event:Event):void {
            removeEventListener(Event.ENTER_FRAME, onNextStep);
            showMenu(); // Volta para o menu para a próxima iteração simulada
        }
    }
}
