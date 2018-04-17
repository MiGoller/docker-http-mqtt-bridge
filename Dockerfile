#
#   BUILD image
#
FROM node:8-alpine AS build

# Create the working dir
RUN mkdir -p /build

WORKDIR /build

# Install package dependencies
RUN apk add --update --no-cache python pkgconfig make g++ git

# Clone the source repo
RUN mkdir master_temp
RUN git clone https://github.com/petkov/http_to_mqtt.git master_temp
RUN cp -R -f master_temp/* .
RUN rm -rf master_temp

# Install app
RUN npm install

#
#   RUNTIME image
#
FROM node:8-alpine AS runtime

LABEL Author="MiGoller"

# Set environment variables to default values
ENV AUTH_KEY=SetToSomethingVerySpecial

COPY --from=build /build /app

WORKDIR /app

# Install NodeJS dependencies
RUN npm install pm2 -g

# Copy PM2 config
COPY pm2app.yml .

EXPOSE 5000

CMD ["pm2-docker", "pm2app.yml"]
