# vagrant-dev-machine

##Documentation
####[English](#english-1)
####[Português](#português-1)

---

##English

###Goal

Vagrant machine is being developed to provision many useful tools and languages ​​for developers of different languages. The idea is that each developer needs analysis tools and languages ​​and locally exclude those who are not of interest.

### Documentation

The scripts contained in this repository have comments in English (en) and Portuguese (pt) as well as this README.

### About machine

This machine is built with the operating system CentOS uses a fixed IP to facilitate the use of the machine (should those who will be using is VM verify that does not conflict with other PIs) and the memory settings are commented because they are very particular characteristics should each specify the amount of memory that will be provided to the VM or maintain commented to use the default settings Vagrant.

By the time of last modification of this doc the aim was to fund the following tools or languages ​​but this list may grow:

- Java 8 (Oracle Edition)
- Tomcat 8
- Wildfly 9
- MySQL
- PostgreSQL
- MongoDB
- PHP
- Apache
- Ruby

### Before you begin

Before you start you need to install a virtualization tool, I use the virtual-box that works well with Vagrant and install vagrant own.

### Community

Should you not find any tool or language of your interest, feel the desire to create a provisioning script and add this project to help other developers. Or even improve the English version of this that was made with Google Translator help.

If this repository does not have information in their native language help us translating to your language helping others in their country.

I do not use puppet or something similar for the supply because this machine is designed to use CentOS, so easier to do everything directly via shell, but if someone with experience in puppet want to convert scripts to so who want to change the operating system to a Ububtu for example, and can do so without having to change all shell will be very good liking. :)

---

##Português

###Objetivo

Esta máquina Vagrant está sendo desenvolvida para provisionar diversas ferramentas e linguagens úteis para os desenvolvedores de diversas linguagens. A ideia é que cada desenvolvedor analise suas necessidades de ferramentas e linguagens e excluir localmente os que não são de seu interesse.

###Documentação

Os scripts contidos neste repositório possuem comentários em inglês (en) e em português (pt) assim como este README.

###Sobre a máquina

Esta máquina é criada com o sistema operacional CentOS, utiliza um IP fixo para facilitar no uso da máquina (devendo quem for utilizar está VM verificar se não entrará em conflito com outros IPs) e as configurações de memória estão comentadas pois são características bem particulares devendo cada um especificar a quantidade de memória que será fornecida para a VM ou manter comentado para utilizar as configurações padrão do Vagrant.

Até o momento da última alteração deste documento o objetivo era aprovisionar as seguintes ferramentas ou linguagens porém podendo esta lista crescer:

- Java 8 (Oracle Edition)
- Tomcat 8
- Wildfly 9
- MySQL
- PostgreSQL
- MongoDB
- PHP
- Apache
- Ruby

###Antes de começar

Antes de começar é necessário instalar uma ferramenta de virtualização, utilizo o virtual-box que funciona bem com o Vagrant e instalar o próprio Vagrant.

###Comunidade

Caso não encontre alguma ferramenta ou linguagem de seu interesse, sinta-se a vontade para criar um script de provisionamento e adicionar a este projeto para ajudar outros desenvolvedores. Ou até mesmo melhorar a versão em inglês deste que foi feita com ajuda do Google Translator.

Se este repositório não possuir informações na sua língua nativa ajude-nos traduzindo para o seu idioma ajudando assim outros de seu país.

Não utilizo puppet ou algo similar para o aprovisionamento pois esta máquina foi elaborada para usar CentOS, sendo assim mais fácil fazer tudo diretamente via shell, mas caso alguém com experiência em puppet queira converter os scripts para assim quem quiser trocar o sistema operacional para um Ubuntu, por exemplo, consiga fazer isso sem ter que alterar todos os shell será de muito bom agrado. :)
