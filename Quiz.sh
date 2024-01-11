#!/bin/bash

# Função para remover acentos
remover_acentos() {
    echo "$1" | iconv -f utf-8 -t ascii//TRANSLIT
}

# Função para ler perguntas e respostas do arquivo
carregar_perguntas() {
    while IFS=';' read -r pergunta resposta; do
        perguntas+=("$pergunta")
        respostas+=("$resposta")
    done < perguntas_respostas.txt
}

# Função para embaralhar perguntas e respostas
embaralhar_perguntas() {
    indices=($(shuf -i 0-$((${#perguntas[@]}-1))))
    perguntas=("${perguntas[@]}")
    respostas=("${respostas[@]}")

    # Aplicar a ordem aleatória aos arrays
    for i in "${!indices[@]}"; do
        perguntas_embaralhadas[$i]="${perguntas[${indices[$i]}]}"
        respostas_embaralhadas[$i]="${respostas[${indices[$i]}]}"
    done

    perguntas=("${perguntas_embaralhadas[@]}")
    respostas=("${respostas_embaralhadas[@]}")
}

# Função para executar o quiz
executar_quiz() {
    pontuacao=0
    total_perguntas=${#perguntas[@]}

    for ((i=0; i<total_perguntas; i++)); do
        echo "Pergunta $((i+1)): ${perguntas[$i]}"
        read -p "Resposta: " resposta_usuario

        resposta_usuario_sem_acentos=$(remover_acentos "$resposta_usuario")
        resposta_correta_sem_acentos=$(remover_acentos "${respostas[$i]}")

        if [[ "$(echo "$resposta_usuario_sem_acentos" | tr '[:upper:]' '[:lower:]')" == "$(echo "$resposta_correta_sem_acentos" | tr '[:upper:]' '[:lower:]')" ]]; then
            echo "Correto!"
            ((pontuacao++))
        else
            echo "Errado. A resposta correta é: ${respostas[$i]}"
            break
        fi
    done

    echo "Quiz encerrado. Sua pontuação: $pontuacao de $total_perguntas"
}

# Início do script
perguntas=()
respostas=()

carregar_perguntas
embaralhar_perguntas
executar_quiz
