<!DOCTYPE html>
<html lang="pt-br">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Criar Conta</title>
    <link rel="shortcut icon" href="/images/Java.png" type="image/x-icon">
    <link rel="stylesheet" href="/css/style.css">
    <script src="/js/script.js"></script>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.7.2/css/all.min.css" integrity="sha512-Evv84Mr4kqVGRNSgIGL/F/aIDqQb7xQ2vcrdIwxfjThSH8CSR7PBEakCr51Ck+w+/U6swU2Im1vVX0SVk9ABhg==" crossorigin="anonymous" referrerpolicy="no-referrer" />
</head>
<body class="bodyCadastro">

    <a href="/index.php" class="setaVoltarForm"><i class="fa-solid fa-arrow-left"></i></a>

    <div class="divForm">
        <div class="logoForm">
            <img src="/images/JavaLogo.webp" alt="">
            <p>Java Bank</p>
        </div>
        <p class="CriarConta">Criar Conta</p>
        <form action="" class="formCriarConta">
            <div class="divIpt">
                <input type="text" class="iptForm" required>
                <label for="">Nome</label>
            </div>
            <div class="divIpt">
                <input type="text" class="iptForm" maxlength="11" required>
                <label for="">CPF</label>
            </div>
            <div class="divIpt">
                <input type="text" class="iptForm" required>
                <label for="">Endereço</label>
            </div>
            <div class="divIptRadio">
                <div>
                    <label for="Corrente">Corrente</label>
                    <input type="radio" name="ckbox" id="ckbox">
                </div>
                <div>
                    <label for="Poupança">Poupança</label>
                    <input type="radio" name="ckbox" id="ckbox">
                </div>
            </div>
            <input type="submit" value="Criar" class="btnSubmit">
        </form>
    </div>
    <div class="imgCadastro"></div>
</body>
</html>