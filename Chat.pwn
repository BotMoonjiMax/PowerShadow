#include <a_samp> // Inclui as funções básicas do SA-MP
#include <dini>   // Inclui a biblioteca DINI para trabalhar com arquivos .ini

// --- Constantes e Variáveis Globais ---
#define MAX_SENHA_LEN 32  // Tamanho máximo da senha
#define MAX_NOME_LEN 24   // Tamanho máximo do nome do jogador (SA-MP default)
#define COR_INFO 0x00FF00FF // Cor verde para mensagens de informação
#define COR_ERRO 0xFF0000FF // Cor vermelha para mensagens de erro

enum E_PLAYER_DATA // Enumeração para organizar os dados do jogador
{
    pLogado,          // 0 = Não logado, 1 = Logado
    String:pSenha[MAX_SENHA_LEN + 1] // Senha do jogador
};
new PlayerData[MAX_PLAYERS][E_PLAYER_DATA]; // Array para armazenar os dados de cada jogador

// --- Protótipos de Funções Personalizadas ---
forward CarregarConta(playerid);
forward SalvarConta(playerid);

// --- Callbacks Essenciais do SA-MP ---

public OnGameModeInit()
{
    print("\n------------------------------------------");
    print(" Sistema de Registro e Login em PAWN");
    print(" Desenvolvido por Mikael_Programador (Paraíba, PB)");
    print("------------------------------------------\n");
    return 1;
}

