
# 📱 MarvelApp

## 📄 Sobre o Projeto

O objetivo inicial deste projeto era de reforçar os conhecimentos e conceitos de Swift para o desenvolvimento de aplicações iOS. Porém, com a possibilidade e oportunidade de iniciar uma mentoria de desenvolvimento iOS, foi escolhido este projeto para aprimoramento. O projeto está sendo refatorado para se adequar as melhores práticas e padrões utilizados no mercado de trabalho.

Um exemplo de alteração bastante significativa no projeto é que a arquitetura que iniciou como MVC e logo após foi migrada para MVVM, agora será refatorada para utilização do VIP.

## 📌 Requisitos do Projeto

## Fase 1: Setup Inicial: MVC + Navegação + Interfaces

### Tela Inicial: HomeViewController

- [x] Carrossel superior com 5 personagens
- [x] Campo de pesquisa de personagens
- [x] Lista vertical abaixo do campo de pesquisa, com os personagens seguintes, sem repetir
- [x] Scroll infinito dos personagens
- [x] Utilizar o Figma como expecificação de UI/UX
- [x] Apenas layout, os dados podem estar Mockados
- [x] Opcional: utilizar animação para indicar carregamento das informações (lottie)

### Tela de Detalhes: DetailsViewController

- [x] Utilizar viewCode para fazer a tela
- [x] Utilizar o Figma como expecificação de UI/UX
- [x] Apenas layout, os dados podem estar Mockados

Prazo: 5 dias - 40h

## Fase 2: Integração com API

### Arquitetura

- [x] Adicionar uma camada de serviços

#### Controller
- Modificações de view
- Lida com ações do usuário
- Regras de negócio

#### Service
- Requisições na API

Prazo: 4 dias - 32h

## Fase 3: Testes Unitários

- [x] Testar chamada da API

Prazo: 3 dias - 24h

## Fase 4: Persistência de Dados

- [x] Implementar um modelo de persistência onde: Após o usuário ter feito o carregamento da lista Marvel, caso fique sem conexão, seja possível a visualização dos itens já visualizados e persistidos localmente
- A escolha do banco de dados é livre

Prazo: 5 dias - 40h

## Fase 5: Filtro de Pesquisa

- [x] Implementar um filtro de pesquisa dos personagens
- [x] Se não tiver nenhum personagem de acordo com o que foi pesquisado, aparecer algum tipo de mensagem informando que o personagem buscado não foi encontrado

Prazo: 3 dias - 24h

## Fase 6: Arquitetura MVVM

- [x] Refatorar o projeto adaptando para a Arquitetura MVVM - Model View ViewModel

Prazo: 5 dias - 40h

## Fase 7: Acessibilidade

- [x] Encontrar uma forma de verificar a mudança do VoiceOver (ligado ou desligado), enquanto o app está rodando, para não dar problema caso tenha algum elemento que precise ser escondido caso o VoiceOver esteja desativado

#### Home
- [x] Incluir títulos
- [x] Colocar número da listagem em ambas listas

#### Nas células das listas:
- [x] Agrupar imagem com o nome do personagem
- [x] Fazer VoiceOver falar que tem uma image e o nome do herói

#### Detalhes
- [x] Agrupar as duplas de informações (título + descrições)

Prazo: 2 dias - 16h

## Fase 8: Tagueamento

- [x] Taguear o evento de ScreenView das telas Home e Details
- [x] Taguear junto ao ScreenView a classe Swift pertencente a tela
- [x] Taguear um evento de SelectContent ao clicar em um item do carrossel ou lista
- [x] Taguear junto ao evento “nome_heroi”: “nome do heroi” (trocar espaço por “_” e retirar os acentos)
- [x] Taguear UserId ou qualquer apelido e no UserProperty a “fruta_favorita” com o value = sua fruta favorita
- [x] Remover tagueamento default de screenView
- [x] Opcional: Criar classe de abstração para que eu possa trocar a ferramenta de tagueamento

Prazo: 3 dias - 24h

## ✨ Arquitetura, Tecnologias e Bibliotecas utilizadas

- MVVM Architecture

- Xcode Develop Version 13.0
- Versão mínima iOS 12.1

- Lottie (3.2.3)
- Kingfisher (7.1.1)
- ViewAnimator (3.1.0)
- Firebase (8.11.0)

- abseil (0.20200225.4)
- BoringSSL-GRPC (0.7.2)
- GoogleAppMeasurement (8.9.1)
- GoogleDataTransport (9.1.2)
- GoogleUtilities (7.7.0)
- gRPC (1.28.4)
- GTMSessionFetcher (1.7.0)
- leveldb (1.22.2)
- nanopb (2.30908.0
- Promises (2.0.0)
- SwiftProtobu (1.18.0)

---

Desenvolvido com ❤️ por [Rayana Prata](https://www.linkedin.com/in/rayanaprata).
