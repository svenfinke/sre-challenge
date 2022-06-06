## Welcome

We're really happy that you're considering joining us!
This challenge will help us understand your skills and will also be a starting point for the next interview.
We're not expecting everything to be done perfectly as we value your time but the more you share with us, the more we get to know about you!

This challenge is split into 3 parts:

1. Debugging
2. Implementation
3. Questions

If you find possible improvements to be done to this challenge please let us know in this readme and/or during the interview.

## The challenge

Pleo runs most of its infrastructure in Kubernetes.
It's a bunch of microservices talking to each other and performing various tasks like verifying card transactions, moving money around, paying invoices, ...
This challenge is similar but (a lot) smaller :D

In this repo, we provide you with:

- `invoice-app/`: An application that gets invoices from a DB, along with its minimal `deployment.yaml`
- `payment-provider/`: An application that pays invoices, along with its minimal `deployment.yaml`
- `Makefile`: A file to organize commands.
- `deploy.sh`: A file to script your solution
- `test.sh`: A file to perform tests against your solution.

### Set up the challenge env

1. Fork this repository
2. Create a new branch for you to work with.
3. Install any local K8s cluster (ex: Minikube) on your machine and document your setup, so we can run your solution.

#### Setup

I am running on macOS with Apple Silicon. Docker Desktop and Minikube are installed on my machine.

1. `minikube start --driver=docker`
2. `make build`
3. `make deploy`

### Part 1 - Fix the issue

The setup we provide has a :bug:. Find it and fix it! You'll know you have fixed it when the state of the pods in the namespace looks similar to this:

```
NAME                                READY   STATUS                       RESTARTS   AGE
invoice-app-jklmno6789-44cd1        1/1     Ready                        0          10m
invoice-app-jklmno6789-67cd5        1/1     Ready                        0          10m
invoice-app-jklmno6789-12cd3        1/1     Ready                        0          10m
payment-provider-abcdef1234-23b21   1/1     Ready                        0          10m
payment-provider-abcdef1234-11b28   1/1     Ready                        0          10m
payment-provider-abcdef1234-1ab25   1/1     Ready                        0          10m
```

#### Requirements

Write here about the 🐛, the fix, how you found it, and anything else you want to share about it.

#### Solution

The **bug** was the definition of the pods to run as root, even though that is not allowed by default and should not be done if possible. After removing the securityContext from the deployment files, the pods were starting without further issues. But this might lead to other bugs if the pods have to run as root and this was intentional, I'd get into contact with the developers who worked on this change and check if they need to run as root.

### Part 2 - Setup the apps

We would like these 2 apps, `invoice-app` and `payment-provider`, to run in a K8s cluster and this is where you come in!

#### Requirements

1. `invoice-app` must be reachable from outside the cluster.
2. `payment-provider` must be only reachable from inside the cluster.
3. Update existing `deployment.yaml` files to follow k8s best practices. Feel free to remove existing files, recreate them, and/or introduce different technologies. Follow best practices for any other resources you decide to create.
4. Provide a better way to pass the URL in `invoice-app/main.go` - it's hardcoded at the moment
5. Complete `deploy.sh` in order to automate all the steps needed to have both apps running in a K8s cluster.
6. Complete `test.sh` in order to perform tests against your solution and get successful results (all the invoices are paid) via `GET invoices`.

#### Solution

I added service definitions for both invoice-app and payment-provider, with invoice being exposed via NodePort and payment-provider being ClusterIP to ensure that one is available from the outside, the other one isn't.
To follow more best practices I combined the service and deployment files for each application and added additional labels, it would probably be a good idea to add additional common k8s labels in real project.
After having that in place I thought again about the deployment process and changes that in a few steps so that I'd add a rollout to ensure that new images would be used. Having this rollout I also had to make sure that the deployment will wait until the rollout is finished.
The test.sh will check for an expected amount of unpaid invoices, pay them and check if they have been paid.

### Part 3 - Questions

Feel free to express your thoughts and share your experiences with real-world examples you worked with in the past.

#### Requirements

1. What would you do to improve this setup and make it "production ready"?
2. There are 2 microservices that are maintained by 2 different teams. Each team should have access only to their service inside the cluster. How would you approach this?
3. How would you prevent other services running in the cluster to communicate to `payment-provider`?

## What matters to us?

Of course, we expect the solution to run, but we also want to know how you work and what matters to you as an engineer.
So, feel free to use any technology you want!
You can create new files, refactor, rename, ...

Ideally, we'd like to see your progression through commits, verbosity in your answers and all requirements met.
Don't forget to update the README.md to explain your thought process.
