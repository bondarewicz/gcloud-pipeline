echo "Step 1 - Variables"

export _BRANCH_NAME=$(git symbolic-ref --short HEAD | tr '//' '-')
echo "_BRANCH_NAME:" ${_BRANCH_NAME};

export _USER=$(whoami)
echo "_USER:" ${_USER};

export _PROJECT_ID=parcel-vision
echo "_PROJECT_ID:" ${_PROJECT_ID};

export _SHORT_SHA=$(git rev-parse --short HEAD)
echo "_SHORT_SHA:" $_SHORT_SHA;

######################################################

echo "Step 2 - Docker images"
docker build -t eu.gcr.io/${_PROJECT_ID}/gcloud-pipeline:${_USER}-${_BRANCH_NAME}-${_SHORT_SHA} .

######################################################

echo "Step 3 - Substitutions in yaml"

echo "_USER & _BRANCH_NAME ?"
echo ${_USER}-${_BRANCH_NAME}

sed -i -e "s|eu.gcr.io/parcel-vision/gcloud-pipeline:.*|eu.gcr.io/parcel-vision/gcloud-pipeline:${_USER}-${_BRANCH_NAME}-${_SHORT_SHA}|" ./kubernetes/deployments/local/gcloud-pipeline-local.yaml
rm ./kubernetes/deployments/local/*.yaml-e

######################################################

echo "Step 4 - Namespaces"

# TODO
# when we are on k8s 1.11 we can use kubectl wait --for=delete namespace ${_USER}-${_BRANCH_NAME} --timeout=120s 
# see https://v1-11.docs.kubernetes.io/docs/reference/generated/kubectl/kubectl-commands#wait

kubectl delete ns ${_USER}-${_BRANCH_NAME}
echo "wait 60sec to complete"
sleep 60s

kubectl create ns ${_USER}-${_BRANCH_NAME}
kubectl get namespaces

######################################################

echo "Step 5 - Deployment"

kubectl apply --namespace ${_USER}-${_BRANCH_NAME} --recursive -f kubernetes/deployments/local
kubectl apply --namespace ${_USER}-${_BRANCH_NAME} --recursive -f kubernetes/services

echo "wait 30sec to complete"
sleep 30s
echo $(date); 
curl http://localhost/
