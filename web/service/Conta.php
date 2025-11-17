<?php
    abstract class Conta{
        protected Titular $titular;
        protected float $saldo;
        protected float $limite;

        public function setId(int $id)
        {
            if ($id <= 0)
            {
                throw new Exception(message: "O número deve ser positivo");
            }
            $this->id = $id;
        }

        public function getId(int $id)
        {
            return $this->id;
        }
    }
?>