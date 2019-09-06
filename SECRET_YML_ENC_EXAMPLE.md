secret_key_base: f713d3a1e47bae80d508be256e66eacdbe45dcfd51a08eb6c28a84b4b6d9b6da9ff7e547a8c50e6dfa9550b08ecd43c064d719677b93c18bfa7f0741f0580661
postgres:
  development:
    password: <password>
    username: "alphawholesale"
    host: "localhost"
    database: "alphawholesale_development"
mail:
  development:
    HOST: localhost
    HOST_PORT: 3000
    ADDRESS: "smtp.gmail.com"
    PORT: 587
    USER_NAME: <your mail>
    PASSWORD: <password>
    AUTHENTICATION: "plain"
    ENABLE_STARTTLS_AUTO: true
  production:
    HOST: <your host>
    HOST_PORT: 80
    ADDRESS: "smtp.gmail.com"
    PORT: 587
    USER_NAME: <your mail>
    PASSWORD: <your google password>
    AUTHENTICATION: "plain"
    ENABLE_STARTTLS_AUTO: true
