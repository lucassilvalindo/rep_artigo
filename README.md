# Artigo Técnico: Desnormalização em Bancos de Dados Relacionais

Repositório oficial criado no âmbito da atividade académica sobre normalização e modelagem de dados.

## Autores
Lucas Silva Marques, Lucas Oliveira Fernandes da Silva, Estephane Barreto, Matheus dos Santos Chaves, Enzo Ferrari (Estudantes de TI).

## Link da Página Web Publicada
Aceda ao artigo completo em formato web através do link: [GitHub Pages do Projeto](https://github.com/lucassilvalindo/rep_artigo).

## Como Rodar os Scripts Localmente
Para testar os scripts SQL do projeto num ambiente limpo, siga os passos abaixo:

1. **SGBD Utilizado:** PostgreSQL (Versão 15 ou superior recomendada)
2. **Passos:**
   - Clone o repositório para a sua máquina local.
   - Abra a ferramenta de gestão do PostgreSQL (ex: pgAdmin ou DBeaver).
   - Execute o script localizado na pasta <code>sql/desnormalizacao.sql</code> para testar a criação dos modelos OLTP e OLAP.

## Estrutura do Repositório
```text
/
├── index.html              # Página web principal do artigo
├── styles/                 # Pasta de estilos CSS (opcional / integrado)
├── images/                 # Diagramas e recursos visuais
├── sql/
│   └── desnormalizacao.sql # Scripts SQL comentados e testados
└── README.md               # Documentação do repositório
