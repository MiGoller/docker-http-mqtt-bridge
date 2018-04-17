# Simply a HTTP to MQTT bridge

The idea of creating HTTP to MQTT bridge stroke me when I was trying to integrate IFTTT with my OpenHab installation. Right now there is no MQTT service available in [IFTTT](https://ifttt.com/about) and I still have to use [Maker Webhooks](https://ifttt.com/maker_webhooks) to fire HTTP-request against some APIs.

## Using the image
The image contains a webserver and exposes port 5000 by default. To start the container type:
```
$ docker run -d -p 5000:5000 migoller/http-mqtt-bridge
```

### Configure the image by environment variables
By default the `http_to_mqtt` will listen on port 5000 and connect to the localhost MQTT Broker. 

Well, the image does not contain a local MQTT broker. Set the following environment variables accordingly to determine your MQTT broker.
* AUTH_KEY: Set this value to a very special string. It's like a secret API key!
* MQTT_HOST: Set this value to the URL to your MQTT broker (eg. mqtts://k99.cloudmqtt.com:21234)
* MQTT_USER: Set to your username for authentication on your MQTT broker.
* MQTT_PASS: Set to your password accordingly to your username for authentication.

Please have a look at [petkov's HTTP to MQTT bridge](https://github.com/petkov/http_to_mqtt) for more details!

```
docker run -d \
    -p 5000:5000 \
    -e AUTH_KEY=912ec803b2ce49e4a541068d495ab570 \
    -e MQTT_HOST=mqtts://k99.cloudmqtt.com:21234 \
    -e MQTT_USER=<YourUsernameHere> \
    -e MQTT_PASS=<YourPasswordHere> \
    migoller/http-mqtt-bridge
```

## Publish to a topic
Setup and run the docker image ;-) .

Now lets publish a message to the topic 'MyTopic'
```bash
curl -H "Content-Type: application/json" "http://<HostnameOfYourDockerHost>:5000/post"  -d '{"topic" : "MyTopic", "message" : "Hello World" }'
```

output:
```
OK
```

You may want to build URLs dynamically to publish messages with a simple HTTP-call. In that case you will have to provide some query parameters to tell http_to_mqtt to handle certain things specific to your use case.
* topic=/MyTopic/TestTopic : Set to a valid topic.
* path=payload : This is the message you want to publish to the topic.

```
http://<HostnameOfYourDockerHost>:5000/post?topic=/MyTopic/TestTopic&path=payload
```

## HTTPS - SSL encryption for transport security
There are many different possibilities to introduce encryption depending on your setup. 

I recommend using a reverse proxy in front of your installation using the popular [nginx-proxy](https://github.com/jwilder/nginx-proxy) and [docker-letsencrypt-nginx-proxy-companion](https://github.com/JrCs/docker-letsencrypt-nginx-proxy-companion) containers. Please check the according documentations before using this setup.

## Thanks

This idea goes back to [petkov's HTTP to MQTT bridge](https://github.com/petkov/http_to_mqtt) based on Node JS. Thank you very much for this simple and reliable piece of code!
