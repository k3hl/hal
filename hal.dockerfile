FROM node:latest
MAINTAINER k3hl

#INTALL CoffeeScript, Hubot, Slack+HipChat adapters
RUN \
   npm -install -g coffee-script hubot yo generator-hubot && \
   apt-get -q update && \
   apt-get install -y git-core && \
   rm -rf /var/lib/apt/lists/*

#make a user for HAL
RUN groupadd -g 501 HAL
RUN useradd -m -u 501 -g 501 HAL
WORKDIR /home/HAL/bot

# make directories and files
RUN mkdir -p /home/HAL/.config/configstore && \
  echo "optOut: true" > /home/HAL/.config/configstore/insight-yo.yml && \
  chown -R HAL:HAL /home/HAL

USER HAL

#adding ENV vars for HAL deployment
ENV HUBOT_OWNER HAL
ENV HUBOT_NAME HAL
ENV HUBOT_ADAPTER slack
ENV HUBOT_DESCRIPTION I'm sorry Dave, I'm just a bot

# RUN HAL
CMD /usr/local/bin/yo hubot --adapter $HUBOT_ADAPTER \
                            --owner $HUBOT_OWNER \
                            --name $HUBOT_NAME \
                            --description $HUBOT_DESCRIPTION \
                            --defaults && bin/hubot \
                            --adapter $HUBOT_ADAPTER
