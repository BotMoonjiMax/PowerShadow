#!/bin/sh

LOG_FILE="tarefas.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# Função para criar o arquivo de log se não existir
create_log_file() {
    if [ ! -f "$LOG_FILE" ]; then
        touch "$LOG_FILE"
        echo "[$DATE] - Arquivo de log '$LOG_FILE' criado."
    fi
}

# Função para adicionar uma tarefa
add_task() {
    echo "Qual tarefa você quer adicionar?"
    read TASK_DESCRIPTION
    echo "[$DATE] - ADICIONAR: $TASK_DESCRIPTION" >> "$LOG_FILE"
    echo "Tarefa adicionada: '$TASK_DESCRIPTION'"
}

# Função para listar todas as tarefas
list_tasks() {
    echo "--- Suas Tarefas ---"
    if [ -s "$LOG_FILE" ]; then # -s verifica se o arquivo não está vazio
        cat "$LOG_FILE"
    else
        echo "Nenhuma tarefa registrada ainda."
    fi
    echo "--------------------"
}

# Função para limpar o arquivo de log
clear_log() {
    echo "Tem certeza que deseja limpar todas as tarefas? (s/n)"
    read CONFIRMATION
    if [ "$CONFIRMATION" = "s" ]; then
        > "$LOG_FILE" # Limpa o conteúdo do arquivo
        echo "[$DATE] - Log de tarefas limpo." >> "$LOG_FILE" # Adiciona uma entrada de limpeza
        echo "Log de tarefas limpo com sucesso!"
    else
        echo "Operação cancelada."
    fi
}

# Função principal do menu
main_menu() {
    create_log_file
    while true; do
        echo ""
        echo "--- Gerenciador de Tarefas Simples ---"
        echo "1. Adicionar Tarefa"
        echo "2. Listar Tarefas"
        echo "3. Limpar Log de Tarefas"
        echo "4. Sair"
        echo "-------------------------------------"
        echo "Escolha uma opção:"
        read CHOICE

        case $CHOICE in
            1) add_task ;;
            2) list_tasks ;;
            3) clear_log ;;
            4) echo "Saindo do gerenciador de tarefas. Até mais!"; exit 0 ;;
            *) echo "Opção inválida. Por favor, tente novamente." ;;
        esac
    done
}

# Inicia o menu
main_menu
