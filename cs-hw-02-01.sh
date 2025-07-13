#!/bin/bash

sites_file="sites.txt"
log_file="website_status.log"

#Перевірка існування файлу зі списком сайтів
if [[ ! -f "$sites_file" ]]; then
    echo "File $sites_file does not exist."
    exit 1
fi

#Очищуємо файл логів перед початком запису
> "$log_file"

while IFS= read -r site || [[ -n "$site" ]]; do
    #Видаляємо Windows-символи та пробіли
    site=$(echo "$site" | tr -d '\r' | xargs)

    #Пропускаємо порожні рядки
    if [[ -z "$site" ]]; then
        continue
    fi

    #Виконуємо запит curl та отримуємо HTTP-код
    http_code=$(curl -o /dev/null -s -w "%{http_code}" -L "$site")

    #Формуємо повідомлення про статус
    if [[ "$http_code" == "200" ]]; then
        echo "<$site> is UP" >> "$log_file"
    else
        echo "<$site> is DOWN" >> "$log_file"
    fi
done < "$sites_file"

echo "Results have been written to $log_file"
