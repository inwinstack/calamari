#!/usr/bin/env bash
# Program:
#       This program is install calamari alert apis
# History:
# 2015/11/17  Kyle.Bai <kyle.b@inwinstack.com>  First release
#
ALERT_APIS_MODELS="models.py"
ALERT_APIS_SERIALIZER_V1="serializers/v1.py"
ALERT_APIS_URL_V1="urls/v1.py"
ALERT_APIS_VIEW_V1="views/v1.py"


CALAMARI_CORE_DIR=$(sudo find /opt -name calamari_rest | grep -o "^/opt/.*/calamari_rest$")
CALAMARI_HOME="/opt/calamari"
CALAMARI_ENV="/opt/calamari/venv"
CALAMARI_BACKUP="/opt/calamari/backup"

function install_calamari(){
    # Install calamari rest for alert rule
    echo "Backup nagative calamari_rest library ...."
    sudo mkdir ${CALAMARI_BACKUP}
    sudo mkdir ${CALAMARI_BACKUP}/views
    sudo mkdir ${CALAMARI_BACKUP}/urls
    sudo mkdir ${CALAMARI_BACKUP}/serializers

    sudo mv "${CALAMARI_CORE_DIR}/${ALERT_APIS_MODELS}" "${CALAMARI_BACKUP}/${ALERT_APIS_MODELS}"
    sudo mv "${CALAMARI_CORE_DIR}/${ALERT_APIS_SERIALIZER_V1}" "${CALAMARI_BACKUP}/${ALERT_APIS_SERIALIZER_V1}"
    sudo mv "${CALAMARI_CORE_DIR}/${ALERT_APIS_URL_V1}" "${CALAMARI_BACKUP}/${ALERT_APIS_URL_V1}"
    sudo mv "${CALAMARI_CORE_DIR}/${ALERT_APIS_VIEW_V1}" "${CALAMARI_BACKUP}/${ALERT_APIS_VIEW_V1}"

    echo "Installing alert apis for calamari_rest ..."
    sudo cp -R "rest-api/calamari_rest/${ALERT_APIS_MODELS}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_MODELS}"
    sudo cp -R "rest-api/calamari_rest/${ALERT_APIS_SERIALIZER_V1}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_SERIALIZER_V1}"
    sudo cp -R "rest-api/calamari_rest/${ALERT_APIS_URL_V1}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_URL_V1}"
    sudo cp -R "rest-api/calamari_rest/${ALERT_APIS_VIEW_V1}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_VIEW_V1}"

    echo "Sync alert database ...."
    source "${CALAMARI_ENV}/bin/activate"
    python ${CALAMARI_HOME}/webapp/calamari/manage.py sql calamari_rest
    python ${CALAMARI_HOME}/webapp/calamari/manage.py syncdb

    sudo chmod 777 /var/log/calamari/cthulhu.log
    sudo chmod 777 /var/log/calamari/calamari.log
    sudo service apache2 restart

    echo "Install Complete ...."
}

function uninstall_calamari(){
    # Uninstall calamari rest for alert rule
    echo "Resotre backup calamari_rest library ...."
    sudo rm  "${CALAMARI_CORE_DIR}/${ALERT_APIS_MODELS}"
    sudo rm  "${CALAMARI_CORE_DIR}/${ALERT_APIS_SERIALIZER_V1}"
    sudo rm  "${CALAMARI_CORE_DIR}/${ALERT_APIS_URL_V1}"
    sudo rm  "${CALAMARI_CORE_DIR}/${ALERT_APIS_VIEW_V1}"

    sudo mv "${CALAMARI_BACKUP}/${ALERT_APIS_MODELS}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_MODELS}"
    sudo mv "${CALAMARI_BACKUP}/${ALERT_APIS_SERIALIZER_V1}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_SERIALIZER_V1}"
    sudo mv "${CALAMARI_BACKUP}/${ALERT_APIS_URL_V1}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_URL_V1}"
    sudo mv "${CALAMARI_BACKUP}/${ALERT_APIS_VIEW_V1}" "${CALAMARI_CORE_DIR}/${ALERT_APIS_VIEW_V1}"

    sudo rm -rf ${CALAMARI_BACKUP}

    source "${CALAMARI_ENV}/bin/activate"
    python ${CALAMARI_HOME}/webapp/calamari/manage.py sqlclear calamari_rest
    python ${CALAMARI_HOME}/webapp/calamari/manage.py syncdb

    sudo service apache2 restart
    echo "Uninstall Complete ...."
}

read -p "Install/Uninstall(In/Uni)：" check

if [ ${check} == 'In' ] || [ ${check} == 'Install' ]; then
    if ls ${CALAMARI_HOME} | grep -Fxq "backup"
    then
        echo "calamari alert apis is installed ..."
    else
        install_calamari
    fi
elif [ ${check} == 'Uni' ] || [ ${check} == 'Uninstall' ]; then
    if ls ${CALAMARI_HOME} | grep -Fxq "backup"
    then
        uninstall_calamari
    else
        echo "calamari alert apis is uninstalled ..."
    fi
else
    echo "ERROR Input......"
fi

