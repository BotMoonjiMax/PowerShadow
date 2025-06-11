import uuid # Módulo para gerar IDs únicos (UUIDs)
import datetime # Módulo para trabalhar com datas e horas

# --- Classe Tarefa ---
class Tarefa:
    """
    Representa uma única tarefa na lista de afazeres.
    """
    def __init__(self, descricao, prioridade="média"):
        if not descricao:
            raise ValueError("A descrição da tarefa não pode ser vazia.")
        self.id = str(uuid.uuid4()) # Gera um ID único universal (UUID)
        self.descricao = descricao
        self.prioridade = prioridade.lower() # Garante que a prioridade seja minúscula
        self.concluida = False # Tarefa começa como não concluída
        self.data_criacao = datetime.datetime.now() # Data e hora da criação

    def marcar_como_concluida(self):
        """Marca a tarefa como concluída."""
        self.concluida = True
        print(f"Tarefa '{self.descricao}' marcada como concluída.")

    def __str__(self):
        """
        Retorna uma representação em string da tarefa para exibição.
        """
        status = "✅ Concluída" if self.concluida else "⏳ Pendente"
        data_formatada = self.data_criacao.strftime("%d/%m/%Y %H:%M")
        return (f"ID: {self.id[:8]}...\n" # Exibe os primeiros 8 caracteres do ID
                f"  Descrição: {self.descricao}\n"
                f"  Prioridade: {self.prioridade.capitalize()}\n" # Capitaliza a primeira letra
                f"  Status: {status}\n"
                f"  Criada em: {data_formatada}\n"
                f"---")

# --- Classe GerenciadorDeTarefas ---
class GerenciadorDeTarefas:
    """
    Gerencia a coleção de tarefas.
    """
    def __init__(self):
        self.tarefas = [] # Lista para armazenar objetos Tarefa
        print("Gerenciador de Tarefas iniciado!")

    def adicionar_tarefa(self, descricao, prioridade="média"):
        """
        Adiciona uma nova tarefa à lista.
        """
        try:
            nova_tarefa = Tarefa(descricao, prioridade)
            self.tarefas.append(nova_tarefa)
            print(f"Tarefa '{descricao}' adicionada com sucesso! (ID: {nova_tarefa.id[:8]}...)")
            return nova_tarefa
        except ValueError as e:
            print(f"Erro ao adicionar tarefa: {e}")
            return None

    def listar_tarefas(self, mostrar_concluidas=True):
        """
        Lista todas as tarefas existentes, opcionalmente filtrando por concluídas.
        """
        print("\n--- Suas Tarefas ---")
        if not self.tarefas:
            print("Nenhuma tarefa cadastrada ainda.")
            print("--------------------")
            return

        tarefas_para_mostrar = self.tarefas
        if not mostrar_concluidas:
            tarefas_para_mostrar = [t for t in self.tarefas if not t.concluida]

        if not tarefas_para_mostrar:
            print("Nenhuma tarefa pendente para mostrar.")
            print("--------------------")
            return

        for tarefa in tarefas_para_mostrar:
            print(tarefa)
        print("--------------------")

    def encontrar_tarefa_por_id(self, id_tarefa):
        """
        Encontra uma tarefa pelo seu ID.
        """
        for tarefa in self.tarefas:
            # Compara o ID completo, mas permite entrada parcial para conveniência
            if tarefa.id == id_tarefa or tarefa.id.startswith(id_tarefa):
                return tarefa
        return None

    def marcar_tarefa_concluida(self, id_tarefa):
        """
        Marca uma tarefa como concluída usando seu ID.
        """
        tarefa = self.encontrar_tarefa_por_id(id_tarefa)
        if tarefa:
            if not tarefa.concluida:
                tarefa.marcar_como_concluida()
                return True
            else:
                print(f"Tarefa '{tarefa.descricao}' já está marcada como concluída.")
                return False
        else:
            print(f"Tarefa com ID ou prefixo '{id_tarefa}' não encontrada.")
            return False

    def remover_tarefa(self, id_tarefa):
        """
        Remove uma tarefa da lista usando seu ID.
        """
        tarefa_a_remover = self.encontrar_tarefa_por_id(id_tarefa)
        if tarefa_a_remover:
            self.tarefas.remove(tarefa_a_remover)
            print(f"Tarefa '{tarefa_a_remover.descricao}' removida com sucesso.")
            return True
        else:
            print(f"Tarefa com ID ou prefixo '{id_tarefa}' não encontrada para remoção.")
            return False

# --- Função Principal do Menu Interativo ---
def main_menu():
    """
    Exibe um menu interativo para o gerenciador de tarefas.
    """
    gerenciador = GerenciadorDeTarefas()

    while True:
        print("\n===== MENU DO GERENCIADOR DE TAREFAS =====")
        print("1. Adicionar Tarefa")
        print("2. Listar Todas as Tarefas")
        print("3. Listar Tarefas Pendentes")
        print("4. Marcar Tarefa como Concluída")
        print("5. Remover Tarefa")
        print("6. Sair")
        print("==========================================")

        escolha = input("Digite sua opção: ")

        if escolha == '1':
            descricao = input("Descrição da tarefa: ")
            prioridade = input("Prioridade (baixa, média, alta - padrão: média): ") or "média"
            gerenciador.adicionar_tarefa(descricao, prioridade)
        elif escolha == '2':
            gerenciador.listar_tarefas(mostrar_concluidas=True)
        elif escolha == '3':
            gerenciador.listar_tarefas(mostrar_concluidas=False)
        elif escolha == '4':
            id_para_marcar = input("Digite o ID (ou prefixo do ID) da tarefa a marcar como concluída: ")
            gerenciador.marcar_tarefa_concluida(id_para_marcar)
        elif escolha == '5':
            id_para_remover = input("Digite o ID (ou prefixo do ID) da tarefa a remover: ")
            gerenciador.remover_tarefa(id_para_remover)
        elif escolha == '6':
            print("Saindo do gerenciador de tarefas. Até mais, Mikael_Programador!")
            break
        else:
            print("Opção inválida. Por favor, tente novamente.")

# --- Execução do Menu Principal ---
if __name__ == "__main__":
    main_menu()
