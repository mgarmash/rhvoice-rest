# rhvoice-rest

Это проект на основе синтезатора речи https://github.com/Olga-Yakovleva/RHVoice

Основные цели:
- Обертка в Docker
- Минимальный REST API для генерации MP3 из текста
- Интеграция с home-assistant.io в качестве TTS-движка  

Пример запуска на одной машине с HA

`docker run -d -p 8080:8080 mgarmash/rhvoice-rest`

Проверить можно вот так (должно вернуть mp3-поток)

`http://localhost:8080/say?text=123`

Принимаются только два параметра: 
`text` - URL-encoded строка  
`voice` - имя голоса для RHVoice (полный список тут `https://github.com/Olga-Yakovleva/RHVoice/wiki/Latest-version-%28Russian%29`)

Docker-образ получился массивный, принимаются PR для уменьшения. C Alpine не взлетает сборка RHVoice.
Поддерживаются все языки RHVoice выбором соответствующего голоса.
Конфигурация по-умолчанию, можно смонтировать `/usr/local/etc/RHVoice/` и подложить свой конфиг.
Детали интеграции и кастомный компонент для HA: `https://github.com/mgarmash/ha-rhvoice-tts`

#TODO
 - Написать нормальную доку
 - Сделать PR в home-assistant.io
 
#Links
 - https://github.com/Olga-Yakovleva/RHVoice
 - https://github.com/vantu5z/RHVoice-dictionary
