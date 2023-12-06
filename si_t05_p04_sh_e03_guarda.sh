#!/bin/bash
clear

if [ $UID -ne 0 ]; then
    echo "Tienes que inicar sesion como root para ejecutar"
    exit 1
fi

salir=0

while [ $salir -eq 0 ]; do
    echo "Introduce 'salir' para salir del programa."
    read -p "Introduce el nombre del proceso: " proc
    if [ -z $proc ]; then
        echo "Introduzca algo."
    elif [ $proc == "salir" ]; then
        salir=1
    else
        numLineas=$(pgrep -ci $proc) 
        # -c es que muestre el nº de procesos que van con el
        # -i es caseInsensitive
        # es la fusion de "ps ax | grep 'code' "
        if [ $numLineas -eq 0 ]; then
            echo "El proceso $proc no está en ejecucion."
        else
            PIDo=$(pgrep -i $proc)
            # echo $PIDo
            ps -w -o pid,state,user -p $PIDo
        fi
    fi
    echo ""
done

exit 0