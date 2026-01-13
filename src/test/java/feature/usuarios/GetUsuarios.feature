Feature: Endpoints Account e BookStore - Book Store API

  Background:
    * configure headers = { 'Content-Type': 'application/json' }
    * url 'https://bookstore.demoqa.com'
    * def randomUsername = function() {return 'user_' + new Date().getTime() + '_' + Math.floor(Math.random() * 10000);}
    * def username = randomUsername()
    * def password = 'Teste@123'

    # (POST SUCESSO) 1
  Scenario: Adicionar usuário e gerar token com sucesso
    # Primeiro: Criar o usuário
    Given path '/Account/v1/User'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 201
    And match response.username == '#(username)'
    And def userId = response.userID

    # Segundo: Gerar token com o mesmo usuário
    Given path '/Account/v1/GenerateToken'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 200
    And match response.status == 'Success'
    And match response.result == 'User authorized successfully.'
    And def authToken = response.token

    # (GET SUCESSO) 2
  Scenario: Listar todos os livros disponíveis com sucesso
    Given path '/BookStore/v1/Books'
    When method Get
    Then status 200

    # (GET SUCESSO) 3
  Scenario: Buscar livro específico por ISBN cadastrado com sucesso
    Given path '/BookStore/v1/Book'
    And param ISBN = '9781449325862'
    When method Get
    Then status 200

    # (GET FALHA - ISBN inexistente) 4
  Scenario: Buscar livro com ISBN inexistente (deve falhar)
    Given path '/BookStore/v1/Book'
    And param ISBN = '9999999999999'
    When method Get
    Then status 400
    And match response.code == '1205'
    And match response.message == 'O ISBN fornecido não está disponível na Coleção de Livros!'

    # (GET SUCESSO) 5
  Scenario: Buscar livro validando todos os campos solicitados
    Given path '/BookStore/v1/Book'
    And param ISBN = '9781449325862'
    When method Get
    Then status 200
    And match response.title == 'Git Pocket Guide'
    And match response.author == 'Richard E. Silverman'

    # (GET FALHA - título inexistente) 6
  Scenario: Validar falha ao buscar autor existente e título do livro inexistente
    Given path '/BookStore/v1/Book'
    And param ISBN = '9781449325862'
    When method Get
    Then status 200
    And match response.title == 'Romeu e Julieta'
    And match response.author == 'Richard E. Silverman'

    # (GET SUCESSO) 7
  Scenario: Buscar livros se todos estiverem disponíveis na coleção
    Given path '/BookStore/v1/Books'
    When method Get
    Then status 200
    And match response.books[*].title contains ['Git Pocket Guide', 'Speaking JavaScript']

    # (GET FALHA - Ao menos um livro inexistente na coleção) 8
  Scenario: Buscar livro inexistente na coleção (deve falhar)
    Given path '/BookStore/v1/Books'
    When method Get
    Then status 200
    And match response.books[*].title contains ['Git Pocket Guide', 'Adao e Eva']

    # (POST SUCESSO - Alterar usuário e senha antes de gerar dados) (POST FALHA) 9
  Scenario: Adicionar usuário e validar prevenção de duplicidade
    Given path '/Account/v1/User'
    And request { "userName": "testyUser4859971234", "password": "P@ssw408t49rd1523!9" }
    When method Post
    Then status 201

    # (POST SUCESSO) 10
  Scenario: Gerar token de autenticação com credenciais válidas
    Given path '/Account/v1/GenerateToken'
    And request { "userName": "testUser#123", "password": "P@ssw0rd123!" }
    When method Post
    Then status 200
    And match response.status == 'Success'
    And match response.result == 'User authorized successfully.'

    # (POST FALHA) 11
  Scenario: Validar falha ao tentar adicionar livro sem autenticação
    Given path '/BookStore/v1/Books'
    And request { "userId": "{{userId}}", "collectionOfIsbns": [{ "isbn": "9781449325863" }] }
    When method Post
    Then status 401

    # (PUT SUCESSO) 12
  Scenario: Atualizar código ISBN de livro
    # Pré-requisito: Criar usuário e obter token
    * def username = function() {return 'user_' + new Date().getTime() + '_' + Math.floor(Math.random() * 10000);}
    * def uniqueUsername = username()
    * def password = 'Teste@123'

    # Adicionar usuário
    Given path '/Account/v1/User'
    And request { "userName": "#(uniqueUsername)", "password": "#(password)" }
    When method Post
    Then status 201
    And def userId = response.userID

    # Gerar token de autenticação
    Given path '/Account/v1/GenerateToken'
    And request { "userName": "#(uniqueUsername)", "password": "#(password)" }
    When method Post
    Then status 200
    And match response.status == 'Success'
    And def authToken = response.token

    # Adicionar livro à coleção (pré-requisito para substituição)
    Given path '/BookStore/v1/Books'
    And header Authorization = 'Bearer ' + authToken
    And request { "userId": "#(userId)", "collectionOfIsbns": [{ "isbn": "9781593277574" }] }
    When method Post
    Then status 201

    # Substituir ISBN
    Given path '/BookStore/v1/Books/9781593277574'
    And header Authorization = 'Bearer ' + authToken
    And request { "userId": "#(userId)", "isbn": "9781449331818" }
    When method Put
    Then status 200
    And match response.books[0].isbn == '9781449331818'
    And print 'ISBN substituído: 9781593277574 -> 9781449331818'

    # Remover
    Given path '/BookStore/v1/Book'
    And header Authorization = 'Bearer ' + authToken
    And request { "isbn": "9781449331818", "userId": "#(userId)" }
    When method Delete
    Then status 204

    # (PUT FALHA) 13
  Scenario: Tentar atualizar livro sem token de autenticação (deve falhar)
    Given path '/BookStore/v1/Books/9781449325862'
    And header Authorization = 'Bearer {{token}}'
    And request { "isbn": "9781449325862" }
    When method Put
    Then status 401
    And match response.code == '1200'
    And match response.message contains 'User not authorized'

    # (DELETE SUCESSO) 14
  Scenario: Remover livro com sucesso
    Given path '/BookStore/v1/Book'
    And request { "isbn": "9781449325862", "userId": "{{userId}}" }
    When method Delete
    Then status 401

    # (POST SUCESSO) 15
  Scenario: Adicionar usuário, gerar token e deletar conta com sucesso
    # Primeiro: Criar o usuário
    Given path '/Account/v1/User'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 201
    And match response.username == '#(username)'
    And def userId = response.userID
    * print 'Usuário criado com sucesso: ' + username + ' (ID: ' + userId + ')'

    # Guardar as credenciais do usuário criado
    * def storedUser = { username: '#(username)', password: '#(password)', userId: '#(userId)' }

    # Segundo: Gerar token com o mesmo usuário
    Given path '/Account/v1/GenerateToken'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 200
    And match response.status == 'Success'
    And match response.result == 'User authorized successfully.'
    And def authToken = response.token
    * print 'Token gerado com sucesso para o usuário: ' + username
    * storedUser.token = authToken

    # Terceiro: Excluir usuário
    Given path '/Account/v1/User/' + storedUser.userId
    And header Authorization = 'Bearer ' + storedUser.token
    When method Delete
    Then status 204
    And print 'Usuário ' + storedUser.username + ' (ID: ' + storedUser.userId + ') excluído com sucesso!'

    # Marcar usuário como excluído
    * storedUser.deleted = true
    * storedUser.deletedAt = new Date().toString()


    # (POST SUCESSO) Adicionar livro à coleção do usuário com autenticação - 16
  Scenario: Adicionar livro à coleção do usuário com sucesso

    # Criar usuário e obter token
    * def generateUsername = function() {return 'user_' + new Date().getTime() + '_' + Math.floor(Math.random() * 10000);}
    * def username = generateUsername()
    * def password = 'Teste@123'

    # Criar usuário
    Given path '/Account/v1/User'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 201
    And def userId = response.userID

    # Gerar token de autenticação
    Given path '/Account/v1/GenerateToken'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 200
    And match response.status == 'Success'
    And def authToken = response.token
    * print 'Token gerado: ' + authToken

    # Adicionar livro à coleção do usuário
    Given path '/BookStore/v1/Books'
    And header Authorization = 'Bearer ' + authToken
    And request {"userId": "#(userId)", "collectionOfIsbns": [{"isbn": "9781449325862"}]}
    When method Post
    Then status 201
    And match response.books[0].isbn == '9781449325862'
    * print 'Livro adicionado com sucesso: ISBN 9781449325862 (Git Pocket Guide)'

    # (POST SUCESSO) Adicionar múltiplos livros - 17
  Scenario: Adicionar múltiplos livros à coleção
    * def generateUsername = function() {return 'user_' + new Date().getTime() + '_' + Math.floor(Math.random() * 10000);}
    * def username = generateUsername()
    * def password = 'Teste@123'

    # Criar usuário
    Given path '/Account/v1/User'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 201
    And def userId = response.userID

    # Gerar token de autenticação
    Given path '/Account/v1/GenerateToken'
    And request { "userName": "#(username)", "password": "#(password)" }
    When method Post
    Then status 200
    And match response.status == 'Success'
    And def authToken = response.token

    # Adicionar múltiplos livros
    Given path '/BookStore/v1/Books'
    And header Authorization = 'Bearer ' + authToken
    And request {"userId": "#(userId)", "collectionOfIsbns": [{"isbn": "9781593277574"},{"isbn": "9781491950296"},{"isbn": "9781449331818"}]}
    When method Post
    Then status 201
    And match response.books[*].isbn contains ['9781593277574', '9781491950296', '9781449331818']
    * print 'Total de livros adicionados: ' + response.books.length
    * print 'Livros adicionados: ' + response.books

