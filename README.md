## **CRIAR SUBDOMÍNIO E APONTAR PARA O IP DA SUA VPS**

**Testado em Ubuntu 20 e 22**

1. **Editar o arquivo de configuração**:  
   Coloque suas senhas preferidas, seu e-mail e seus domínios.

2. **Instalações múltiplas**:  
   Se desejar instalar 2 instâncias, altere o nome da instância, a porta do backend e a porta do frontend. **Não use as mesmas portas de outras instalações**.

3. **Atualização**:  
   A opção de atualizar vai buscar a última versão do repositório usado para a instalação.

4. **Portas recomendadas**:  
   **Nunca use as portas 80 e 443 para o backend.** Utilize portas **4000 e 4999** para o frontend e **5000 e 5999** para o backend.

---

## **CHECAR PROPAGAÇÃO DO DOMÍNIO**

Verifique a propagação do seu domínio em [https://dnschecker.org/](https://dnschecker.org/).

---

## **RODAR OS COMANDOS ABAIXO**

Antes de iniciar, **verifique no site acima se o DNS foi propagado** para evitar erros durante a instalação.

**Recomendação**:  
Atualize seu sistema antes de iniciar. Após a atualização, **reinicie a VPS** para evitar problemas.

---

## **Atualizar a VPS**

Execute o comando abaixo para garantir que seu sistema esteja atualizado:

```bash
apt -y update && apt -y upgrade && reboot
```

---

## **Instalação do TikTickets**

Para instalar o TikTickets, execute o seguinte comando:

```bash
cd /home && apt install git -y && git clone https://github.com/jvkabum/Instalador-TiKTickets instaladortiktickets && sudo chmod +x ./instaladortiktickets/tiktickets && cd && cd /home && cd ./instaladortiktickets && sudo ./tiktickets
```

---

## **Acessar Instalador**

Caso precise acessar o instalador novamente, use o comando abaixo:

```bash
cd && cd /home && cd ./instaladortiktickets && sudo ./tiktickets
```

---

## **Acesso ao Portainer - Gerar Senha**

Para reiniciar o Portainer, acesse o console da sua VPS ou terminal e execute o seguinte comando:

```bash
docker container restart portainer
```

Este comando irá reiniciar o container do Portainer, reativando a instância. Após isso, acesse novamente a URL do Portainer no seu navegador:

`http://URLFrontend:9000/`

---

## **Contribuição**

Se este tutorial foi útil para você, considere fazer uma contribuição via **PIX**.