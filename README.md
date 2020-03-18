# DevOps challenge

## Requirements

To deploy this complete stack you have to be available this following requirements:
* docker command
* kubectl command
* envsubst command
* local docker registry available. If you don't have any local registry you can execute:
```
$ make registry
```

### Architecture

For the Architecture scenario I used:
* Web Proxy: A Traefik Reverse Proxy instead of Nginx Reverse Proxy (If it's a problem I can apply an nginx ingress controller if you want)
* Web Application: A NodeJS + Express application with a /hello endpoint exposed at 8080 port.

### Web Application

I have created a simple NodeJS + Express application with a simple index.js script that catch the /hello request and returns the following response:

> `GET /hello`
> Expected response: `{ "hello": "world" }`
> Expected status: `200`

Example:
```
$ curl http://localhost:8080/hello
{ "hello": "world" }
```
I've generated the application with a Docker image for CD (Continuous Delivery) purposes.

### Web Proxy

I've created this Traefik reverse proxy instead of Nginx because I usually use this proxy and I think that acomplish the 100% of the functionallity that you have requested in the challenge. The proxy handles all 80 and 443 requests and consumes the Kubernetes services exposed throught Kubernetes Ingresses.

In this deployment I have included some configmaps for self certificate creation. In a production ready environment I would like to use an Acme TLS challenge with Let's Encrypt (for example).

Requirements for the proxy:
* Pass `HTTP` (port 80) requests to the backend application (port 8080)
* Pass `HTTPS` requests (port 443) to the backend application (port 8080) **(OPTIONAL)**
  * In case `HTTPS` is implemented, redirect port 80 requests to 443

For the HTTPS redirection do you have the configuration commented in traefik.toml to be able to test both endpoints, but if you want, uncomment this code:

Example:
```
[entryPoints.http]
    ...
    [entryPoints.http.redirect]
    entryPoint = "https"
    permanent = true
```

And all requests received to http endpoint (:80) will be redirected to the https endpoint (:443)

## Deployment

For deployment I've used a combination with Makefile and bash script. I could use Ansible for example to do that but I'm feeling more confortable with Makefiles and bash right now. Of course, is not a problem for me change my mind and apply any other techniques with Ansible, Puppet or whatever.

To deploy the complete stack you only have to execute:

```
$ make
```
And then you can make the challenge request to see the result:
```
$ curl -L http://IP_ADDRESS/hello
{ "hello": "world" }
```
