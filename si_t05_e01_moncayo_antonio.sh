#!/bin/bash
clear

function pausa(){
    echo "Pulse intro para continuar..."
    read intro
}

function ayuda(){
    echo "Ejecuta así:"
    echo -e "\t$0 DD mes YYYY"
    echo -e "\t$0 DD mes YYYY dirExistente fichNuevo"
}

#main

if [ $# -ne 3 ] && [ $# -ne 5 ]; then
    echo "Debes introducir 3 o 5 parámetros."
    exit 1
fi

aNombreMeses126=("enero" "febrero" "marzo" "abril" "mayo" "junio" "julio" "agosto" "septiembre" "octubre" "noviembre" "diciembre")
aDiasMeses126=(31 28 31 30 31 30 31 31 30 31 30 31)

diaA=$( date +%d)
mesA=$( date +%B)
anioA=$( date +%Y)

if [ $# -eq 5 ]; then
    if [ ! -d $4 ]; then
        echo "El direcotrio $4 no existe en el directorio actual"
        exit 1
    fi
    if [ -f $5 ]; then
        echo "El fichero $5 ya existe en el directorio actual"
        exit 1
    fi
        salir=0
    mal=0
    if [ $3 -lt $(($anioA-10)) ]; then
        echo "Año no valido. Debe ser de menos de 10 años"
        salir=1
    fi

    for ((i=0; i < ${#aNombreMeses126[@]} && $mal==0; i++))
    do
        if [ $2 == ${aNombreMeses126[$i]} ]; then
            mal=1
            indice=$i
        fi
    done
    if [ $mal -eq 0 ]; then
        salir=1
        echo "El mes $2 no existe en el calendario gregoriano"
    fi

    nDias=${aDiasMeses126[$indice]}

    # echo "$2: $nDias. Intorducido $3"
    if [ $2 == "febrero" ]; then
        if [ $(($3%4)) -eq 0 ] || ( [ $(($3%100)) -eq 0 ] && [$(($3%400)) -ne 0 ] ); then
            if [$1 -gt 29]; then
                salir=1
                echo "Febrero tiene 29 dias"
            fi
        fi
    elif [ $1 -lt 1 ] || [ $1 -gt $nDias ]; then
        salir=1
        echo "Dias no validos para $2"
    fi 
    if [ $salir -eq 1 ]; then
        echo "FALLO en los datos"
    else   
        # echo -n "" > $5
        echo "Fichero creado con éxito"
        mesNum=$(($indice+1))
        echo "$(find "$4" -type f -user $USER -newermt "$3-$mesNum-$1" 1>$5 2>/dev/null)"
        # Falta comprobar numero de lineas
    fi
else
    salir=0
    mal=0
    if [ $3 -lt $(($anioA-10)) ]; then
        echo "Año no valido. Debe ser de menos de 10 años"
        salir=1
    fi

    for ((i=0; i < ${#aNombreMeses126[@]} && $mal==0; i++))
    do
        if [ $2 == ${aNombreMeses126[$i]} ]; then
            mal=1
            indice=$i
        fi
    done
    if [ $mal -eq 0 ]; then
        salir=1
        echo "El mes $2 no existe en el calendario gregoriano"
    fi

    nDias=${aDiasMeses126[$indice]}

    # echo "$2: $nDias. Intorducido $3"
    if [ $2 == "febrero" ]; then
        if [ $(($3%4)) -eq 0 ] || ( [ $(($3%100)) -eq 0 ] && [$(($3%400)) -ne 0 ] ); then
            if [$1 -gt 29]; then
                salir=1
                echo "Febrero tiene 29 dias"
            fi
        fi
    elif [ $1 -lt 1 ] || [ $1 -gt $nDias ]; then
        salir=1
        echo "Dias no validos para $2"
    fi 
    if [ $salir -eq 1 ]; then
        echo "FALLO en los datos"
    else   
        echo "RESULTADO BUSQUEDA"
        echo " "
        mesNum=$(($indice+1))
        echo "$(find -type f -user $USER -newermt "$3-$mesNum-$1" 2>/dev/null)"
    fi
fi
echo "Hasta Luego. Mi id es 126"
exit 0