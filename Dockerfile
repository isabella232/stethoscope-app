FROM electronuserland/builder:wine
COPY . .
RUN yarn install