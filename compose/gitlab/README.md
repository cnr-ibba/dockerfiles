
Running GitLab Community Edition
================================

These are simple instructions to run [GitLab CE][gitlab-ce] usind docker. This
project derives from [Run GitLab on a USB Stick with Docker][gitlab-usb]. The key
idea is to put this image in production on a docker infrastructure. Check out the
last GitLab CE stable image from [Docker Hub][gitlab-tags] at the moment is `9.2.7-ce.0`.
Then set it in docker compose file, for example

```yaml
services:
  gitlab:
    container_name: gitlab
    image: gitlab/gitlab-ce:9.2.7-ce.0
```

You may want to deploy GitLab on your site on a different default port. Modify
environment and ports accordingly your needs

```yaml
environment:
  GITLAB_OMNIBUS_CONFIG: |
    external_url 'http://127.0.0.1:8050'
    gitlab_rails['gitlab_shell_ssh_port'] = 522

ports:
  - "8050:8050"
  - "522:22"
```

More information on GitLab on docker could be found [here][gitlab-docker1] and
[here][gitlab-docker2].

[gitlab-ce]: https://docs.gitlab.com/ce/README.html
[gitlab-usb]: https://blog.sixeyed.com/run-gitlab-on-a-usb-stick-with-docker/
[gitlab-tags]: https://hub.docker.com/r/gitlab/gitlab-ce/tags/
[gitlab-docker1]: https://hub.docker.com/r/gitlab/gitlab-ce/
[gitlab-docker2]: https://docs.gitlab.com/omnibus/docker/README.html
