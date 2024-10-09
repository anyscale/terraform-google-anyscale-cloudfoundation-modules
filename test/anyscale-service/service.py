from fastapi import FastAPI
from ray import serve
import os

# Use this var to test service inplace update. When the env var is updated, users see new return value.
msg = os.getenv("SERVE_RESPONSE_MESSAGE", "Hello world!")

app = FastAPI()


@serve.deployment(route_prefix="/")
@serve.ingress(app)
class HelloWorld:
    @app.get("/")
    def hello(self):
        return msg

    @app.get("/healthcheck")
    def healthcheck(self):
        return


entrypoint = HelloWorld.bind()

# The following block will be executed if the script is run by Python directly
if __name__ == "__main__":
    serve.run(entrypoint)
