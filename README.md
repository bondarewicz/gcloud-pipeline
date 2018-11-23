## tldr;

```
npm install 
npm start
```

```
gcloud auth configure-docker
docker build -t eu.gcr.io/parcel-vision/gcloud-pipeline:latest .
docker push eu.gcr.io/parcel-vision/gcloud-pipeline:latest
```

```
sh ./builder/localbuild.sh 
```

### env
```
export CLUSTER=dev-cluster
export PROJECT_ID=parcel-vision
export ZONE=europe-west2-a
```

### create cluster 

```
gcloud container clusters create ${CLUSTER} \
    --project=${PROJECT} \
    --zone=${ZONE} \
    --quiet
```

### triggers

```
branch - "[^(?!.*master)].*"
master - "master"
tag    - ".*"
```

### branches to namespaces (dev cluster)


* new branch of master (`ex. pvr-123-wip`)
* make changes to `index.js`
* build locally - `sh ./builder/localbuild.sh`
* build & deploy:
    ```
    cloud-build-local --config=builder/cloudbuild-local.yaml --substitutions=_USER=$(whoami),_BRANCH_NAME=$(git symbolic-ref --short HEAD | tr '//' '-') --dryrun=false .
    ```
* `gcloud builds submit --config builder/cloudbuild-local.yaml --substitutions=_USER=$(whoami),BRANCH_NAME=$(git symbolic-ref --short HEAD | tr '//' '-') .`
* `gcloud builds list --filter "tags='pipeline'"`
* `gcloud builds log f694f919-5e9b-4400-abce-46b1e98f63f9`


gist

```
git checkout -b lukasz-wip-xyz
cat index.js
vi index.js 
i
changes + esc
:wq!

sh ./builder/localbuild.sh 
or
cloud-build-local --config=builder/cloudbuild-local.yaml --substitutions=_USER=$(whoami),_BRANCH_NAME=$(git symbolic-ref --short HEAD | tr '//' '-') --dryrun=false .

git add .
git commit -m "wip-xyz"
git push gcp new-feature

kubectl scale deployment gcloud-pipeline-production -n production --replicas 4

kubectx gke_parcel-vision_europe-west2-a_dev-cluster

export SERVICE_IP=$(kubectl get -o jsonpath="{.status.loadBalancer.ingress[0].ip}" --namespace=production services gcloud-pipeline)

while true; do sleep 1; echo -e '\n'; echo $(date); curl http://$SERVICE_IP/;done
```