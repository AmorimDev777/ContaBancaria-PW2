<?php 

require_once './web/service/Conta.php';

class Titular{
    protected string $nome,
    protected string $cpf,
    protected string $endereco

    public Titular($nome, $cpf, $endereco){
        $this->nome = $nome,
        $this->cpf = $cpf,
        $this->endereco = $endereco
    }

    public setNome($nome){
        if(strlen(trim($nome)) < 3){
            throw new InvalidArgumentException("O nome do titular deve ter pelo menos 3 caracteres!")
        }

        if(preg_match('/\d/', $nome)){
            throw new InvalidArgumentException("O nome do titular não pode conter números!")
        }

        $this->nome = $nome;
    }

    public setCpf($cpf){
        if(strlen(trim($cpf)) != 11){
            throw new InvalidArgumentException("O CPF deve conter exatamente 11 dígitos numéricos!");
        }

        $this->cpf = $cpf;
    }

    public setEndereco($endereco){
        if(is_null($endereco))
        {
            throw new InvalidArgumentException("O endereço não pode ser vazio!");
        }
        $this->endereco = $endereco;
    }

    public getNome():string{
        return $this->nome;
    }
    public getCpf():string{
        return $this->cpf;
    }
    public getEndereco():string{
        return $this->endereco;
    }

    #[Override]
    public ToString():string{
        return 'Nome: '.''$this->nome''.', CPF: '.''$this->cpf''.', Endereço: '.''$this->endereco''.'';
    }
}