# Define o caminho base para a operação, pode ser alterado
$BasePath = "C:\Users\Public\MeusArquivos" # Altere para um caminho adequado no seu sistema!

# Função para garantir que o caminho base existe
function Ensure-BasePath {
    param (
        [string]$Path = $BasePath
    )
    if (-not (Test-Path -Path $Path)) {
        New-Item -ItemType Directory -Path $Path -Force
        Write-Host "Diretório '$Path' criado." -ForegroundColor Green
    } else {
        Write-Host "Diretório '$Path' já existe." -ForegroundColor Green
    }
}

# Função para listar o conteúdo de um diretório
function List-DirectoryContent {
    param (
        [string]$TargetDirectory = $BasePath
    )
    if (-not (Test-Path -Path $TargetDirectory)) {
        Write-Warning "O diretório '$TargetDirectory' não existe."
        return
    }
    Write-Host "`n--- Conteúdo de '$TargetDirectory' ---" -ForegroundColor Cyan
    Get-ChildItem -Path $TargetDirectory | Format-Table Name, LastWriteTime, Length
    Write-Host "-------------------------------------`n" -ForegroundColor Cyan
}

# Função para criar um novo diretório
function Create-NewDirectory {
    param (
        [string]$ParentDirectory = $BasePath
    )
    Write-Host "Digite o nome do novo diretório a ser criado em '$ParentDirectory':"
    $NewDirName = Read-Host

    if ([string]::IsNullOrWhiteSpace($NewDirName)) {
        Write-Warning "Nome do diretório não pode ser vazio."
        return
    }

    $NewDirPath = Join-Path -Path $ParentDirectory -ChildPath $NewDirName
    try {
        New-Item -ItemType Directory -Path $NewDirPath -Force | Out-Null
        Write-Host "Diretório '$NewDirPath' criado com sucesso!" -ForegroundColor Green
    } catch {
        Write-Error "Erro ao criar o diretório: $($_.Exception.Message)"
    }
}

# Função para mover um arquivo
function Move-FileInteractive {
    param (
        [string]$SourceDirectory = $BasePath
    )
    Write-Host "--- Mover Arquivo ---"
    List-DirectoryContent -TargetDirectory $SourceDirectory
    Write-Host "Digite o nome do arquivo que você quer mover (de '$SourceDirectory'):"
    $FileName = Read-Host

    if ([string]::IsNullOrWhiteSpace($FileName)) {
        Write-Warning "Nome do arquivo não pode ser vazio."
        return
    }

    $SourceFilePath = Join-Path -Path $SourceDirectory -ChildPath $FileName
    if (-not (Test-Path -Path $SourceFilePath -PathType Leaf)) { # PathType Leaf verifica se é um arquivo
        Write-Warning "Arquivo '$SourceFilePath' não encontrado."
        return
    }

    Write-Host "Digite o caminho completo do destino (ex: 'C:\PastaDestino' ou '.\NovaPasta'):"
    $DestinationPath = Read-Host

    if ([string]::IsNullOrWhiteSpace($DestinationPath)) {
        Write-Warning "Caminho de destino não pode ser vazio."
        return
    }

    # Se o destino for um nome de pasta relativa, une com o BasePath
    if ($DestinationPath -notmatch "^([a-zA-Z]:\\|\\\\).*") { # Não começa com letra de drive ou \\
        $DestinationPath = Join-Path -Path $SourceDirectory -ChildPath $DestinationPath
    }

    try {
        Move-Item -Path $SourceFilePath -Destination $DestinationPath -Force -PassThru
        Write-Host "Arquivo '$FileName' movido para '$DestinationPath' com sucesso!" -ForegroundColor Green
    } catch {
        Write-Error "Erro ao mover o arquivo: $($_.Exception.Message)"
    }
}

# Menu principal do PowerShell
function Show-MainMenu {
    Ensure-BasePath # Garante que o diretório base exista ao iniciar
    while ($true) {
        Write-Host "`n--- Gerenciador de Arquivos Simples (PowerShell) ---" -ForegroundColor Yellow
        Write-Host "Caminho Base: $BasePath" -ForegroundColor Yellow
        Write-Host "1. Listar Conteúdo do Diretório Base"
        Write-Host "2. Criar Novo Diretório"
        Write-Host "3. Mover Arquivo"
        Write-Host "4. Alterar Caminho Base (Avançado)"
        Write-Host "5. Sair"
        Write-Host "----------------------------------------------------" -ForegroundColor Yellow
        Write-Host "Escolha uma opção:"
        $Choice = Read-Host

        switch ($Choice) {
            "1" { List-DirectoryContent }
            "2" { Create-NewDirectory }
            "3" { Move-FileInteractive }
            "4" {
                Write-Host "Digite o novo caminho base:"
                $NewBasePath = Read-Host
                if (-not ([string]::IsNullOrWhiteSpace($NewBasePath))) {
                    $global:BasePath = $NewBasePath # Usa $global para alterar a variável fora da função
                    Ensure-BasePath
                    Write-Host "Caminho base alterado para '$global:BasePath'" -ForegroundColor Green
                } else {
                    Write-Warning "Caminho base não pode ser vazio."
                }
            }
            "5" { Write-Host "Saindo do gerenciador de arquivos. Tchau!"; return }
            default { Write-Warning "Opção inválida. Por favor, tente novamente." }
        }
    }
}

# Inicia o menu
Show-MainMenu
