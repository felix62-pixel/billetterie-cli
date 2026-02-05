#!/bin/bash

# ===============================
# CONFIGURATION
# ===============================
DB_NAME="billeterie"
DB_USER="root"
DB_PASS="motdepasse"  # à changer
BACKUP_DIR="./backups"
LOG_FILE="./billeterie.log"

# Créer dossier backup si inexistant
mkdir -p "$BACKUP_DIR"

# ===============================
# FONCTIONS UTILITAIRES
# ===============================

log_action() {
    # $1 : message
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

authentification() {
    read -p "Nom utilisateur : " username
    read -s -p "Mot de passe : " password
    echo

    # Vérification dans la table Utilisateur
    result=$(mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -sse \
        "SELECT role FROM Utilisateur WHERE nom='$username' AND motDePasse='$password';")
    
    if [ -z "$result" ]; then
        echo "Authentification échouée !"
        log_action "Tentative de connexion échouée pour $username"
        return 1
    else
        USERNAME="$username"
        ROLE="$result"
        echo "Connecté en tant que $USERNAME ($ROLE)"
        log_action "$USERNAME s'est connecté"
        return 0
    fi
}

generer_numero_ticket() {
    local date_form=$(date '+%Y%m%d')
    local count=$(mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -sse \
        "SELECT COUNT(*) FROM Tickets WHERE date=CURDATE();")
    count=$((count + 1))
    printf "TCK-%s-%04d\n" "$date_form" "$count"
}

effectuer_vente() {
    echo "=== Vente de tickets ==="
    read -p "Code client : " code_client
    read -p "Nombre de tickets : " nb_tickets

    mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e "START TRANSACTION;"

    total=0
    for ((i=1;i<=nb_tickets;i++)); do
        numero_ticket=$(generer_numero_ticket)
        prix=100  # Exemple : prix fixe
        total=$((total + prix))

        mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e \
            "INSERT INTO Tickets (date, statut, prix, idVente) VALUES (CURDATE(), 'VALIDE', $prix, NULL);"
        log_action "Ticket $numero_ticket vendu pour client $code_client"
    done

    mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e "COMMIT;"
    echo "Vente terminée. Total = $total"
}

annuler_ticket() {
    read -p "ID du ticket à annuler : " id_ticket
    status=$(mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -sse \
        "SELECT statut FROM Tickets WHERE idTickets=$id_ticket;")
    
    if [ -z "$status" ]; then
        echo "Ticket inexistant !"
        return
    elif [ "$status" == "ANNULE" ]; then
        echo "Ticket déjà annulé."
        return
    fi

    mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e \
        "UPDATE Tickets SET statut='ANNULE' WHERE idTickets=$id_ticket;"
    echo "Ticket annulé avec succès."
    log_action "Ticket $id_ticket annulé par $USERNAME"
}

consulter_statistiques() {
    echo "=== Statistiques mensuelles ==="
    mysql -u"$DB_USER" -p"$DB_PASS" -D"$DB_NAME" -e \
        "SELECT MONTH(dateVente) AS mois, COUNT(idVente) AS nb_ventes, SUM(montant) AS chiffre_affaires FROM Vente GROUP BY MONTH(dateVente);"
}

sauvegarde_mysql() {
    filename="$BACKUP_DIR/billeterie_$(date '+%Y%m%d_%H%M%S').sql"
    mysqldump -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" > "$filename"
    log_action "Sauvegarde automatique créée : $filename"

    # Supprimer les backups > 7 jours
    find "$BACKUP_DIR" -type f -name "*.sql" -mtime +7 -exec rm {} \;
}

menu_principal() {
    while true; do
        echo
        echo "=== Menu Principal ==="
        echo "1. Effectuer une vente"
        echo "2. Annuler un ticket"
        echo "3. Consulter statistiques"
        echo "4. Sauvegarde base de données"
        echo "5. Quitter"
        read -p "Choix : " choix

        case $choix in
            1) effectuer_vente ;;
            2) annuler_ticket ;;
            3) consulter_statistiques ;;
            4) sauvegarde_mysql ;;
            5) echo "Au revoir !"; log_action "$USERNAME s'est déconnecté"; exit ;;
            *) echo "Choix invalide" ;;
        esac
    done
}

# ===============================
# SCRIPT PRINCIPAL
# ===============================

authentification
if [ $? -eq 0 ]; then
    menu_principal
fi
