import time
from locust import HttpUser, task, between, tag

class Tester(HttpUser):
    wait_time = between(1, 2.5)

    @tag('get')
    @task
    def make_get_request(self):
        self.client.verify = False
        self.client.get("/get")

    @tag('post')
    @task
    def make_post_request(self):
        self.client.verify = False
        self.client.post("/post")

    @tag('put')
    @task
    def make_put_request(self):
        self.client.verify = False
        self.client.put("/put")

    @tag('delete')
    @task
    def make_delete_request(self):
        self.client.verify = False
        self.client.delete("/delete")