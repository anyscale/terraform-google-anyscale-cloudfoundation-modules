import ray

# Initialize Ray
ray.init()


@ray.remote
def hello_world():
    return "Hello, World!"


# Execute the remote function in parallel
futures = [hello_world.remote() for _ in range(4)]

# Get and print the results
results = ray.get(futures)
print(results)

# Shut down Ray
ray.shutdown()
