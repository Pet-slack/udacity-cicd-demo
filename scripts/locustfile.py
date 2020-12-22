from locust import HttpUser, TaskSet, task

class UserBehavior(TaskSet):

    @task
    def get_tests(self):
        self.client.get("/")

    @task
    def put_tests(self):
        self.client.post("/predict", {
						  "name": "load testing",
						  "description": "checking if a software can handle the expected load"
						})

class WebsiteUser(HttpUser):
    task_set = UserBehavior
