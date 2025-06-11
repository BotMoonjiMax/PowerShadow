<?php
// Verifica se o formulário foi enviado
if ($_SERVER["REQUEST_METHOD"] == "POST") {
  $username = $_POST["username"];
  $password = $_POST["password"];

  // Simula um banco de dados com usuários cadastrados
  $usuarios = array(
    "admin" => "123456",
    "user" => "password"
  );

  // Verifica se o usuário está cadastrado
  if (array_key_exists($username, $usuarios) && $usuarios[$username] == $password) {
    echo "Bem-vindo, $username!";
  } else {
    echo "Usuário ou senha inválidos.";
  }
}
?>

<!DOCTYPE html>
<html lang="pt-BR">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Login</title>
  <style>
    body {
      font-family: Arial, sans-serif;
    }
  </style>
</head>
<body>
  <header>
    <h1>Login</h1>
  </header>
  <main>
    <form method="post">
      <label for="username">Usuário:</label>
      <input type="text" id="username" name="username" required><br><br>
      <label for="password">Senha:</label>
      <input type="password" id="password" name="password" required><br><br>
      <input type="submit" value="Entrar">
    </form>
  </main>
</body>
</html>
