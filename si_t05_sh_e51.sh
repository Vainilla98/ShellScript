#!/bin/bash
clear
# Paso 1: Comprouebas $# -eq 2
#   1.1- Usuario es root
#   1.2- $1 es lo que me piden. Directorio existente -d $1
#   1.3- $2 es lo que me piden. Extension de archivo (confiamos)
# Paso 2: Crear directorio "$1_extension" mkdir "$1"_""
#   2.1 - Si existe preguntar si lo quiere sobreescribir 
# Paso 3: Hacer un find de $1
#   3.1 - Obmitir errores 
#   3.2 - Si existe preguntar si lo quiere sobreescribir 
#   3.3 - Fichero temporal "yyyy mm dd milisegundos ext.txt"
#       3.3.1 - Si exsite regeneramos el fichero
# Paso 4: Recorrer el fichero linea a linea
# Paso 5: cp con sudo ¿que ocurre?
# Paso 6: Al final avisamos 

if [ $UID -ne 0 ]; then
    echo "Tienes que inicar sesion como root para ejecutar"
    exit 1
fi
if [ $# -ne 2 ]; then
    echo "Tienes que pasar al menos 2 parametros."
    exit 1
fi
if [ ! -d $1 ]; then
    echo "El directorio $1 debe existir en el directorio actual"
    exit 1
fi

nombreDir="$1_$2"
# echo $nombreDir

if [ -d "$nombreDir" ]; then
    echo "Ya existe un directorio con ese nombre"
    echo "Lo quieres sobrescribir?[s/n]" res
    if [ $res == "s" ]; then
        echo "Lo sobreescibimos"
        rm -r $nombreDir
    elif [ $res == "n" ]; then
        echo "Hasta lugo"
        exit 1
    else 
        echo "Introduce s/n. Vuelve a ejecutar el script"
        exit 1
    fi
fi

mkdir $nombreDir
temp=$(date +%Y%m%d%s%3N)$2.txt
while [ -f $temp ]; do
    temp=$(date +%Y%m%d%s%3N)$2.txt 
done
touch $temp

find $1 -iname "*.$2" 1>>$temp 2>/dev/null

numLineas=$(cat $temp | wc -l)
if [ $numLineas -eq 0 ]; then
    echo "No se han producido resultados de busqueda."
else
    for((i=1; i<=$numLineas; i++))
    do
        lineaAct=$(head -n $i $temp | tail -n 1)
        # echo $lineaAct
        cp -p $lineaAct $nombreDir
    done
fi
rm $temp
echo "Trabajo realizado con éxito"
exit 0
