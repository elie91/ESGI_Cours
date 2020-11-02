# API Platform

API Platform is a next-generation web framework designed to easily create API-first projects without compromising extensibility and flexibility

## Motivation & AVantages

* Design your own data model as plain old PHP classes or [import an existing one](https://api-platform.com/docs/schema-generator/) from the [Schema.org](https://schema.org/) vocabulary
* Expose in minutes a hypermedia REST or a GraphQL API with pagination, data validation, access control, relation embedding, filters and error handling...
* Benefit from Content Negotiation: GraphQL, JSON-LD, Hydra, HAL, JSONAPI, YAML, JSON, XML and CSV are supported out of the box
* Enjoy the beautiful automatically generated API documentation
* Add a [convenient Material Design administration](https://api-platform.com/docs/admin/) interface built with React without writing a line of code.
* Scaffold fully functional Progressive-Web-Apps and mobile apps built with React, Vue.js or React Native thanks to the client generator
* Install a development environment and deploy your project in production using Docker and Kubernetes.
* Easily add JSON Web Token or OAuth authentication.
* Create specs and tests with a developer friendly API testing tool on top of [Behat](https://behat.org/en/latest/).
* Compatible with most Symfony bundles

## Tech/framework used

* The [Symfony 4 microframework](https://symfony.com/doc/current/setup/flex.html) 
* The [Doctrine ORM](https://www.doctrine-project.org/projects/orm.html)
* The [API Platform Admin](https://api-platform.com/docs/admin/), built on top of [React Admin](https://marmelab.com/react-admin/)
* The [API Platform Client Generator](https://api-platform.com/docs/client-generator/) to scaffold React, Vue, React Native, Next.js and Quasar apps in      one command, from any Hydra API
* A [Docker-based setup](https://www.docker.com/) to bootstrap the project in a single command, providing:
    1. Servers for the API and JavaScript apps
    2. A [Varnish Cache](https://varnish-cache.org/) server enabling API Platform's [built-in invalidation cache mechanism](https://api-platform.com/docs/core/performance/#enabling-the-built-in-http-cache-invalidation-system)
    3. A development HTTP/2 and HTTPS proxy (allowing, for instance, to test the provided service workers)
    4. A [Helm](https://helm.sh/) chart to deploy the API in any [Kubernetes](https://kubernetes.io/) cluster
* The API testing tool build on top of [Behat](https://behat.org/en/latest/).
 
## Requirements

* Docker (Docker Machine is not supported out of the box for Windows and Mac)

## Installation

Open a terminal, and navigate to the directory containing your project skeleton
Run the following command to start all services using Docker Compose:

`docker-compose pull`   #Download the latest versions of the pre-built images
`docker-compose up -d`  #Running in detached mode


## How to use

To make an API easily, you can use 3 differents languages : PHP, YAML, and XML.
1. First, we have PHP syntax :
    ```PHP
         <?php
        // api/src/Entity/Book.php
        namespace App\Entity;
        
        use ApiPlatform\Core\Annotation\ApiResource;

        /**
        * @ApiResource(
        *     collectionOperations={"get"={"method"="GET"}},
        *     itemOperations={"get"={"method"="GET"}}
        * )
        */
        class Book
        {
            // ...
        }
        ?>
    ```
2. Seccondly we have the YAML syntax :
    ```YAML
    # api/config/api_platform/resources.yaml
    App\Entity\Book:
        collectionOperations:
            get: ~ # nothing more to add if we want to keep the default controller
        itemOperations:
            get: ~
    ```
3. As a third syntax, we have the XML :
    ```XML
    <?xml version="1.0" encoding="UTF-8" ?>
    <!-- api/config/api_platform/resources.xml -->
    <resources xmlns="https://api-platform.com/schema/metadata"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="https://api-platform.com/schema/metadata
            https://api-platform.com/schema/metadata/metadata-2.0.xsd">
        <resource class="App\Entity\Book">
            <itemOperations>
                <itemOperation name="get" />
            </itemOperations>
            <collectionOperations>
                <collectionOperation name="get" />
            </collectionOperations>
        </resource>
    </resources>
    ```
These three syntaxes allows you to use your favorite language

## Documentation

The full documentation is available [here](https://api-platform.com/docs/distribution/).

## Deployment
API Platform apps are super easy to deploy in production on most cloud providers thanks to the native integration with [Kubernetes](https://api-platform.com/docs/deployment/kubernetes/).

The server part of API Platform is basically a standard Symfony application, which you can also easily deploy on your [own servers](https://symfony.com/doc/current/deployment.html). Documentation for deploying on various container [orchestration](https://en.wikipedia.org/wiki/Orchestration_(computing)) tools and PaaS (Platform as a Service) are also available:

* [Deploying to a Kubernetes Cluster](https://api-platform.com/docs/deployment/kubernetes/)
* [Deploying with Docker Compose](https://api-platform.com/docs/deployment/docker-compose/)
* [Deploying on Heroku](https://api-platform.com/docs/deployment/heroku/)
* [Deploying on Platform.sh](https://platform.sh/blog/deploy-api-platform-on-platformsh/)


## Contributing
[API Platform Core Library](https://github.com/api-platform/core/blob/master/CONTRIBUTING.md)
[API Platform Schema Generator](https://github.com/api-platform/schema-generator/blob/master/CONTRIBUTING.md)
[API Platform Admin](https://github.com/api-platform/admin/blob/master/CONTRIBUTING.md)
[API Platform CRUD Generator](https://github.com/api-platform/client-generator/blob/master/CONTRIBUTING.md)

## Licence

Created by [Kévin Dunglas](https://dunglas.fr/). Commercial support available at [Les-Tilleuls.coop.](https://les-tilleuls.coop/fr)
