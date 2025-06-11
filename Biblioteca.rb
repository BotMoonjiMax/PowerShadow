# frozen_string_literal: true

# Classe que representa um livro individual na biblioteca.
class Livro
  attr_reader :id, :titulo, :autor, :ano_publicacao

  # Construtor da classe Livro.
  # @param titulo [String] O título do livro.
  # @param autor [String] O autor do livro.
  # @param ano_publicacao [Integer] O ano de publicação do livro.
  def initialize(titulo, autor, ano_publicacao)
    raise ArgumentError, 'Título, autor e ano de publicação são obrigatórios.' if titulo.to_s.empty? || autor.to_s.empty? || ano_publicacao.nil?

    @id = generate_unique_id # Gera um ID único para cada livro
    @titulo = titulo
    @autor = autor
    @ano_publicacao = ano_publicacao
    puts "Livro '#{@titulo}' criado com ID: #{@id}"
  end

  # Exibe os detalhes do livro no console.
  def exibir_detalhes
    puts "ID: #{@id}"
    puts "  Título: #{@titulo}"
    puts "  Autor: #{@autor}"
    puts "  Ano: #{@ano_publicacao}"
    puts '---'
  end

  private

  # Gera um ID único simples baseado no tempo e um número aleatório.
  # Em uma aplicação real, usaria algo mais robusto como UUIDs ou IDs de banco de dados.
  def generate_unique_id
    "livro-#{Time.now.to_i}-#{rand(1000)}"
  end
end

# Classe que gerencia a coleção de livros.
class GerenciadorDeBiblioteca
  attr_reader :livros

  def initialize
    @livros = [] # Array para armazenar os objetos Livro
    puts 'Gerenciador de Biblioteca iniciado!'
  end

  # Adiciona um novo livro à biblioteca.
  # @param livro [Livro] O objeto Livro a ser adicionado.
  def adicionar_livro(livro)
    # Verifica se o ID já existe (improvável com o método generate_unique_id, mas boa prática)
    if @livros.any? { |l| l.id == livro.id }
      warn "Aviso: Livro com ID #{livro.id} já existe e não será adicionado novamente."
      return nil
    end

    @livros << livro # Adiciona o livro ao array
    puts "Livro '#{livro.titulo}' adicionado à biblioteca."
    livro
  end

  # Lista todos os livros na biblioteca.
  def listar_livros
    puts "\n--- Livros na Biblioteca ---"
    if @livros.empty?
      puts 'Sua biblioteca está vazia.'
      return
    end
    @livros.each(&:exibir_detalhes) # Itera sobre cada livro e chama exibir_detalhes
    puts '----------------------------'
  end

  # Busca livros por título ou autor.
  # @param termo_busca [String] O termo a ser procurado.
  # @return [Array<Livro>] Um array de livros que correspondem ao termo.
  def buscar_livros(termo_busca)
    puts "\n--- Buscando livros por '#{termo_busca}' ---"
    resultados = @livros.select do |livro|
      livro.titulo.downcase.include?(termo_busca.downcase) ||
        livro.autor.downcase.include?(termo_busca.downcase)
    end

    if resultados.empty?
      puts "Nenhum livro encontrado com o termo: \"#{termo_busca}\""
    else
      resultados.each(&:exibir_detalhes)
    end
    puts '---------------------------------------'
    resultados
  end

  # Remove um livro da biblioteca pelo seu ID.
  # @param id_livro [String] O ID do livro a ser removido.
  # @return [Livro, nil] O livro removido ou nil se não encontrado.
  def remover_livro(id_livro)
    livro_removido = nil
    @livros.delete_if do |livro|
      if livro.id == id_livro
        livro_removido = livro
        true # Remove o livro
      else
        false
      end
    end

    if livro_removido
      puts "Livro '#{livro_removido.titulo}' (ID: #{id_livro}) removido da biblioteca."
      livro_removido
    else
      warn "Aviso: Livro com ID #{id_livro} não encontrado para remoção."
      nil
    end
  end
end

# --- Exemplo de Uso (Código para executar o gerenciador) ---

puts "\n--- Iniciando o Gerenciador de Biblioteca em Ruby ---"

minha_biblioteca = GerenciadorDeBiblioteca.new

begin
  # 1. Adicionar livros
  livro1 = Livro.new('O Pequeno Príncipe', 'Antoine de Saint-Exupéry', 1943)
  minha_biblioteca.adicionar_livro(livro1)

  livro2 = Livro.new('Dom Quixote', 'Miguel de Cervantes', 1605)
  minha_biblioteca.adicionar_livro(livro2)

  minha_biblioteca.adicionar_livro(Livro.new('Clean Code', 'Robert C. Martin', 2008))
  minha_biblioteca.adicionar_livro(Livro.new('Refactoring', 'Martin Fowler', 1999))

  # 2. Listar todos os livros
  minha_biblioteca.listar_livros

  # 3. Buscar livros
  minha_biblioteca.buscar_livros('Cervantes')
  minha_biblioteca.buscar_livros('code') # Busca parcial e case-insensitive
  minha_biblioteca.buscar_livros('Senhor dos Anéis') # Não existe

  # 4. Remover um livro
  if livro1
    minha_biblioteca.remover_livro(livro1.id)
  end

  # 5. Listar livros após remoção
  minha_biblioteca.listar_livros

  # Exemplo de tentativa de adicionar livro inválido
  # minha_biblioteca.adicionar_livro(Livro.new('', 'Autor Inválido', 2000))

rescue ArgumentError => e
  puts "Erro ao criar livro: #{e.message}"
rescue StandardError => e
  puts "Ocorreu um erro inesperado: #{e.message}"
end

puts "\n--- Fim da demonstração do Gerenciador de Biblioteca ---"
