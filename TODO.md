
TODO
====

* Create a centos6 buildpack-deps image

* Set a docker registry with delete support (See [deploy][deploying-registry])
  * integrate it with [delete-docker-registry-image][delete-docker.registry-image]
  * configure [storage]
  * write scripts to get [tags], catalogs, etc
  * remove [orphain images][orphan-images]?
  * more info on deleting images: [here][delete-images1] and [here][delete-images2]
  * registri [API][registry-api]?

[delete-docker-registry-image]: https://github.com/burnettk/delete-docker-registry-image
[deploying-registry]: https://docs.docker.com/registry/deploying/
[registry-storage]: https://docs.docker.com/registry/configuration/#storage
[registry-tags]: https://stackoverflow.com/questions/31251356/how-to-get-a-list-of-images-on-docker-registry-v2
[orphan-images]: https://gist.github.com/kwk/c5443f2a1abcf0eb1eaa
[delete-images1]: https://stackoverflow.com/questions/25436742/deleting-images-from-a-private-docker-registry
[delete-images2]: https://forums.docker.com/t/delete-repository-from-v2-private-registry/16767
[registry-api]: https://docs.docker.com/registry/spec/api/

* Use [environment file][environment-file] to store environment variables in
  docker composed images

[environment-file]: https://docs.docker.com/compose/compose-file/#environment

* Add [django-debug-toolbar][django-toolbar] to composed django image

[django-toolbar]: https://django-debug-toolbar.readthedocs.io/en/stable/index.html

* manage sensitive data using secret in docker-compose, as described
  [here][secret1] and [here][secret2]

[secret1]: https://docs.docker.com/engine/swarm/secrets/#use-secrets-in-compose
[secret2]: https://docs.docker.com/compose/compose-file/#secrets

