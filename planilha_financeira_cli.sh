PLANILHA=$1
 
#verificando se o arquivo existe
if [ ! -f "$PLANILHA" ]; then
    echo "Planilha $PLANILHA não encontrada."
    read -p "Criar nova planilha com este nome? [S/N] " criar_planilha 
    if [ ${criar_planilha,,} = 'n' ] ; then
        echo "Saindo..."
        exit 0
    else 
        echo "descricao,categoria,valor,data" > $PLANILHA
    fi    
fi
 
# Funcao para exibir ocorrencias de uma categoria (receita/despesa)
get_categoria () {
    cat=$1
    echo "Listando ${cat}s"
    total=0
    OLDIFS=$IFS
    IFS=','
    while read descricao categoria valor data
    do
        if [ $categoria = $cat ] ; then
            echo -e "$data\tR\$ $valor\t$descricao"
            ((total+=valor))
        fi
    done < $PLANILHA 
    IFS=$OLDIFS
 
    echo "Valor total das ${cat}s: R\$ $total"
}
 
# Funcao para adicionar ocorrencia na planilha
adicionar_ocorrencia () {
    data=$(date +"%m-%d-%y")
    cat=$1
 
    echo "Adicionando $cat. "
    read -p "Descricao " descricao
    read -p "Valor " valor
 
    case "${cat}" in
        despesa)
            echo "$descricao,despesa,$valor,$data" >> $PLANILHA
        ;;
 
        receita)
            echo "$descricao,receita,$valor,$data" >> $PLANILHA
        ;;
    esac
 
    if [ $? = 0 ] ; then
        echo "Operacao: adicionar $cat realizada com sucesso."
    fi
}
 
opcao=$2
case "${opcao}" in
        ld|Ld|lD|LD)
        get_categoria "despesa"
        ;;
 
        lr|Lr|lR|LR)
        get_categoria "receita"
        ;;
 
        ad|Ad|aD|AD)
        adicionar_ocorrencia "despesa"
        ;;
 
        ar|Ar|aR|AR)
        adicionar_ocorrencia "receita"
        ;;
 
        *)
            echo "PLANILHA FINANCEIRA CLI"
            echo "MODO DE USAR"
            echo "./planilha_financeira_cli.sh <caminho_do_arquivo_csv> <opcoes>"
            echo "OPCOES"
            echo "ld: listar despesas"
            echo "lr: listar receitas"
            echo "ad: adicionar despesa"
            echo "ar: adicionar receita"
        ;;
    esac
 