public OnPlayerConnect(playerid)
{
    // Inicializa o status do jogador como não logado
    PlayerData[playerid][pLogado] = 0;
    // Tenta carregar a conta assim que o jogador conecta
    CarregarConta(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Salva a conta do jogador ao desconectar (se ele estiver logado)
    if (PlayerData[playerid][pLogado] == 1)
    {
        SalvarConta(playerid);
    }
    return 1;
}

public OnPlayerSpawn(playerid)
{
    // Verifica se o jogador está logado antes de spawnar
    if (PlayerData[playerid][pLogado] == 0)
    {
        SendClientMessage(playerid, COR_INFO, "Você precisa se registrar ou logar para jogar!");
        // Congela o jogador ou o mantém em uma posição inicial para forçar o login
        SetPlayerPos(playerid, 0.0, 0.0, 500.0); // Exemplo: move para uma posição alta
        TogglePlayerControllable(playerid, 0);   // Impede o controle do jogador
    } else {
        // Se estiver logado, permite que o jogador controle seu personagem
        TogglePlayerControllable(playerid, 1);
    }
    return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
    // Permite que o jogador selecione a classe, mas ainda precisará logar/registrar
    return 1;
}

public OnPlayerText(playerid, text[])
{
    // Impede que jogadores não logados usem o chat
    if (PlayerData[playerid][pLogado] == 0)
    {
        SendClientMessage(playerid, COR_ERRO, "ERRO: Você precisa se logar ou registrar para usar o chat!");
        return 0; // Retorna 0 para bloquear a mensagem no chat
    }
    return 1; // Permite a mensagem
}

// --- Comandos de Chat (Callbacks de Comando) ---

CMD:registrar(playerid, params[])
{
    new playerName[MAX_NOME_LEN];
    GetPlayerName(playerid, playerName, sizeof(playerName));

    new password[MAX_SENHA_LEN];

    // Verifica se o jogador já possui uma conta no sistema
    if(dini_Exists(playerName))
    {
        SendClientMessage(playerid, COR_ERRO, "ERRO: Você já possui uma conta registrada. Use /login.");
        return 1;
    }

    // Verifica se a senha foi fornecida
    if(sscanf(params, "s", password))
    {
        SendClientMessage(playerid, COR_ERRO, "USO: /registrar [sua_senha]");
        SendClientMessage(playerid, COR_INFO, "A senha deve ter no máximo 32 caracteres.");
        return 1;
    }

    // Valida o tamanho da senha
    if(strlen(password) > MAX_SENHA_LEN)
    {
        SendClientMessage(playerid, COR_ERRO, "ERRO: Sua senha excede o limite de caracteres.");
        return 1;
    }

    // Salva a senha no arquivo do jogador
    dini_Set(playerName, "Senha", password);
    dini_IntSet(playerName, "Registrado", 1); // Marca como registrado
    
    // Armazena a senha na PlayerData e marca como logado
    strmid(PlayerData[playerid][pSenha], password, 0, strlen(password), MAX_SENHA_LEN);
    PlayerData[playerid][pLogado] = 1;

    SendClientMessage(playerid, COR_INFO, "Você foi registrado e logado com sucesso!");
    TogglePlayerControllable(playerid, 1); // Permite controle após o registro/login
    SpawnPlayer(playerid); // Força o spawn do jogador no jogo
    return 1;
}

CMD:login(playerid, params[])
{
    new playerName[MAX_NOME_LEN];
    GetPlayerName(playerid, playerName, sizeof(playerName));

    new password[MAX_SENHA_LEN];

    // Verifica se o jogador já está logado
    if (PlayerData[playerid][pLogado] == 1)
    {
        SendClientMessage(playerid, COR_ERRO, "ERRO: Você já está logado!");
        return 1;
    }

    // Verifica se o jogador possui uma conta registrada
    if(!dini_Exists(playerName))
    {
        SendClientMessage(playerid, COR_ERRO, "ERRO: Você não possui uma conta registrada. Use /registrar.");
        return 1;
    }

    // Verifica se a senha foi fornecida
    if(sscanf(params, "s", password))
    {
        SendClientMessage(playerid, COR_ERRO, "USO: /login [sua_senha]");
        return 1;
    }

    // Obtém a senha armazenada no arquivo
    new storedPassword[MAX_SENHA_LEN];
    dini_Get(playerName, "Senha", storedPassword);

    // Compara as senhas
    if(strcmp(password, storedPassword, false) == 0) // 'false' para case-sensitive
    {
        // Senha correta, loga o jogador
        strmid(PlayerData[playerid][pSenha], password, 0, strlen(password), MAX_SENHA_LEN);
        PlayerData[playerid][pLogado] = 1;
        SendClientMessage(playerid, COR_INFO, "Você logou com sucesso!");
        TogglePlayerControllable(playerid, 1); // Permite controle após o registro/login
        SpawnPlayer(playerid); // Força o spawn do jogador no jogo
    }
    else
    {
        // Senha incorreta
        SendClientMessage(playerid, COR_ERRO, "ERRO: Senha incorreta.");
    }
    return 1;
}

CMD:sair(playerid, params[])
{
    if (PlayerData[playerid][pLogado] == 1)
    {
        SalvarConta(playerid); // Garante que os dados sejam salvos
        PlayerData[playerid][pLogado] = 0; // Desloga o jogador
        SendClientMessage(playerid, COR_INFO, "Você foi deslogado com sucesso!");
        Kick(playerid); // Ou você pode apenas congelar/teletransportar para a área de login
    } else {
        SendClientMessage(playerid, COR_ERRO, "ERRO: Você não está logado para deslogar.");
    }
    return 1;
}

// --- Funções Auxiliares (Não Callbacks) ---

CarregarConta(playerid)
{
    new playerName[MAX_NOME_LEN];
    GetPlayerName(playerid, playerName, sizeof(playerName));

    // Verifica se o arquivo de conta existe para o jogador
    if(dini_Exists(playerName))
    {
        SendClientMessage(playerid, COR_INFO, "Bem-vindo de volta! Por favor, use /login [sua_senha]");
        // Não carrega a senha para a memória até o login, por segurança
    }
    else
    {
        SendClientMessage(playerid, COR_INFO, "Bem-vindo ao servidor! Use /registrar [sua_senha] para criar uma conta.");
    }
    return 1;
}

SalvarConta(playerid)
{
    new playerName[MAX_NOME_LEN];
    GetPlayerName(playerid, playerName, sizeof(playerName));

    // Aqui você salvaria outros dados do jogador (posição, dinheiro, etc.)
    // Por enquanto, apenas confirmamos o salvamento
    SendClientMessage(playerid, COR_INFO, "Seus dados foram salvos com sucesso.");
    return 1;
}
