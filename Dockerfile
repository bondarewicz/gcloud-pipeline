FROM mhart/alpine-node:11.2
ADD . /src
RUN cd /src; npm install
EXPOSE  8080
CMD ["node", "/src/index.js"]