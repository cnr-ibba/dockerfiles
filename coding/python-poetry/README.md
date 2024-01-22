# Python-poetry

This dockerfile is an attempt to manage a python environment with poetry in a
docker container. The building process is structured in order to take advantages of
[multi-stage builds](https://docs.docker.com/build/building/multi-stage/): in
the first stage, there are instructions to install all requirements and to build
python packages, which are installed in a virtual environment through poetry. Then,
in the second build stage, the virtual environment folder is copied from the first
stage, in order to keep images thin and to run applications with minimal requirements.

## About virtual environments

It's not strictly required to install packages in a virtual environment when
running a docker container, and there are other examples where poetry is installed
without a virtual environment (for example, see
[here](https://medium.com/@harpalsahota/dockerizing-python-poetry-applications-1aa3acb76287)).
However, installing packages within a virtual environment lets you to exploit
the `COPY --from` command between docker multi-staged builds and keep smaller
images.

## References

Here a list of some articles which inspired this `Dockerfile`:

- [Multi-Stage Dockerfiles and Python Virtualenvs](https://pmac.io/2019/02/multi-stage-dockerfile-and-python-virtualenv/)
- [Integrating Python Poetry with Docker](https://stackoverflow.com/questions/53835198/integrating-python-poetry-with-docker)
- [Python and Poetry on Docker](https://bmaingret.github.io/blog/2021-11-15-Docker-and-Poetry)
- [Efficient Python Docker Image from any Poetry Project](https://denisbrogg.hashnode.dev/efficient-python-docker-image-from-any-poetry-project)
- [Python Poetry for Building Docker Images](https://binx.io/2022/06/13/poetry-docker/)
