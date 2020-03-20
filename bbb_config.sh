#!/bin/bash

readonly LOG=~/logs/config.log

echo '$(date +%F\ %T) - Iniciando configuração...' >> $LOG
cd ~/
mkdir -p ~/logs

# Slide Default
echo '$(date +%F\ %T) - Baixando Slide default...' >> $LOG
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1LOL0LXHFwJK5g9bo98xdDFAUTfm9Bqxt' -O default.pdf
echo '$(date +%F\ %T) - Copiando...' >> $LOG
sudo cp ~/default.pdf /var/www/bigbluebutton-default/default.pdf
echo '$(date +%F\ %T) - Alterando propriedade...' >> $LOG
sudo chown root:root /var/www/bigbluebutton-default/default.pdf
echo '$(date +%F\ %T) - Slide Default - OK' >> $LOG

# Favicon
echo '$(date +%F\ %T) - Baixando Favicon...' >> $LOG
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=0By3w502v82abQ1UydU5EbWJlUG8' -O favicon.ico
echo '$(date +%F\ %T) - Copiando...' >> $LOG
sudo cp ~/favicon.ico /var/www/bigbluebutton-default/favicon.ico
echo '$(date +%F\ %T) - Favicon - OK' >> $LOG

# /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo '$(date +%F\ %T) - Alterando bigbluebutton.properties...' >> $LOG
sed -i -e 's/\(attendeesJoinViaHTML5Client=\).*/\1true/' \
-e 's/\(moderatorsJoinViaHTML5Client=\).*/\1true/' \
-e 's/\(defaultWelcomeMessage=\).*/\1<br><br>Bem-vindo \u00e0 <b>%%CONFNAME%%</b>!<br><br>Para participar da webconfer\u00eancia, seu computador deve ter, no m\u00ednimo, um <u>processador dual-core com pelo menos 2G de mem\u00f3ria, uma conex\u00e3o de 1Mbits de download e 0.5 Mbits de upload</u>. Voc\u00ea pode testar sua conex\u00e3o usando o <a href="http://www.speedtest.net" target="_blank"><u><b>speedtest.net</b></u></a>.<br><br>Se sua conex\u00e3o estiver boa, o \u00e1udio tiver sido configurado corretamente e, mesmo assim, o seu \u00e1udio apresentar problemas, tente alternar de navegador. S\u00e3o recomendadas as \u00faltimas vers\u00f5es dos navegadores <a href="https://www.mozilla.org/pt-BR/firefox/new/" target="_blank"><u>Firefox</u></a> ou <a href="https://www.google.com.br/chrome/browser/desktop/" target="_blank"><u>Chrome</u></a>.<br><br>Ao final da webconfer\u00eancia, clique em sair, no canto superior direito, e responda ao nosso question\u00e1rio de avalia\u00e7\u00e3o da ferramenta.<br><br>Qualquer d\u00favida na utiliza\u00e7\u00e3o da ferramenta, entre em contato atrav\u00e9s do email: webconferencia@virtual.ufc.br ou chame o <a href="http://solar.virtual.ufc.br/webconferences?request_support=true" target="_blank"><b>suporte em tempo real (clicando aqui)</b></a> ou no menu Ajuda./' \
-e 's/\(defaultWelcomeMessageFooter=\).*/\1<br>/' /usr/share/bbb-web/WEB-INF/classes/bigbluebutton.properties
echo '$(date +%F\ %T) - Html5 default - OK' >> $LOG
echo '$(date +%F\ %T) - defaultWelcomeMessageFooter - OK' >> $LOG

# /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo '$(date +%F\ %T) - Alterando settings.yml...' >> $LOG
sed -i -e 's/\(clientTitle:\).*/\1 Solar webconferência/' \
-e 's/\(copyright:\).*/\1 'Solar webconferência - ©2019 BigBlueButton Inc.'/' \
-e 's/\(helpLink:\).*/\1 http:\/\/solar.virtual.ufc.br\/webconferences?request_support=true/' /usr/share/meteor/bundle/programs/server/assets/app/config/settings.yml
echo '$(date +%F\ %T) - clientTitle - OK' >> $LOG
echo '$(date +%F\ %T) - copyright - OK' >> $LOG
echo '$(date +%F\ %T) - helpLink - OK' >> $LOG

# Let’s Encrypt
echo '$(date +%F\ %T) - Let’s Encrypt...' >> $LOG
echo '$(echo '30 2 * * 1 /usr/bin/letsencrypt renew >> /var/log/le-renew.log' ; crontab -e)' | crontab -
echo '$(echo '35 2 * * 1 /bin/systemctl reload nginx' ; crontab -e)' | crontab -
echo '$(date +%F\ %T) - Let’s Encrypt - OK' >> $LOG

# Mudando a cor da barra do título
echo '$(date +%F\ %T) - Baixando head.css...' >> $LOG
wget --no-check-certificate 'https://docs.google.com/uc?export=download&id=1sGDbD600k_I-dllToCyO16bsxrblQXFa' -O head.html
echo '$(date +%F\ %T) - Copiando...' >> $LOG
sudo cp ~/head.html /usr/share/meteor/bundle/programs/web.browser/head.html
echo '$(date +%F\ %T) - Alterando propriedade...' >> $LOG
sudo chown meteor:meteor /usr/share/meteor/bundle/programs/web.browser/head.html
echo '$(date +%F\ %T) - Alterando permissões...' >> $LOG
sudo chmod 444 /usr/share/meteor/bundle/programs/web.browser/head.html
echo '$(date +%F\ %T) - Barra do Título - OK' >> $LOG

# Aúdio em pt_BR
echo '$(date +%F\ %T) - Áudio em pt-BR...' >> $LOG
echo '$(date +%F\ %T) - Áudio em pt-BR - OK' >> $LOG

# Restart
echo '$(date +%F\ %T) - Configuração finalizada' >> $LOG
echo '$(date +%F\ %T) - Reiniciando serviço...' >> $LOG
sudo systemctl restart bbb-html5
#sudo systemctl restart bbb-html5.service
sudo bbb-conf --restart